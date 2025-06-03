//
//  TextMessageModel.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import Foundation
import UIKit

struct TextMessageModel : Hashable {
    let id = UUID().uuidString
    var text : String
    var isIncoming : Bool
    var image : UIImage?
}

struct SendingTextModel {
    var text : String
    var image : UIImage?
}


// MARK: - ReusltImgResponse
struct ChatMessageModel: Codable {
    let gmimiLang, gmimiPrompt: String
    let gmimiTextArray: [GmimiTextArray]
}

// MARK: - GmimiTextArray
struct GmimiTextArray: Codable {
    let role: String
    let parts: [Part]
}

// MARK: - Part
struct Part: Codable {
    let text: String?
    let inlineData: InlineData?

    enum CodingKeys: String, CodingKey {
        case text
        case inlineData = "inline_data"
    }
}

// MARK: - InlineData
struct InlineData: Codable {
    let mimeType, data: String

    enum CodingKeys: String, CodingKey {
        case mimeType = "mime_type"
        case data
    }
}



struct ChatResponseModel: Codable {
    let candidates: [ChatResponseCandidate]
}

// MARK: - Candidate
struct ChatResponseCandidate: Codable {
    let content: ChatResponseContent
}

// MARK: - Content
struct ChatResponseContent: Codable {
    let parts: [PartResponse]
}
// MARK: - Part
struct PartResponse: Codable {
    let text: String
}

