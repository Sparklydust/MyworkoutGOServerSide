//
//  User.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Fluent
import Vapor

final class User: Model, Content {
  struct Public: Content {
    let id: UUID
    let email: String
    let gender: String
  }

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

extension User {
  static func create(from userSignUp: UserSignUp) throws -> User {
    User(email: userSignUp.email,
         password: try Bcrypt.hash(userSignUp.password),
         gender: userSignUp.gender)
  }

  func createToken(source: SessionSource) throws -> Token {

    return try Token(userID: requireID(),
                     token: [UInt8].random(count: 16).base64,
                     source: source)
  }

  func asPublic() throws -> Public {
    Public(id: try requireID(),
           email: email,
           gender: gender)
  }
}

extension User: ModelAuthenticatable {
  static let usernameKey = \User.$email
  static let passwordHashKey = \User.$password

  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.password)
  }
}
