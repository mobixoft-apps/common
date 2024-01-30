//
//  File.swift
//  
//
//  Created by Yusuf Uzan on 30.01.2024.
//

import Alamofire
import Sentry
import SwiftPlus

public final class AFHTTPErrorLogger {
  
  static func sendLog(message: String, extra: String) {
    SentrySDK.capture(message: message) { (scope) in
      scope.setExtra(value: extra, key: "extra")
    }
  }
  
  static func log(result: AFDataResponse<Data>) -> String {
    var fullMessage = ""
    let urlString = result.request?.url?.absoluteString
    let components = NSURLComponents(string: urlString ?? "")
    let path = "\(components?.path ?? "")"
    let query = "\(components?.query ?? "")"
    if let request = result.request {
      let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
      let host = "\(components?.host ?? "")"
      var requestLog = "[\(result.response?.statusCode ?? 0)]:\(request.url?.absoluteString ?? ""):[\(method)]\n\n"
      requestLog += "\n\n-------------------- REQUEST --------------------\n"
      requestLog += "Url: \(String(describing: urlString ?? ""))"
      requestLog += "\n"
      requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
      requestLog += "Host: \(host)\n"
      for field in (result.request)?.allHTTPHeaderFields ?? [:] {
        requestLog += "\(field.key): \(field.value)\n"
      }
      if let body = request.httpBody{
        let bodyString = body.prettyPrintedJSONString ?? String(data: body, encoding: .utf8) ?? "Can't render body; not utf8 encoded";
        requestLog += "\(bodyString)\n"
      }
      requestLog += "---------------------------------------------------\n\n";
      fullMessage += requestLog
    }
    var responseLog = "\n-------------------- RESPONSE --------------------\n"
    if let urlString = urlString {
      responseLog += "Url: \(urlString)"
      responseLog += "\n"
    }
    if let httpResponse = result.response {
      responseLog += "HTTP \(httpResponse.statusCode) \(path)?\(query)\n"
    }
    if let host = components?.host{
      responseLog += "Host: \(host)\n"
    }
    for field in (result.request)?.allHTTPHeaderFields ?? [:] {
      responseLog += "\(field.key): \(field.value)\n"
    }
    if let body = result.data {
      let bodyString = body.prettyPrintedJSONString ?? String(data: body, encoding: .utf8) ?? "No Body";
      responseLog += "\(bodyString)\n"
    }
    if let error = result.error {
      responseLog += "\(error.localizedDescription)\n"
    }
    responseLog += "---------------------------------------------------\n\n";
    fullMessage += responseLog
    return fullMessage
  }
}


