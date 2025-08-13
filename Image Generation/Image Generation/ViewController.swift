//
//  ViewController.swift
//  Image Generation
//
//  Created by Mac Mini on 06/08/2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startView.layer.cornerRadius = 28.0
    }
    
    
    @IBAction func getStartBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
