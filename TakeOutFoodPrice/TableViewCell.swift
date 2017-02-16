//
//  TableViewCell.swift
//  TakeOutFoodPrice
//
//  Created by 强新宇 on 2017/2/15.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

let name_key = "name"
let all_price_key = "allPrice"
let result_key = "result"

class TableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var allPriceTF: UITextField!
    @IBOutlet weak var resultTF: UITextField!
    
    var indexPath: IndexPath?
    
    var tfEndEditing: ((UITextField, IndexPath?, [String: String]?) -> ())?
    func setTFEndEditing(tfEndEditing: ((UITextField, IndexPath?,[String: String]?) -> ())?) {
        self.tfEndEditing = tfEndEditing
    }
    
    var tfBegainEditing: ((UITextField) -> ())?
    func setTFBegainEditing(tfBegainEditing: ((UITextField) -> ())?) {
        self.tfBegainEditing = tfBegainEditing
    }
    
    var myData: [String : String]? {
        willSet {
            if let dic = newValue {
                nameTF.text = dic[name_key]
                allPriceTF.text = dic[all_price_key]
                resultTF.text = dic[result_key]
            }
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfBegainEditing?(textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if textField == nameTF {
                let _ = myData?.updateValue(text, forKey: name_key)

            } else if textField == allPriceTF {
                let _ = myData?.updateValue(text, forKey: all_price_key)
            }
        }
        tfEndEditing?(textField,indexPath,myData)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
