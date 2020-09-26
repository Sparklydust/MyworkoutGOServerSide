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

  @ID(key: "id")
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
