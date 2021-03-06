//
//  DailyService.swift
//  Mydaily_iOS
//
//  Created by 이유진 on 2021/01/12.
//

import Foundation
import Moya

enum DailyService {
    case dailyinquiry(param: DailyRequest)
    case dailytask(Int)
    case dailyWrite(param: DailyWriteRequest)
    case dailyModify(id: Int, param: DailyModifyRequest)
    case dailyDelete(Int)
}

extension DailyService: TargetType {
    
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: GeneralAPI.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .dailyinquiry:
            return "/tasks"
        case .dailytask(let id):
            return "/tasks/\(id)"
        case .dailyWrite:
            return "/tasks"
        case .dailyModify(let id, _):
            return "/tasks/\(id)"
        case .dailyDelete(let id):
            return "/tasks/\(id)"
        }
    }
  
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .dailyinquiry:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .dailyinquiry,
             .dailytask:
            return .get
        case .dailyWrite:
            return .post
        case .dailyModify:
            return .put
        case .dailyDelete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .dailyinquiry(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding: URLEncoding.default)
        case .dailytask,
             .dailyDelete:
            return .requestPlain
        case .dailyWrite(let param):
            return .requestJSONEncodable(param)
        case .dailyModify(let ID, let param):
            let encoded = try! JSONEncoder().encode(param)
            return .requestCompositeData(bodyData: encoded, urlParameters: ["taskId": ID])
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            let accessToken = UserDefaultStorage.accessToken
            return [
                "Content-Type": "application/json",
                "jwt": accessToken
            ]
        }
    }
}
