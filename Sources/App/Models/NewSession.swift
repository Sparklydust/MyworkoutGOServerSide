//
//  File.swift
//  
//
//  Created by Roland Lariotte on 27/09/2020.
//

import Vapor

//  MARK: NewSession
/// Keep track of the user new session token and
/// public value. This is the JSON root of the request.
///
struct NewSession: Content {
  
  let token: String
  let user: User.Public
}
