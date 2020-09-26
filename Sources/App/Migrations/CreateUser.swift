//
//  CreateUser.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Fluent

//  MARK: CreateUser
/// Creation of the user psql table.
///
struct CreateUser: Migration {

  func prepare(on database: Database) -> EventLoopFuture<Void> {
    
    database.schema(User.schema)
      .id()
      .field("email", .string, .required)
      .field("password", .string,.required)
      .field("gender", .string, .required)
      .unique(on: "email")
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema).delete()
  }
}
