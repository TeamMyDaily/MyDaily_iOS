//
//  ReportService.swift
//  Mydaily_iOS
//
//  Created by SHIN YOON AH on 2021/01/12.
//

import Foundation
import Moya

enum ReportServices {
    case viewReport(param: ViewRequest)
    case viewRetrospective(param: ViewRequest)
    case registRetrospective(param: RegistRetrospectiveRequest)
    case viewDetailReport(param: ViewDetailReportRequest)
}

extension ReportServices: TargetType {
  public var baseURL: URL {
    return URL(string: GeneralAPI.baseURL)!
  }
  
  var path: String {
    switch self {
    case .viewReport(let time):
        return "/reports"
    case .viewRetrospective(let time):
        return "/reviews"
    case .registRetrospective:
        return "/reviews"
    case .viewDetailReport(let time):
        return "/reports/detail"
    }
  }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .viewRetrospective:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
  
  var method: Moya.Method {
    switch self {
    case .viewReport,
         .viewRetrospective:
        return .get
    case .registRetrospective,
         .viewDetailReport:
        return .post
    }
  }
  
  var sampleData: Data {
    return "@@".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .viewReport(let param):
        return .requestParameters(parameters: try! param.asDictionary(), encoding: URLEncoding.default)
    case .viewRetrospective(let param):
        return .requestParameters(parameters: try! param.asDictionary(), encoding: URLEncoding.default)
    case .registRetrospective(let param):
        return .requestJSONEncodable(param)
    case .viewDetailReport(let param):
        return .requestJSONEncodable(param)
    }
  }

  var headers: [String: String]? {
    switch self {
    default:
      return ["Content-Type": "application/json",
              "jwt" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwibmFtZSI6InFxIiwiZW1haWwiOiJxcUBxcS5xcSIsImlhdCI6MTYxMDMzMzQ0MywiZXhwIjoxNjEyOTI1NDQzLCJpc3MiOiJjeWoifQ.k3HAJg9K_NMVscJWafGBdCB4Odj6qua9VUL2N3_siYo"]
    }
  }
}
