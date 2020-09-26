//
//  UserError.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor

enum UserError {
  case emailAlreadyUsed
}

extension UserError: AbortError {
  var description: String {
    reason
  }

  var status: HTTPResponseStatus {
    switch self {
    case .emailAlreadyUsed:
      return .conflict
    }
  }

  var reason: String {
    switch self {
    case .emailAlreadyUsed:
      return "Sorry but this email is already in used."
    }
  }
}
