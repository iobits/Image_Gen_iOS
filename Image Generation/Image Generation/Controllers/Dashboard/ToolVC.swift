//
//  ToolVC.swift
//  Image Generation
//
//  Created by Mac Mini on 11/08/2025.
//

import UIKit

class ToolVC: UIViewController {
    
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var toolView1: UIView!
    @IBOutlet weak var toolView2: UIView!
    @IBOutlet weak var toolView3: UIView!
    @IBOutlet weak var toolView4: UIView!
    
    @IBOutlet weak var v1: GradientView!
    @IBOutlet weak var v2: GradientView!
    @IBOutlet weak var v3: GradientView!
    @IBOutlet weak var v4: GradientView!
    
    @IBOutlet weak var ani1: UIView!
    @IBOutlet weak var ani2: UIView!
    @IBOutlet weak var ani3: UIView!
    @IBOutlet weak var ani4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper_Fun.shared.conerRadiusForView([v1, v2, v3, v4], cornerRadius: 20, borderWidth: 0.5, borderColor: .clear)
        Helper_Fun.shared.conerRadiusForView([toolView1, toolView2, toolView3, toolView4], cornerRadius: 20, borderWidth: 0.5, borderColor: .clear)
        addTapGesturesToToolViews([toolView1, toolView2, toolView3, toolView4])
        
        LottieManager.playAnimation(on: ani1, lottieName: Lotties_Constant.shared.arrow)
        LottieManager.playAnimation(on: ani2, lottieName: Lotties_Constant.shared.arrow)
        LottieManager.playAnimation(on: ani3, lottieName: Lotties_Constant.shared.arrow)
        LottieManager.playAnimation(on: ani4, lottieName: Lotties_Constant.shared.arrow)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabView.layer.cornerRadius = 35.0
    }
    
    @IBAction func tabActionBtn(_ sender: UIButton) {
        if sender.tag == 0{
            print("tab 1")
            tabNavigation(identi: "HomeVC")
        }else if sender.tag == 2{
            print("tab 3")
            tabNavigation(identi: "ProfileVC")
        }else if sender.tag == 3{
            print("cam ")
        }
    }
    func tabNavigation(identi: String){
        let vc = storyboard?.instantiateViewController(withIdentifier: identi)
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: false)
    }
    
    func addTapGesturesToToolViews(_ views: [UIView]) {
        for (index, view) in views.enumerated() {
            view.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolViewTapped(_:)))
            tapGesture.view?.tag = index // tag set karenge for identification
            view.tag = index
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func toolViewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        switch tappedView.tag {
        case 0:
            print("ToolView 1 clicked")
            navigation()
        case 1:
            print("ToolView 2 clicked")
        case 2:
            print("ToolView 3 clicked")
        case 3:
            print("ToolView 4 clicked")
        default:
            print("Unknown ToolView clicked")
        }
    }

    func navigation(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "TextToImgHome") as! TextToImgHome
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
