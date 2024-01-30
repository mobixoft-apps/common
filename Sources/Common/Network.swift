//
//  File.swift
//  
//
//  Created by Yusuf Uzan on 30.01.2024.
//

import Alamofire
import Foundation

public protocol NetworkServiceProtocol {
  func request<T: Decodable>(
    url: URL,
    parameters: Parameters,
    headers: HTTPHeaders,
    method: HTTPMethod,
    encoding: ParameterEncoding,
    completion: @escaping (Result<T, Error>) -> Void)
}

public extension NetworkServiceProtocol {
  /// Request
  /// - Parameters:
  ///   - parameters: Parameters
  ///   - completion: Result<T, Error>
  func request<T: Decodable>(
    url: URL, 
    parameters: Parameters = [:],
    headers: HTTPHeaders = [:],
    method: HTTPMethod = .get,
    encoding: ParameterEncoding = URLEncoding(destination: .queryString),
    completion: @escaping (Result<T, Error>) -> Void) {
    let request = AF.request(
      url,
      method: method,
      parameters: parameters,
      encoding: encoding,
      headers: headers
    )
    request.responseData { response in
      if let error = response.error {
        let log = AFHTTPErrorLogger.log(result: response)
        AFHTTPErrorLogger.sendLog(message: error.localizedDescription, extra: log)
        completion(.failure(error))
      }
      guard let data = response.data else {
        let log = AFHTTPErrorLogger.log(result: response)
        AFHTTPErrorLogger.sendLog(message: "No Data", extra: log)
        return
      }
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      do {
        let object = try decoder.decode(T.self, from: data)
        completion(.success(object))
      } catch let decodeError {
        let log = AFHTTPErrorLogger.log(result: response)
        AFHTTPErrorLogger.sendLog(message: decodeError.localizedDescription, extra: log)
        completion(.failure(decodeError))
      }
    }
  }
}
