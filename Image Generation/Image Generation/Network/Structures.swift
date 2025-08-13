//
//  APIEndpoints.swift
//  Image Generation
//
//  Created by Mac Mini on 06/08/2025.
//
//MARK: - IMAGE GENERATION  STRUCTURES

struct GenerationResponse: Codable {
    let sdGenerationJob: SDGenerationJob?
}

struct SDGenerationJob: Codable {
    let generationId: String
}

struct GetImageResponse: Codable {
    let generationsById: GenerationsById

    enum CodingKeys: String, CodingKey {
        case generationsById = "generations_by_pk"
    }
}

struct GenerationsById: Codable {
    let status: String
    let generatedImages: [GeneratedImage]

    enum CodingKeys: String, CodingKey {
        case status
        case generatedImages = "generated_images"
    }
}

struct GeneratedImage: Codable {
    let url: String
}
