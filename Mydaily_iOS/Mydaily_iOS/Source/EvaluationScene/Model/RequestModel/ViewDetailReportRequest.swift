//
//  ViewDetailReportRequest.swift
//  Mydaily_iOS
//
//  Created by SHIN YOON AH on 2021/01/12.
//

import Foundation

struct ViewDetailReportRequest: Codable {
    let totalKeywordId: Int
    let start: String
    let end: String

    init(_ keywordID: Int, _ start: String, _ end: String) {
        self.totalKeywordId = keywordID
        self.start = start
        self.end = end
    }
}
