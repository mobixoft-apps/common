//
//  File.swift
//  
//
//  Created by Yusuf Uzan on 30.01.2024.
//

import Foundation
import Alamofire
import Sentry

extension AFError {
  func send(url: String) {
    SentrySDK.capture(message: self.localizedDescription) { (scope) in
      scope.setExtra(value: url, key: "url")
    }
  }
}
