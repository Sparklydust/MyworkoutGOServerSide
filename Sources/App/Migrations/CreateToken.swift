//
//  CreateToken.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Fluent

struct CreateToken: Migration {

  func prepare(on database: Database) -> EventLoopFuture<Void> {

    database.schema(Token.schema)
      .field("id", .uuid, .identifier(auto: true))
      .field("userID", .uuid, .references(User.schema, "id"))
      .field("value", .string, .required)
      .field("source", .int, .required)
      .unique(on: "value")
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Token.schema).delete()
  }
}
