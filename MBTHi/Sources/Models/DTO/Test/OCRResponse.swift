//
//  OCRResponse.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//


import Foundation

struct OCRResponse: Codable {
    let apiVersion: String
    let confidence: Double
    let metadata: OCRMetadata
    let mimeType: String
    let modelVersion: String
    let numBilledPages: Int
    let pages: [OCRPage]
    let stored: Bool
    let text: String
}

struct OCRMetadata: Codable {
    let pages: [OCRPageInfo]
}

struct OCRPageInfo: Codable {
    let height: Int
    let page: Int
    let width: Int
}

struct OCRPage: Codable {
    let confidence: Double
    let height: Int
    let id: Int
    let text: String
    let width: Int
    let words: [OCRWord]
}

struct OCRWord: Codable {
    let boundingBox: BoundingBox
    let confidence: Double
    let id: Int
    let text: String
}

struct BoundingBox: Codable {
    let vertices: [Vertex]
}

struct Vertex: Codable {
    let x: Int
    let y: Int
}
