//
//  GoalService.swift
//  Mydaily_iOS
//
//  Created by 이유진 on 2021/01/13.
//

import Foundation
import Moya

enum GoalService {
    case goalinquiry(param: GoalRequest)
    case goalwrite(param: GoalWriteRequest)
    case goalcomplete(Int)
    case goalmodify(ID: Int, param: GoalModifyRequest)
    case goaldelete(Int)
}

extension GoalService: TargetType {
    
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: GeneralAPI.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .goalinquiry:
            return "/goals"
        case .goalwrite:
            return "/goals"
        case .goalcomplete(let goalID):
            return "/goals/completion/\(goalID)"
        case .goalmodify(let goalID, _):
            return "/goals/\(goalID)"
        case .goaldelete(let goalID):
            return "/goals/\(goalID)"
        }
    }
  
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .goalinquiry:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .goalinquiry:
            return .get
        case .goalwrite:
            return .post
        case .goalcomplete,
             .goalmodify:
            return .put
        case .goaldelete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .goalinquiry(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding: URLEncoding.default)
        case .goalwrite(let param):
            return .requestJSONEncodable(param)
        case .goalcomplete,
             .goaldelete:
            return .requestPlain
        case .goalmodify(let goalID, let param):
            let encoded = try! JSONEncoder().encode(param)
            return .requestCompositeData(bodyData: encoded, urlParameters: ["GoalId": goalID])
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
