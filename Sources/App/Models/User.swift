//
//  User.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Fluent
import Vapor

final class User: Model, Content {
  static let schema = "users"

  @ID
  var id: UUID?

  @Field(key: "email")
  var email: String

  @Field(key: "password")
  var password: String

  @Field(key: "gender")
  var gender: String

  init() {}

  init(id: UUID? = nil, email: String, password: String, gender: String) {
    self.email = email
    self.password = password
    self.gender = gender
  }
}

struct AdminUser: Migration {
  func prepare(on connection: Database) -> EventLoopFuture<Void> {
    let user = User(email: "registered@email.com", password: "password", gender: "male")
    return user.save(on: connection).transform(to: ())
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("users").update()
  }
}
