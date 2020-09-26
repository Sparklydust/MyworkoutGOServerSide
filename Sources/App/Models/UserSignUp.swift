//
//  UserSignUp.swift
//  
//
//  Created by Roland Lariotte on 27/09/2020.
//

import Vapor

//  MARK: UserSignUp
/// Values needed for a user to sign up.
///
struct UserSignUp: Content {
  
  let email: String
  let password: String
  let gender: String
}

extension UserSignUp: Validatable {
  /// Setting up sign up rules for email and password.
  ///
  static func validations(_ validations: inout Validations) {
    validations.add("email", as: String.self, is: !.empty)
    validations.add("password", as: String.self, is: .count(1...))
  }
}
