//
//  AppStoreReviewManager.swift
//  
//
//  Created by Francis Adewale on 26/02/2021.
//

import StoreKit
import UIKit

enum AppStoreReviewManager {
  static func requestReviewIfAppropriate() {
    
        SKStoreReviewController.requestReview()

    
  }
}
