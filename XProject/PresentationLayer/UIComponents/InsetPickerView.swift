//
//  InsetPickerView.swift
//  XProject
//
//  Created by Максим Локтев on 10.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class InsetPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum Gender: String {
        case android = "Android"
        case ios = "iOS"
        case php = "PHP"
    }
    
    // MARK: - Properties
    
    var genderLvl: Gender = .ios
    
    private let pickerArray: [Gender] = [.android, .ios, .php]
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerArray.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerArray[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gender = pickerArray[row]
        genderLvl = gender
    }
    
    override func selectedRow(inComponent component: Int) -> Int {
        1
    }
}
