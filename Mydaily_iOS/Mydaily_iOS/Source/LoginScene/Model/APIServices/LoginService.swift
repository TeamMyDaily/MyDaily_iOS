//
//  LoginService.swift
//  Mydaily_iOS
//
//  Created by 이유진 on 2021/01/11.
//

import Foundation
import Moya

enum LoginServices {
    case signUp(param: SignupRequest)
    case signIn(param: SigninRequest)
}

extension LoginServices: TargetType {
  public var baseURL: URL {
    return URL(string: GeneralAPI.baseURL)!
  }
  
  var path: String {
    switch self {
    case .signUp:
        return "/users/signup"
    case .signIn:
        return "/users/signin"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .signUp,
         .signIn:
      return .post
    }
  }
  
  var sampleData: Data {
    return "@@".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .signUp(let param):
        return .requestJSONEncodable(param)
    case .signIn(let param):
        return .requestJSONEncodable(param)
    }
  }

  var headers: [String: String]? {
    switch self {
    default:
      return ["Content-Type": "application/json"]
    }
  }
}
