//
//  TextToImgHome.swift
//  Image Generation
//
//  Created by Mac Mini on 06/08/2025.
//

import UIKit
import AVKit
import Speech

struct TrendOptions {
    let trandImg: String
    let title: String
}

struct RatioOption {
    let ratioImg: String
    let title: String
    let width: Int
    let height: Int
}
struct textToImageData{
    let prompt: String
    let hieght: Int
    let weight: Int
    let stylId: String
}

class textToImgCell: UICollectionViewCell{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
}

class TextToImgHome: UIViewController {
    
    @IBOutlet weak var typeTextView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHegiht: NSLayoutConstraint!
    @IBOutlet weak var characterCountLbl: UILabel!
    @IBOutlet weak var collectionViews: UICollectionView!
    
    @IBOutlet weak var animeView: UIView!
    @IBOutlet weak var cartoonishView: UIView!
    @IBOutlet weak var threeDView: UIView!
    @IBOutlet weak var realisticView: UIView!
    @IBOutlet weak var viewAllLbl: UILabel!
    @IBOutlet weak var generateView: GradientView!
    
    let maxCharacterLimit = 500
    let placeholderText = "Write your creattion in detail here ..."
    var selectedIndex: Int = 0 // By default first cell selected
    
    // RECORDING
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var fullText: String = ""  // store full spoken text
    var height = 0
    var width = 0
    var stylyId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        setupPlaceholder()
        updateCharacterCount()
        collectionViews.showsVerticalScrollIndicator = false
        collectionViews.showsHorizontalScrollIndicator = false
        addTapGesturesToToolViews([animeView, cartoonishView, threeDView, realisticView, generateView])
        // Enable interaction
        viewAllLbl.isUserInteractionEnabled = true
        
        // Add tap gesture
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewAllTap))
        viewAllLbl.addGestureRecognizer(viewTap)
        Helper_Fun.shared.requestPermissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        typeTextView.layer.cornerRadius = 10.0
        generateView.layer.cornerRadius = 20.0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let promptTex = UserDefaults.standard.string(forKey: "PROMT")
        textView.text = promptTex
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
        if sender.tag == 0 {
            print("copy")
            
            // Agar textView me text hai to copy karo
            if let textToCopy = textView.text, !textToCopy.isEmpty {
                UIPasteboard.general.string = textToCopy
                print("✅ Text copied to clipboard")
            } else {
                print("⚠️ No text to copy")
            }
            
        }else if sender.tag == 1{
            print("mic")
            checkMicPermissionAndToggleRecording(sender)
        }
    }
    
    func checkMicPermissionAndToggleRecording(_ sender: UIButton) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    // Toggle recording state
                    if self.audioEngine.isRunning {
                        // Stop recording
                        self.stopRecording()
                        sender.tintColor = .systemBlue // Default color
                        print("Recorded text: \(self.textView.text ?? "")")
                        self.showAlert(withTitle: ERROR_KEYs.shared.stopRecodingTitle, message: ERROR_KEYs.shared.stopRecodingSucess)
                    } else {
                        // Start recording
                        sender.tintColor = .systemRed // Active recording color
                        self.startRecording()
                    }
                } else {
                    // Show alert to enable mic in settings
                    let alert = UIAlertController(
                        title: ERROR_KEYs.shared.microWarningTitle,
                        message: ERROR_KEYs.shared.microMgs,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func viewAllTap() {
        print("📢 Label clicked!")
        let vc = storyboard?.instantiateViewController(withIdentifier: "StyleVC") as! StyleVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
        vc.callback = { styleNum in
            self.stylyId = styleNum
        }
    }
    
    // MARK: - Placeholder Setup
    func setupPlaceholder() {
        Helper_Fun.shared.styleSelectedView(allViews: [animeView, cartoonishView, threeDView, realisticView], selectedView: animeView, borderColor: UIColor(hex: "#FF9404"), borderWidth: 1.0, cornerRadius: 10.0)
        textView.text = placeholderText
        textView.textColor = .white
    }
    // MARK: - Helpers
    func updateCharacterCount() {
        let count = textView.text == placeholderText ? 0 : textView.text.count
        characterCountLbl.text = "(\(count)/\(maxCharacterLimit) Words)"
    }
}

extension TextToImgHome: UITextViewDelegate{
    // MARK: - UITextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .white // Dark text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Limit characters
        if textView.text.count > maxCharacterLimit {
            textView.text = String(textView.text.prefix(maxCharacterLimit))
        }
        
        updateCharacterCount()
        adjustTextViewHeight()
    }
    
    func adjustTextViewHeight() {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textViewHegiht.constant = min(estimatedSize.height, 200) // Max height 200
        view.layoutIfNeeded()
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
            print("Anime clicked")
            Helper_Fun.shared.styleSelectedView(allViews: [animeView, cartoonishView, threeDView, realisticView], selectedView: animeView, borderColor: UIColor(hex: "#FF9404"), borderWidth: 1.0, cornerRadius: 10.0)
        case 1:
            print("cartoon clicked")
            Helper_Fun.shared.styleSelectedView(allViews: [animeView, cartoonishView, threeDView, realisticView], selectedView: cartoonishView, borderColor: UIColor(hex: "#FF9404"), borderWidth: 1.0, cornerRadius: 10.0)
        case 2:
            print("3D clicked")
            Helper_Fun.shared.styleSelectedView(allViews: [animeView, cartoonishView, threeDView, realisticView], selectedView: threeDView, borderColor: UIColor(hex: "#FF9404"), borderWidth: 1.0, cornerRadius: 10.0)
        case 3:
            print("Realistic clicked")
            Helper_Fun.shared.styleSelectedView(allViews: [animeView, cartoonishView, threeDView, realisticView], selectedView: realisticView, borderColor: UIColor(hex: "#FF9404"), borderWidth: 1.0, cornerRadius: 10.0)
        case 4:
            print("Generate iMage Tap")
            if width == 0{
                showAlert(withTitle: "⚠ Warning", message: "Weight is compulsory")
            }else if height == 0{
                showAlert(withTitle: "⚠ Warning", message: "Height is compulsory")
            }else if stylyId.isEmpty == true || stylyId == ""{
                showAlert(withTitle: "⚠ Warning", message: "Please select a style")
            }
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProgressVc") as! ProgressVc
            vc.modalPresentationStyle = .fullScreen
            vc.obj = textToImageData(prompt: textView.text, hieght: height, weight: width, stylId: stylyId)
            present(vc, animated: false)
        default:
            print("Unknown ToolView clicked")
        }
    }
}

