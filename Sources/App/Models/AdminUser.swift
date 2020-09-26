//
//  AdminUser.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor
import Fluent

//  MARK: AdminUser
/// Administrator account at first data base initialization.
///
/// credentials:
///   - email: registered@email.com
///   - password: password
///
struct AdminUser: Migration {
  
  func prepare(on connection: Database) -> EventLoopFuture<Void> {

    let password = try? Bcrypt.hash("password")
    guard let hashedPassword = password else {
      return connection.eventLoop.future(error: Abort(.expectationFailed))
    }

    let user = User(email: "registered@email.com",
                    password: hashedPassword,
                    gender: "male")

    return user.save(on: connection).transform(to: ())
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema).delete()
  }
}
