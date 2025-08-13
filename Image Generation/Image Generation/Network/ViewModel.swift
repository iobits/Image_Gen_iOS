//
//  APIEndpoints.swift
//  Image Generation
//
//  Created by Mac Mini on 06/08/2025.
//

import UIKit

class TextToImageViewModel {
    private let repository = TextToImgRepo()

    var onImagesReady: ((UIImage?) -> Void)?
    var onError: ((String) -> Void)?

    func generateImages(prompt: String, width: Int, height: Int, styleId: String) {
        repository.generateImage(prompt: prompt, width: width, height: height, styleId: styleId) { [weak self] result in
            switch result {
            case .success(let generationId):
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self?.pollForImages(generationId: generationId)
                }
            case .failure(let error):
                self?.onError?("Generation failed: \(error.localizedDescription)")
            }
        }
    }

    private func pollForImages(generationId: String, retryCount: Int = 0) {
        repository.fetchGeneratedImages(generationId: generationId) { [weak self] result in
            switch result {
            case .success(let (urls, _)):
                print("⏳ Poll \(retryCount): Checking...")
                print("📦 URLs: \(urls)")

                if let imageURL = urls.first {
                    self?.repository.downloadImage(from: imageURL) { image in
                        DispatchQueue.main.async {
                            self?.onImagesReady?(image)
                        }
                    }
                } else if retryCount < 20 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.pollForImages(generationId: generationId, retryCount: retryCount + 1)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.onError?("❌ Image generation timed out.")
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?("❌ Image fetch failed: \(error.localizedDescription)")
                }
            }
        }
    }

}


