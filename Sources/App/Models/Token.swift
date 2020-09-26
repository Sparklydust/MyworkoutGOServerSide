//
//  Token.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor
import Fluent

enum SessionSource: Int, Content {
  case signUp
  case logIn
}

final class Token: Model {

  static let schema = "tokens"

  @ID(key: "id")
  var id: UUID?

  @Parent(key: "userID")
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

extension Token: ModelTokenAuthenticatable {
  static let valueKey = \Token.$value
  static let userKey = \Token.$user
}
