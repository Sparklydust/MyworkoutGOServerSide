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

  @Field(key: "gender")
  var gender: String

  init() {}

  init(id: UUID? = nil, email: String, gender: String) {
    self.email = email
    self.gender = gender
  }
}
