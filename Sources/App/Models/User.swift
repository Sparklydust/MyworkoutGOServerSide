//
//  User.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Fluent
import Vapor

//  MARK: User
/// Setting up user associated values stored in database.
///
final class User: Model, Content {
  
  struct Public: Content {
    let id: UUID
    let email: String
    let gender: Int
  }

  static let schema = "users"

  @ID(key: "id")
  var id: UUID?

  @Field(key: "email")
  var email: String

  @Field(key: "password")
  var password: String

  @Field(key: "gender")
  var gender: Int

  init() {}

  init(id: UUID? = nil, email: String, password: String, gender: Int) {
    self.email = email
    self.password = password
    self.gender = gender
  }
}

extension User {
  /// Create user when sign in up.
  ///
  static func create(from userSignUp: UserSignUp) throws -> User {
    User(email: userSignUp.email,
         password: try Bcrypt.hash(userSignUp.password),
         gender: userSignUp.gender)
  }

  /// Create the token authentificatin key when user sign up
  /// or log in.
  ///
  func createToken(source: SessionSource) throws -> Token {

    return try Token(userID: requireID(),
                     token: [UInt8].random(count: 16).base64,
                     source: source)
  }

  /// Set user public value on api call to avoid
  /// password leak.
  ///
  func asPublic() throws -> Public {
    Public(id: try requireID(),
           email: email,
           gender: gender)
  }
}

// Protocol to perform all steps around authenticating a user
// with valid credentials in the request header to link it
// to tokens.
//
extension User: ModelAuthenticatable {
  
  static let usernameKey = \User.$email
  static let passwordHashKey = \User.$password

  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.password)
  }
}
