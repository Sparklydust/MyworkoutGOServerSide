//
//  AdminUser.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor
import Fluent

struct AdminUser: Migration {
  func prepare(on connection: Database) -> EventLoopFuture<Void> {
    let user = User(email: "registered@email.com", password: "password", gender: "male")
    return user.save(on: connection).transform(to: ())
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema).update()
  }
}
