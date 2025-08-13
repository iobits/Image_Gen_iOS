//
//  GeneratedImgVC.swift
//  Image Generation
//
//  Created by Mac Mini on 11/08/2025.
//

import UIKit

enum ImageFormat {
    case png, jpeg
}

class GeneratedImgVC: UIViewController {
    
    @IBOutlet weak var resultImg: UIImageView!
    @IBOutlet weak var textPentView: UIView!
    @IBOutlet weak var texView: UITextView!
    
    @IBOutlet weak var downloadView: GradientView!
    @IBOutlet weak var regenerateView: UIView!
    
    
    @IBOutlet weak var typeParentView: UIView!
    @IBOutlet weak var pngView: UIView!
    @IBOutlet weak var jpegView: UIView!
    @IBOutlet weak var pdfView: UIView!
    
    var generatedImg: UIImage!
    var promptTx = ""
    var imgRype: String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        resultImg.image = generatedImg
//        texView.text = promptTx
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Helper_Fun.shared.conerRadiusForView([resultImg, textPentView, typeParentView], cornerRadius: 10.0, borderWidth: 0.5, borderColor: .clear)
        Helper_Fun.shared.conerRadiusForView([regenerateView, downloadView], cornerRadius: 20, borderWidth: 1.0, borderColor: UIColor(hex: "#FDE617"))
        addTapGesturesToToolViews([pngView, jpegView, pdfView])
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editPromptBtn(_ sender: UIButton) {
        UserDefaults.standard.set(promptTx, forKey: "PROMT")
        UserDefaults.standard.synchronize()
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionBtns(_ sender: UIButton) {
        if sender.tag == 0{
            print("regenrate")
        }else if sender.tag == 1{
            print("download")
            downloadImageAccordingToType()
        }
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
            print("png clicked")
            imgRype = "png"
            Helper_Fun.shared.styleSelectedView(allViews: [pngView, jpegView, pdfView], selectedView: pngView, borderColor: UIColor(hex: "#FF9404"), borderWidth: 1.0, cornerRadius: 10.0)
        case 1:
            print("jpeg clicked")
            imgRype = "jpeg"
            Helper_Fun.shared.styleSelectedView(allViews: [pngView, jpegView, pdfView], selectedView: jpegView, borderColor: UIColor(hex: "#FF9404"), borderWidth: 1.0, cornerRadius: 10.0)
        case 2:
            print("pdf")
            imgRype = "pdf"
            Helper_Fun.shared.styleSelectedView(allViews: [pngView, jpegView, pdfView], selectedView: pdfView, borderColor: UIColor(hex: "#FF9404"), borderWidth: 1.0, cornerRadius: 10.0)
        default:
            print("Unknown ToolView clicked")
        }
    }
    
    //SAVE IMAG ETYPE
    func saveImageAsPDF(image: UIImage) {
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        var mediaBox = CGRect(origin: .zero, size: image.size)
        
        if let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil) {
            pdfContext.beginPage(mediaBox: &mediaBox)
            pdfContext.draw(image.cgImage!, in: mediaBox)
            pdfContext.endPage()
            pdfContext.closePDF()
            
            // Save PDF to Files
            let fileName = "Image.pdf"
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(fileName)
                pdfData.write(to: fileURL, atomically: true)
                
                let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    func downloadImageAccordingToType() {
        guard let type = imgRype else {
            showAlert(withTitle: "Select Format", message: "Please select PNG, JPEG, or PDF before downloading.")
            return
        }
        guard let image = generatedImg else {
            showAlert(withTitle: "Error", message: "No image found to download.")
            return
        }
        
        switch type.lowercased() {
        case "png":
            saveImageToPhotos(image: image, format: .png)
        case "jpeg":
            saveImageToPhotos(image: image, format: .jpeg)
        case "pdf":
            saveImageAsPDF(image: image)
        default:
            break
        }
    }
    
    func saveImageToPhotos(image: UIImage, format: ImageFormat) {
        var imageData: Data?
        
        switch format {
        case .png:
            imageData = image.pngData()
        case .jpeg:
            imageData = image.jpegData(compressionQuality: 1.0)
        }
        
        guard let data = imageData, let finalImage = UIImage(data: data) else { return }
        
        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
        showAlert(withTitle: "Saved", message: "Image saved successfully in Photos.")
    }
}
