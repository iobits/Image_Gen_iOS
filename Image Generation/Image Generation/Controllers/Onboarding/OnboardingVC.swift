//
//  OnboardingVC.swift
//  Image Generation
//
//  Created by Mac Mini on 06/08/2025.
//

import UIKit

struct OnboardingItem {
    let image: UIImage
    let text1: String
    let text2: String
}

class OnboardingVC: UIViewController {
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var img1: UIImageView!
    //@IBOutlet weak var img2: UIImageView!
    //private var selectedImage: UIImage?
    //let imagePicker = UIImagePickerController()
    
    var onboardingItems: [OnboardingItem] = []
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        imagePicker.delegate = self
        //        imagePicker.sourceType = .photoLibrary
        //        imagePicker.allowsEditing = false
        
        // Array initialize karo
        onboardingItems = [
            OnboardingItem(image: UIImage(named: "ob1")!, text1: "Instantly Transform your photos", text2: "Turn words into stunning visuals."),
            OnboardingItem(image: UIImage(named: "ob2")!, text1: "Inspire & Share", text2: "Show the world your AI art."),
            OnboardingItem(image: UIImage(named: "ob3")!, text1: "Your creativity with AI toolbox", text2: "Show the world your AI art.")
        ]
        
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
        if sender.tag == 0 {
            print("skip")
            // Optionally go to last screen or close onboarding
        } else if sender.tag == 1 {
            print("next")
            if currentIndex < onboardingItems.count - 1 {
                currentIndex += 1
                updateUI()
            } else {
                print("Onboarding finished")
            }
        }
    }
    func updateUI() {
           let item = onboardingItems[currentIndex]
           img1.image = item.image
           lbl1.text = item.text1
           lbl2.text = item.text2
       }
    
    
    //    @IBAction func recodingBtnAction(_ sender: UIButton) {
    //
    //    }
    
}

    // MARK: - Image Picker Delegate // GENERATE IMAGES WITH REAL TIME CANVAS
//extension OnboardingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//          if let pickedImage = info[.originalImage] as? UIImage {
//              img1.image = pickedImage
//              
//              let resizedImage = pickedImage.resize(toWidth: 512)
//              if let imageData = resizedImage.jpegData(compressionQuality: 0.5) {
//                  let base64String = imageData.base64EncodedString()
//
//                  // 👉 Print base64 size
//                  let base64SizeBytes = base64String.lengthOfBytes(using: .utf8)
//                  let base64SizeMB = Double(base64SizeBytes) / (1024.0 * 1024.0)
//                  print("📦 Base64 size: \(base64SizeBytes) bytes (\(String(format: "%.2f", base64SizeMB)) MB)")
//                  let prompt = "Add a Superman costume to the person in the photo without changing the face"
//
//                  let parameters = [
//                      "width": 512,
//                      "height": 512,
//                      "imageDataUrl": "data:image/jpeg;base64,\(base64String)",
//                      "prompt": prompt,
//                      "style": "CINEMATIC", // STYLE COUNT Be CHANGE
//                      "strength": 0.65
//                  ] as [String : Any]
//                  
//                  sendAPIRequest(parameters)
//              }
//          }
//          dismiss(animated: true, completion: nil)
//      }
//  
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true)
//    }
//    
//    func sendAPIRequest(_ parameters: [String: Any]) {
//        guard let url = URL(string: "https://cloud.leonardo.ai/api/rest/v1/generations-lcm") else {
//            print("Invalid URL")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(URLs.shared.apiKey)", forHTTPHeaderField: "authorization")
//        request.setValue("application/json", forHTTPHeaderField: "content-type")
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
//        } catch {
//            print("JSON serialization failed: \(error)")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("API Error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("No HTTP response")
//                return
//            }
//            
//            print("Status Code: \(httpResponse.statusCode)")
//            
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            do {
//                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                    print("API Response: \(jsonResponse)")
//                    
//                    // ✅ Correct key: "lcmGenerationJob"
//                    if let lcmJob = jsonResponse["lcmGenerationJob"] as? [String: Any],
//                       let imageArray = lcmJob["imageDataUrl"] as? [String],
//                       let imageDataUrl = imageArray.first {
//                        
//                        // ✅ Clean and decode base64
//                        let cleanedBase64 = imageDataUrl.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")
//                        
//                        if let imageData = Data(base64Encoded: cleanedBase64),
//                           let resultImage = UIImage(data: imageData) {
//                            DispatchQueue.main.async {
//                                self.img2.image = resultImage
//                            }
//                        } else {
//                            print("❌ Failed to decode image data")
//                        }
//                    } else {
//                        print("❌ No imageDataUrl found in response")
//                    }
//                }
//            } catch {
//                print("❌ Decoding failed: \(error)")
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("Raw Response: \(responseString)")
//                }
//            }
//        }.resume()
//    }
//
//}

//extension UIImage {
//    func resize(toWidth width: CGFloat) -> UIImage {
//        let scale = width / self.size.width
//        let height = self.size.height * scale
//        let size = CGSize(width: width, height: height)
//        
//        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
//        self.draw(in: CGRect(origin: .zero, size: size))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage ?? self
//    }
//}

