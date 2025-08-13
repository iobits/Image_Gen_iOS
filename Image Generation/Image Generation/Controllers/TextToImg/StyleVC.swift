//
//  StyleVC.swift
//  Image Generation
//
//  Created by Mac Mini on 11/08/2025.
//

import UIKit

class StyleCollectionCell: UICollectionViewCell{
    
}

class StyleVC: UIViewController {
    var callback : ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension StyleVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StyleCollectionCell", for: indexPath) as! StyleCollectionCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callback?("stylID")
        dismiss(animated: true, completion: nil)
    }
    
}
