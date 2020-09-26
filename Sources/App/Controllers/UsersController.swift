//
//  UserController.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor
import Fluent

struct UserSignUp: Content {
  let email: String
  let password: String
  let gender: String
}

struct NewSession: Content {
  let token: String
  let user: User.Public
}

extension UserSignUp: Validatable {
  static func validations(_ validations: inout Validations) {
    validations.add("email", as: String.self, is: !.empty)
    validations.add("password", as: String.self, is: .count(1...))
  }
}

struct UsersController: RouteCollection {

  func boot(routes: RoutesBuilder) throws {
    let usersRoute = routes.grouped("api", "users")
    usersRoute.post("signup", use: create)

    let tokenProtected = usersRoute.grouped(Token.authenticator())
    tokenProtected.get("account", use: get)

    let passwordProtected = usersRoute.grouped(User.authenticator())
    passwordProtected.post("login", use: login)
  }

  /// Create a user to the database and retrieve a token and the public profile
  ///
  func create(_ req: Request) throws -> EventLoopFuture<NewSession> {

    try UserSignUp.validate(content: req)
    let userSignUp = try req.content.decode(UserSignUp.self)
    let user = try User.create(from: userSignUp)
    var token: Token!

    return checkIfUserExists(userSignUp.email, req: req)
      .flatMap { exists in
        guard !exists else {
          return req.eventLoop.future(error: UserError.emailAlreadyUsed)
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

  /// Fetch one user with id store in database
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
}

extension UsersController {
  func checkIfUserExists(_ email: String, req: Request) -> EventLoopFuture<Bool> {
    User.query(on: req.db)
      .filter(\.$email == email)
      .first()
      .map { $0 != nil }
  }
}
