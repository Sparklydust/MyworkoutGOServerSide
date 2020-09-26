//
//  CreateUser.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Fluent

struct CreateUser: Migration {

  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("users")
      .id()
      .field("email", .string, .required)
      .field("gender", .string, .required)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("users").delete()
  }
}
