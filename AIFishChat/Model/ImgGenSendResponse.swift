//
//  ImgGenSendResponse.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 25.02.2025.
//


struct ImgGenSendResponse: Codable {
    let requestID, prompt : String
    let imageURL : String?

    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case prompt
        case imageURL = "image_url"
    }
}

// MARK: - ReusltImgResponse
struct ReusltImgResponse: Codable {
    let fileURL: String?

    enum CodingKeys: String, CodingKey {
        case fileURL = "file_url"
    }
}

