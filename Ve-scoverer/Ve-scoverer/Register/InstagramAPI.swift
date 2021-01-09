//
//  InstagramAPI.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 23/12/2020.
//

import UIKit


class InstagramApi {
    
  static let shared = InstagramApi()
  private let instagramAppID = "1043271892845987"
  private let redirectURI = "https://google.com"
  private let app_secret = "7206c3c34fe3bc63db5f06f30a1460cf"
  private let boundary = "boundary=\(NSUUID().uuidString)"
  private init () {}
    
}


private enum BaseURL: String {
  case displayApi = "https://api.instagram.com/"
  case graphApi = "https://graph.instagram.com/"
}

private enum Method: String {
  case authorize = "oauth/authorize"
  case access_token = "oauth/access_token"
}


