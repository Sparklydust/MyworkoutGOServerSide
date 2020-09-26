//
//  UserController.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor

struct UsersController: RouteCollection {

  func boot(routes: RoutesBuilder) throws {
    let usersRoute = routes.grouped("api", "users")
    usersRoute.post(use: createHandler)
    usersRoute.get(use: getAllHandler)
    usersRoute.get(":userID", use: getHandler)
  }

  /// Create a user to the database
  ///
  func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
    let user = try req.content.decode(User.self)
    return user.save(on: req.db).map { user }
  }

  /// Fetch all users store in the database
  ///
  func getAllHandler(_ req: Request) throws -> EventLoopFuture<[User]> {
    User.query(on: req.db).all()
  }

  /// Fetch one user with id store in database
  ///
  func getHandler(_ req: Request)throws -> EventLoopFuture<User> {
    User.find(req.parameters.get("userID"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }
}
