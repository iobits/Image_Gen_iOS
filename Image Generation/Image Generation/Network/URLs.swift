//
//  APIEndpoints.swift
//  Image Generation
//
//  Created by Mac Mini on 06/08/2025.
//

import Foundation
import UIKit

class URLs: NSObject{
    static let shared = URLs()
    let baseURL = "https://cloud.leonardo.ai/api/rest/"
    let ver = "v1/generations/"
    let apiKey = "19edb1cc-a734-4294-a7df-569e5be3a1ba"
}

class IMAGE_Genrate_Params{
    let modelID = "e316348f-7773-490e-adcd-46757c738eb7"
    let jsonAp = "application/json"
}

class ERROR_KEYs: NSObject{
    static let shared = ERROR_KEYs()
    let stopRecodingTitle = "Recording Stopped"
    let stopRecodingSucess = "Your voice has been successfully recorded and converted to text."
    let microWarningTitle = "Your voice has been successfully recorded and converted to text."
    let microMgs = "Please enable microphone access in Settings to use voice recording."
}

class CONSTANTs: NSObject{
    static let shared = CONSTANTs()
    let ratios: [RatioOption] = [
        RatioOption(ratioImg: "plusIcon", title: "Custom", width: 0, height: 0),
        RatioOption(ratioImg: "r2", title: "1:1", width: 1, height: 1),
        RatioOption(ratioImg: "r3", title: "9:16", width: 9, height: 16),
        RatioOption(ratioImg: "r4", title: "16:9", width: 16, height: 9)
    ]
    
    let trendArr: [TrendOptions] = [
        TrendOptions(trandImg: "anyImg", title: "Any"),
        TrendOptions(trandImg: "loveImg", title: "Love"),
        TrendOptions(trandImg: "anyImg", title: "Featured Images")
    ]
}


//MARK: - TEST
//GENERATE IMGA UNSING LUCID ORIGIN: 7b592283-e8a7-4c5a-9ba6-d18c31f258b9
//{
//  "modelId": "7b592283-e8a7-4c5a-9ba6-d18c31f258b9",
//  "contrast": 3.5,
//  "prompt": "a portrait-style photograph featuring a fox with a slender build and delicate features sitting against a navy blue background that is smooth and untextured. The fox has soft, fluffy orange fur with a lighter patch on its chest and around its nose. Its ears are large and pointed, with a slight perkiness. The eyes are a bright, piercing yellow with a sharp, intelligent glint. The lighting is soft and warm, highlighting the texture of the fur.",
//  "num_images": 4,
//  "width": 1920,
//  "height": 1080,
//  "ultra": false,
//  "styleUUID": "111dc692-d470-4eec-b791-3475abac4c46",
//  "enhancePrompt": true
//}


//GENERATE Image using lonardo Phoenix Model in ultra mode: de7d3faf-762f-48e0-b3b7-9d0ac3a3fcf3
//{
//  "modelId": "de7d3faf-762f-48e0-b3b7-9d0ac3a3fcf3",
//  "contrast": 3.5,
//  "prompt": "an orange cat standing on a blue basketball with the text PAWS",
//  "num_images": 4,
//  "width": 1472,
//  "height": 832,
//  "ultra": true,
//  "styleUUID": "111dc692-d470-4eec-b791-3475abac4c46",
//  "enhancePrompt": true
//}
