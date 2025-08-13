//
//  ProgressVc.swift
//  Image Generation
//
//  Created by Mac Mini on 11/08/2025.
//

import UIKit

class ProgressVc: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var discriptionView: GradientView!
    private let viewModel = TextToImageViewModel()
    var obj:  textToImageData!
    override func viewDidLoad() {
        super.viewDidLoad()
        LottieManager.playAnimation(on: loadingView, lottieName: Lotties_Constant.shared.progress)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GeneratedImgVC") as! GeneratedImgVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
            
            //self.startImageGeneration()
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discriptionView.layer.cornerRadius = 10.0
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension ProgressVc{
    private func setupBindings() {
        viewModel.onImagesReady = { [weak self] image in
            DispatchQueue.main.async {
                self?.view.hideLoading()
                print("getting image")
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "GeneratedImgVC") as! GeneratedImgVC
                vc.modalPresentationStyle = .fullScreen
                vc.generatedImg = image
                vc.promptTx = self?.obj.prompt ?? ""
                self?.present(vc, animated: false)
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.view.hideLoading()
                print("❌ Error: \(message)")
            }
        }
    }
    
    private func startImageGeneration() {
        DispatchQueue.main.async { [self] in
            self.view.showLoading(loadingKey: "loading...")
            self.viewModel.generateImages(prompt: obj.prompt, width: obj.weight, height: obj.hieght, styleId: obj.stylId)
        }
    }
}
