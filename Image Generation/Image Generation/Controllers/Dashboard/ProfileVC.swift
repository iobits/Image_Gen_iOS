//
//  ProfileVC.swift
//  Image Generation
//
//  Created by Mac Mini on 12/08/2025.
//

import UIKit

class ProfileCell: UICollectionViewCell{
    
    @IBOutlet weak var imgView: UIImageView!
//    @IBOutlet weak var imgHeight: NSLayoutConstraint!
//    @IBOutlet weak var imgWidth: NSLayoutConstraint!
}

class ProfileVC: UIViewController {

    
    @IBOutlet weak var tabView: UIView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegate and dataSource
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabView.layer.cornerRadius = 35.0
    }
    
    @IBAction func tabActionBtn(_ sender: UIButton) {
        if sender.tag == 0{
            print("tab 1")
            tabNavigation(identi: "HomeVC")
        }else if sender.tag == 1{
            print("tab 3")
            tabNavigation(identi: "ToolVC")
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

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource{
    // UICollectionViewDelegate, UICollectionViewDataSource functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
    
        //let thisElement = colectionArr[indexPath.item]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = UIColor.clear

        cell.layer.shadowColor = UIColor.clear.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        
        
        return cell
    }
}

// extention for UICollectionViewDelegateFlowLayout
extension ProfileVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2 // har row me 3 cells
        let spacing: CGFloat = 10 // line spacing
        let sectionInsets = CGFloat(5 * 2) // left + right insets
        
        let totalSpacing = (itemsPerRow - 1) * spacing + sectionInsets
        let availableWidth = collectionView.bounds.width - totalSpacing
        
        let cellWidth = floor(availableWidth / itemsPerRow)
        
        return CGSize(width: cellWidth, height: cellWidth) // square cells
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
