//
//  ReviewesCollectionReusableView.swift
//  LetMeCode
//
//  Created by Александр Осипов on 14.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

protocol ReviewesReusableViewDelegate {
    func reloadCollectionView(query: String, openingDate: String)
}

class ReviewesCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var filterTextField: UITextField!
    
    var delegate: ReviewesReusableViewDelegate?
    
    var datePicker = UIDatePicker()
//    let toolBar = UIToolbar()
    
    @IBAction func searchDidEndEdit(_ sender: UITextField) {
        delegate?.reloadCollectionView(query: searchTextField.text ?? "", openingDate: filterTextField.text ?? "0001-01-01")
    }
    
    func addDate() {
        
        filterTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
//        toolBar.sizeToFit()
    }
    
    @objc func dateChanged() {
        getDataFromPicer()
    }
    
    func getDataFromPicer() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        filterTextField.text = formatter.string(from: datePicker.date)
    }
    
}
