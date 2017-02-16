//
//  TouchEndEdit.swift
//  TakeOutFoodPrice
//
//  Created by 强新宇 on 2017/2/15.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

class TouchEndEdit: UIView {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
