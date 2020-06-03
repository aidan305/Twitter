import Foundation
import UIKit

protocol GenericPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class GenericPickerView: UIPickerView {

    var rowItemTitles : [String] = []
    var selectedRow: String = ""
    
    public private(set) var toolbar: UIToolbar?
    public weak var genericDelegate: GenericPickerViewDelegate?
    public private(set) var customPicker = UIPickerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.customPicker.dataSource = self
        self.customPicker.delegate = self
    }
    
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.genericDelegate?.didTapDone()
    }

    @objc func cancelTapped() {
        self.genericDelegate?.didTapCancel()
    }
    
}

extension GenericPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return self.rowItemTitles.count
       }
       
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return self.rowItemTitles[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          selectedRow = self.rowItemTitles[row]
          print("selected row \(self.rowItemTitles[row])")
       }
   }

    
    
    





