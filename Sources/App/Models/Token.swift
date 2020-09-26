//
//  Token.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor
import Fluent

//  MARK: Token
/// Setting key and value of the token model for user
/// authentification.
///
final class Token: Model {

  static let schema = "tokens"

  @ID(key: "id")
  var id: UUID?

  @Parent(key: "user_id")
  var user: User

  @Field(key: "value")
  var value: String

  @Field(key: "source")
  var source: SessionSource

  init() {}

  init(id: UUID? = nil, userID: User.IDValue, token: String, source: SessionSource) {
    self.id = id
    self.$user.id = userID
    self.value = token
    self.source = source
  }
}

// Provide the authentification middleware to find the user for
// the associated token in the request header.
//
extension Token: ModelTokenAuthenticatable {
  
  static let valueKey = \Token.$value
  static let userKey = \Token.$user

  var isValid: Bool {
    true
  }
}
