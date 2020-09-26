//
//  CreateToken.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Fluent

//  MARK: CreateToken
/// Creation of the token psql table.
///
struct CreateToken: Migration {

  func prepare(on database: Database) -> EventLoopFuture<Void> {

    database.schema(Token.schema)
      .id()
      .field("user_id", .uuid, .references("users", "id"))
      .field("value", .string, .required)
      .field("source", .int, .required)
      .unique(on: "value")
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Token.schema).delete()
  }
}
