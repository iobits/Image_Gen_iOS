//
//  APIEndpoints.swift
//  Image Generation
//
//  Created by Mac Mini on 06/08/2025.
//

import Foundation
import UIKit

class TextToImgRepo {
    func generateImage(prompt: String, width: Int, height: Int, styleId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(URLs.shared.baseURL)\(URLs.shared.ver)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(URLs.shared.apiKey)",
            "Accept": IMAGE_Genrate_Params().jsonAp,
            "Content-Type": IMAGE_Genrate_Params().jsonAp
        ]

        let body: [String: Any] = [
            "modelId": IMAGE_Genrate_Params().modelID,
            "prompt": prompt,
            "num_images": 1,
            "width": width,
            "height": height,
            "ultra": false,
            "styleUUID": styleId,
            "enhancePrompt": false
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let response = try? JSONDecoder().decode(GenerationResponse.self, from: data),
                  let genId = response.sdGenerationJob?.generationId else {
                print("❌ Failed to decode POST response")
                completion(.failure(NSError(domain: "Invalid POST response", code: 0)))
                return
            }

            print("📤 Generation ID: \(genId)")
            completion(.success(genId))
        }.resume()
    }

    func fetchGeneratedImages(generationId: String, completion: @escaping (Result<([String], Bool), Error>) -> Void) {
        let url = URL(string: "\(URLs.shared.baseURL)\(URLs.shared.ver)\(generationId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(URLs.shared.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                print("📦 RAW GET RESPONSE: \(String(data: data, encoding: .utf8) ?? "")")
            }

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data from server", code: 0)))
                return
            }

            do {
                let response = try JSONDecoder().decode(GetImageResponse.self, from: data)
                let isReady = response.generationsById.status.lowercased() == "completed"
                let urls = response.generationsById.generatedImages.map { $0.url }
                completion(.success((urls, isReady)))
            } catch {
                completion(.failure(NSError(domain: "Invalid GET response", code: 0)))
            }
        }.resume()
    }

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
}


//MARK: - IMAGE TO IMAGE GENERATION

enum LeonardoAPI {
    static let baseURL = "https://cloud.leonardo.ai/api/rest/v1"
    static let apiKey = "19edb1cc-a734-4294-a7df-569e5be3a1ba" // Replace with your Leonardo API key
    static let modelId = "6bef9f1b-29cb-40c7-b9df-32b51c1f67d3" // e.g., "ac614f96-1082-45bf-be9d-757f2d31c174"
}


class LeonardoFlag {
    static let shared = LeonardoFlag()

    var generationId: String?
    var imageURL: String?
    var isComplete = false

    private init() {}

    func reset() {
        generationId = nil
        imageURL = nil
        isComplete = false
    }
}


//view model
import UIKit

//class LeonardoImageViewModel {
//    
//    var onImageReady: ((UIImage) -> Void)?
//    
//    func generateStyledImage(from inputImage: UIImage, prompt: String, styleId: String) {
//        LeonardoFlag.shared.reset()
//        uploadImage(inputImage) { uploadedImageURL in
//            guard let imageURL = uploadedImageURL else { return }
//            LeonardoFlag.shared.imageURL = imageURL
//            
//            self.requestImageGeneration(prompt: prompt, initImageURL: imageURL, styleId: styleId) { generationId in
//                guard let id = generationId else { return }
//                LeonardoFlag.shared.generationId = id
//                self.pollForImage(generationId: id)
//            }
//        }
//    }
//    
//    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
//            print("❌ Failed to create JPEG data")
//            completion(nil)
//            return
//        }
//        
//        let boundary = "Boundary-\(UUID().uuidString)"
//        
//        var request = URLRequest(url: URL(string: "\(LeonardoAPI.baseURL)/init-image")!)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(LeonardoAPI.apiKey)", forHTTPHeaderField: "Authorization")
//        
//        var body = Data()
//        
//        // image file part
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"init_image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//        body.append(imageData)
//        body.append("\r\n".data(using: .utf8)!)
//        
//        // extension field (this was missing!)
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"extension\"\r\n\r\n".data(using: .utf8)!)
//        body.append("jpg\r\n".data(using: .utf8)!)
//        
//        // closing boundary
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        
//        request.httpBody = body
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Upload error: \(error)")
//                completion(nil)
//                return
//            }
//            
//            guard let data = data else {
//                print("❌ No data in response")
//                completion(nil)
//                return
//            }
//            
//            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                print("✅ Upload success: \(json)")
//                let uploadUrl = json["uploadInitImageUrl"] as? String
//                completion(uploadUrl)
//            } else {
//                print("❌ Failed to parse upload JSON")
//                print(String(data: data, encoding: .utf8) ?? "No raw response")
//                completion(nil)
//            }
//        }.resume()
//    }
//
//
//
//    
//    private func requestImageGeneration(prompt: String, initImageURL: String, styleId: String, completion: @escaping (String?) -> Void) {
//        guard let url = URL(string: "\(LeonardoAPI.baseURL)/generations") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(LeonardoAPI.apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body: [String: Any] = [
//            "prompt": prompt,
//            "init_image_url": initImageURL,
//            "modelId": LeonardoAPI.modelId,
//            "presetStyle": styleId,
//            "photoReal": false,
//            "num_images": 1
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Generation request error: \(error)")
//                completion(nil)
//                return
//            }
//
//            guard let data = data else {
//                print("❌ Generation request returned no data")
//                completion(nil)
//                return
//            }
//
//            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                print("✅ Generation request response: \(json)")
//                let id = json["sdGenerationJob"] as? [String: Any]
//                let generationId = id?["generationId"] as? String
//                completion(generationId)
//            } else {
//                print("❌ Failed to parse generation JSON")
//                print(String(data: data, encoding: .utf8) ?? "No raw response")
//                completion(nil)
//            }
//        }.resume()
//    }
//
//
//    
//    private func pollForImage(generationId: String) {
//        guard let url = URL(string: "\(LeonardoAPI.baseURL)/generations/\(generationId)") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(LeonardoAPI.apiKey)", forHTTPHeaderField: "Authorization")
//        
//        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
//            print("⏳ Polling for generation ID: \(generationId)")
//            
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("❌ Poll error: \(error)")
//                    return
//                }
//                
//                guard let data = data else {
//                    print("❌ Poll returned no data")
//                    return
//                }
//                
//                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                    print("🔄 Poll response: \(json)")
//                    
//                    let generationsById = json["generations_by_pk"] as? [String: Any]
//                    let status = generationsById?["status"] as? String
//                    
//                    if status == "COMPLETE",
//                       let generatedImages = generationsById?["generated_images"] as? [[String: Any]],
//                       let imageURLString = generatedImages.first?["url"] as? String,
//                       let imageURL = URL(string: imageURLString) {
//                        
//                        timer.invalidate()
//                        LeonardoFlag.shared.isComplete = true
//                        self.downloadImage(from: imageURL)
//                    }
//                } else {
//                    print("❌ Poll failed to parse JSON")
//                    print(String(data: data, encoding: .utf8) ?? "No raw response")
//                }
//            }.resume()
//        }
//    }
//
//    
//    private func downloadImage(from url: URL) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let data = data,
//                let image = UIImage(data: data)
//            else { return }
//            
//            DispatchQueue.main.async {
//                self.onImageReady?(image)
//            }
//        }.resume()
//    }
//}

