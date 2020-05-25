//
//  TweetListScreenViewController+PickerTags.swift
//  twitter
//
//  Created by aidan egan on 25/05/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import Foundation
import UIKit

extension TweetListScreenViewController: UIPickerViewDataSource, UIPickerViewDelegate {

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return times.count
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return times[row]
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedTime = times[row]
    settings.text = times[row]
}
}
