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
    validations.add("password", as: String.self, is: .count(6...))
  }
}

struct UsersController: RouteCollection {

  func boot(routes: RoutesBuilder) throws {
    let usersRoute = routes.grouped("api", "users")

    usersRoute.post("signUp", use: create)
    usersRoute.get("all", use: getAll)
    usersRoute.get("userID", use: get)
  }

  /// Create a user to the database
  ///
  func create(_ req: Request) throws -> EventLoopFuture<NewSession> {

    try UserSignUp.validate(content: req)
    let userSignUp = try req.content.decode(UserSignUp.self)
    let user = try User.create(from: userSignUp)
    let token: Token!

    return checkIfUserExists(userSignUp.email, req: req)
      .flatMap { exists in
        guard !exists else {
          return req.eventLoop.future(error: UserError.emailAlreadyUsed)
        }
        return user.save(on: req.db)
      }
      .flatMapThrowing {
        NewSession(token: token.value, user: try user.asPublic())
      }
  }

  /// Fetch all users store in the database
  ///
  func getAll(_ req: Request) throws -> EventLoopFuture<[User]> {
    User.query(on: req.db).all()
  }

  /// Fetch one user with id store in database
  ///
  func get(_ req: Request)throws -> EventLoopFuture<User> {
    User.find(req.parameters.get("userID"), on: req.db)
      .unwrap(or: Abort(.notFound))
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
