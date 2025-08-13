//
//  Helper_Func.swift
//  Image Generation
//
//  Created by Mac Mini on 11/08/2025.
//

import Foundation
import UIKit
import Speech

class Helper_Fun: NSObject{
    static let shared = Helper_Fun()
    
    func conerRadiusForView(_ views: [UIView], cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        for view in views {
            view.layer.cornerRadius = cornerRadius
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = borderColor.cgColor
            view.layer.masksToBounds = true
        }
    }
    
    func cornerRadiusForLabels(_ labels: [UILabel],
                               cornerRadius: CGFloat,
                               borderWidth: CGFloat,
                               borderColor: UIColor) {
        for label in labels {
            label.layer.cornerRadius = cornerRadius
            label.layer.borderWidth = borderWidth
            label.layer.borderColor = borderColor.cgColor
            label.layer.masksToBounds = true
        }
    }

    
    func styleSelectedView(allViews: [UIView], selectedView: UIView, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat, selectedOpacity: CGFloat = 0.5) {
        
        for view in allViews {
            if view == selectedView {
                // Selected view styling
                view.layer.borderColor = borderColor.cgColor
                view.layer.borderWidth = borderWidth
                view.layer.cornerRadius = cornerRadius
                view.alpha = selectedOpacity  // Opacity kam
            } else {
                // Reset other views styling
                view.layer.borderColor = UIColor.clear.cgColor
                view.layer.borderWidth = 0
                view.layer.cornerRadius = cornerRadius
                view.alpha = 1.0 // Full opacity
            }
        }
    }
    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            default:
                print("Speech recognition not authorized")
            }
        }
    
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Mic permission granted")
            } else {
                print("Mic permission denied")
            }
        }
    }
}
