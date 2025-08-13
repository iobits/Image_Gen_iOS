//
//  RatioPopupVC.swift
//  Image Generation
//
//  Created by Mac Mini on 11/08/2025.
//

import UIKit
import DropDown

class RatioPopupVC: UIViewController {

    @IBOutlet weak var widthLbl: UITextField!
    @IBOutlet weak var heightLbl: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var applyView: UIView!
    @IBOutlet weak var widthView: UIView!
    @IBOutlet weak var heightView: UIView!
    
    var callback : ((Int, Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper_Fun.shared.conerRadiusForView([mainView], cornerRadius: 10.0, borderWidth: 1.5, borderColor: UIColor(hex: "#FF9404"))
        Helper_Fun.shared.conerRadiusForView([widthLbl, heightLbl], cornerRadius: 10.0, borderWidth: 0.5, borderColor: UIColor.lightGray)
        
        Helper_Fun.shared.conerRadiusForView([cancelView, applyView], cornerRadius: 20.0, borderWidth: 1.0, borderColor: .clear)
    }

    
    @IBAction func btnActions(_ sender: UIButton) {
        if sender.tag == 0{
            print("cancel")
            dismiss(animated: true, completion: nil)
        }else if sender.tag == 1{
            print("apply")
            if widthLbl.text?.isEmpty == true || widthLbl.text == "" || widthLbl.text == "0"{
                showAlert(withTitle: "⚠ Warning", message: "Please enter a valid width")
            }else if heightLbl.text?.isEmpty == true || heightLbl.text == "" || heightLbl.text == "0"{
                showAlert(withTitle: "⚠ Warning", message: "Please enter a valid height")
            }
            let width = Int(widthLbl.text ?? "0")
            let hight = Int(heightLbl.text ?? "0")
            callback?(width ?? 0, hight ?? 0)
            
        }
    }
}
