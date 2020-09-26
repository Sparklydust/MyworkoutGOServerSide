//
//  NetworkError.swift
//  
//
//  Created by Roland Lariotte on 26/09/2020.
//

import Vapor

//  MARK: NetworkError
/// API call error handler to send to user.
///
enum NetworkError {
  
  case emailAlreadyUsed
}

extension NetworkError: AbortError {
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
