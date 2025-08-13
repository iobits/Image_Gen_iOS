//
//  HomeVC.swift
//  Image Generation
//
//  Created by Mac Mini on 12/08/2025.
//

import UIKit

class trendCollectionCell: UICollectionViewCell{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Circle banane ka sahi time
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
    }
    
    private func setupUI() {
        // Main capsule
//        imgView.layer.cornerRadius = imgView.frame.width / 2
//        imgView.clipsToBounds = true
           
        
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.clear.cgColor
        mainView.backgroundColor = .clear
        mainView.layer.cornerRadius = 23.0
        
        // Icon circle
        imgView.layer.masksToBounds = true
        
    }
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var v4: UIView!
    @IBOutlet weak var tabView: UIView!
    var selectedIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper_Fun.shared.conerRadiusForView([v1, v2, v3, v4], cornerRadius: 10, borderWidth: 1.0, borderColor: UIColor(hex: "#FF9404"))
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabView.layer.cornerRadius = 35.0
    }
    @IBAction func tabActionBtn(_ sender: UIButton) {
        if sender.tag == 1{
            print("tab 1")
            tabNavigation(identi: "ToolVC")
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
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CONSTANTs.shared.trendArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendCollectionCell", for: indexPath) as! trendCollectionCell
        
        // Capsule border
        if indexPath.item == selectedIndex {
            cell.mainView.layer.borderColor = UIColor(hex: "#FF9404").cgColor
            cell.mainView.layer.backgroundColor = UIColor.black.cgColor
        } else {
            cell.mainView.layer.borderColor = UIColor.darkGray.cgColor
            cell.mainView.layer.backgroundColor = UIColor.clear.cgColor
        }
        
        // Set icon and title
        cell.imgView.image = UIImage(named: CONSTANTs.shared.trendArr[indexPath.row].trandImg)
        cell.titleLbl.text = CONSTANTs.shared.trendArr[indexPath.row].title
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 40) // adjust for your design
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        selectedIndex = indexPath.item
        collectionView.reloadItems(at: [IndexPath(item: previousIndex, section: 0), indexPath])

    }
}