extension TextToImgHome: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CONSTANTs.shared.ratios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textToImgCell", for: indexPath) as! textToImgCell
        cell.mainView.layer.cornerRadius = 15
        cell.mainView.layer.borderWidth = 1
        cell.mainView.layer.borderColor = (indexPath.item == selectedIndex) ? UIColor(hex: "#FF9404").cgColor : UIColor.clear.cgColor
        cell.imgView.image = UIImage(named: CONSTANTs.shared.ratios[indexPath.row].ratioImg)
        cell.titleLbl.text = CONSTANTs.shared.ratios[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = storyboard?.instantiateViewController(withIdentifier: "RatioPopupVC") as! RatioPopupVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: false)
            vc.callback = { wi, hi in
                self.height = hi
                self.width = wi
            }
            return
        }
        
        selectedIndex = indexPath.item
        collectionView.reloadData() // Refresh all cells to update border color
    }
}

//MARK: - RECORDING FUNCTIONSLITY
extension TextToImgHome{
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionTask = nil
            recognitionRequest = nil
        }
    }

    func startRecording() {
        if audioEngine.isRunning {
            print("Already recording")
            return
        }
    
        recognitionTask?.cancel()
        recognitionTask = nil
    
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session error: \(error)")
            return
        }
    
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
        guard let inputNode = audioEngine.inputNode as AVAudioInputNode? else {
            fatalError("Audio engine has no input node")
        }
    
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create request")
        }
    
        recognitionRequest.shouldReportPartialResults = true
    
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let spokenText = result.bestTranscription.formattedString
                self.fullText = spokenText
                self.textView.text = self.fullText
            }
    
            if error != nil || (result?.isFinal ?? false) {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
    
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
    
        audioEngine.prepare()
    
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine couldn't start: \(error)")
        }
    }
}

