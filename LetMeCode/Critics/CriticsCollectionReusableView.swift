//
//  CriticsCollectionReusableView.swift
//  LetMeCode
//
//  Created by Александр Осипов on 15.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

protocol CriticsReusableViewDelegate {
    func reloadCollectionView(query: String)
}

class CriticsCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var delegate: CriticsReusableViewDelegate?
    
    @IBAction func searchDidEndEdit(_ sender: UITextField) {
        if searchTextField.text == "" {
            delegate?.reloadCollectionView(query: "all")
        } else {
            delegate?.reloadCollectionView(query: searchTextField.text ?? "all")
        }
    }
    
}
