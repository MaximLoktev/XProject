//
//  GenderPickerView.swift
//  XProject
//
//  Created by Максим Локтев on 10.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class GenderPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    
    var genderLvl: Gender = .defaults
    
    var genderDidSelected: ((Gender) -> Void)?
    
    private let pickerArray: [Gender] = [.defaults, .android, .ios, .php]
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        genderLvl = pickerArray[0]
        
        dataSource = self
        delegate = self
        contentMode = .center
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
        pickerArray[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gender = pickerArray[row]
        genderLvl = gender
        genderDidSelected?(gender)
    }
}
