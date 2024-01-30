//
//  RecipientCountrySelectionViewModel.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

class RecipientCountrySelectionViewModel {
    private let pickerData: [String] = ["한국(KRW)", "일본(JPY)", "필리핀(PHP)"]
    private lazy var selectedCountry: String = pickerData[0]
    
    func getPickerDate() -> [String] {
        return pickerData
    }
    
    func getSelectedCountry() -> String {
        return selectedCountry
    }
    
    func setSelectedCountry(by row: Int) {
        selectedCountry = pickerData[row]
    }
}
