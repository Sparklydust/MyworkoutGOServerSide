//
//  UserController.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor
import Fluent

//  MARK: UsersController
/// Responsible for api path to handle all user
/// data.
///
struct UsersController: RouteCollection {

  /// Definition of api endpoints with associated method.
  ///
  func boot(routes: RoutesBuilder) throws {

    let usersRoute = routes.grouped("api", "users")
    usersRoute.post("signup", use: create)
    usersRoute.get("accounts", use: getAll)

    let tokenProtected = usersRoute.grouped(Token.authenticator())
    tokenProtected.get("account", use: get)

    let passwordProtected = usersRoute.grouped(User.authenticator())
    passwordProtected.post("login", use: login)
  }

  /// Create a user to the database and retrieve a token and the public profile.
  ///
  func create(_ req: Request) throws -> EventLoopFuture<NewSession> {

    try UserSignUp.validate(content: req)
    let userSignUp = try req.content.decode(UserSignUp.self)
    let user = try User.create(from: userSignUp)
    var token: Token!

    return checkIfUserExists(userSignUp.email, req: req)
      .flatMap { exists in
        guard !exists else {
          return req.eventLoop.future(error: NetworkError.emailAlreadyUsed)
        }
        return user.save(on: req.db) }
      .flatMap {
        guard let newToken = try? user.createToken(source: .signUp) else {
          return req.eventLoop.future(error: Abort(.internalServerError))
        }
        token = newToken
        return token.save(on: req.db) }
      .flatMapThrowing {
        NewSession(token: token.value, user: try user.asPublic())
      }
  }

  /// Fetch one user with id store in database.
  ///
  func get(_ req: Request) throws -> User.Public {
    try req
      .auth
      .require(User.self)
      .asPublic()
  }

  /// Log in user with valid email and password.
  ///
  func login(req: Request) throws -> EventLoopFuture<NewSession> {
    let user = try req.auth.require(User.self)
    let token = try user.createToken(source: .logIn)

    return token
      .save(on: req.db)
      .flatMapThrowing {
        NewSession(token: token.value, user: try user.asPublic())
      }
  }

  /// Get all users from api.
  ///
  func getAll(req: Request) throws -> EventLoopFuture<[User.Public]> {
    User
      .query(on: req.db)
      .all()
      .flatMapThrowing { users in
        try users.map { user in
          try user.asPublic()
        }
      }
  }
}

extension UsersController {
  /// Looking for existing user in the database with email.
  ///
  func checkIfUserExists(_ email: String, req: Request) -> EventLoopFuture<Bool> {
    User
      .query(on: req.db)
      .filter(\.$email == email)
      .first()
      .map { $0 != nil }
  }
}
