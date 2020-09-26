//
//  File.swift
//  
//
//  Created by Roland Lariotte on 27/09/2020.
//

import Foundation

//  MARK: NewSession
/// Keep track of the user new session token and
/// public value.
///
struct NewSession: Content {
  
  let token: String
  let user: User.Public
}
