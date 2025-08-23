//
//  UpstageOCRService.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//

import Foundation

class UpstageOCRService {
    
    func processDocument(imageData: Data) async throws -> OCRResponse {
        let headers = ["Authorization": "Bearer \(APIConstants.Keys.upstage)"]
        
        let formData: [FormDataItem] = [
            .text(name: "model", value: APIConstants.Models.ocr),
            .file(name: "document", filename: "image.jpg", data: imageData, mimeType: "image/jpeg")
        ]
        
        return try await NetworkManager.shared.requestMultipartForm(
            url: APIConstants.URLs.documentDigitization,
            headers: headers,
            formData: formData,
            responseType: OCRResponse.self
        )
    }
}
