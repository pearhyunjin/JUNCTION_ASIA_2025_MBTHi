//
//  UpstageInformationExtractionService.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//

import Foundation

class UpstageInformationExtractionService {
    
    func extractInformation(
        imageData: Data, 
        model: String = APIConstants.Models.receiptExtraction
    ) async throws -> InformationExtractionResponse {
        let headers = ["Authorization": "Bearer \(APIConstants.Keys.upstage)"]
        
        let formData: [FormDataItem] = [
            .text(name: "model", value: model),
            .file(name: "document", filename: "document.png", data: imageData, mimeType: "image/png")
        ]
        
        let responseString = try await NetworkManager.shared.requestMultipartFormAsString(
            url: APIConstants.URLs.informationExtraction,
            headers: headers,
            formData: formData
        )
        
        return InformationExtractionResponse(rawResponse: responseString)
    }
}
