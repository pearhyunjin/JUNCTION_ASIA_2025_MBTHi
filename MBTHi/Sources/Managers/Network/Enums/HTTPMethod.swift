//
//  HTTPMethod.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

enum FormDataItem {
    case text(name: String, value: String)
    case file(name: String, filename: String, data: Data, mimeType: String)
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int, String)
    case noData
    case encodingError
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .serverError(let code, let message):
            return "서버 오류가 발생했습니다. 상태 코드: \(code), 메시지: \(message)"
        case .noData:
            return "데이터가 없습니다."
        case .encodingError:
            return "데이터 인코딩에 실패했습니다."
        case .decodingError(let error):
            return "데이터 디코딩에 실패했습니다: \(error.localizedDescription)"
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        }
    }
}
