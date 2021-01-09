//
//  InstagramResponse.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 23/12/2020.
//

import UIKit

struct InstagramTestUser: Codable {
  var access_token: String
  var user_id: Int
}
struct InstagramUser: Codable {
  var id: String
  var username: String
}
