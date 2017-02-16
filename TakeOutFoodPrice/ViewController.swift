//
//  ViewController.swift
//  TakeOutFoodPrice
//
//  Created by 强新宇 on 2017/2/15.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kWindow = UIApplication.shared.keyWindow
let tableViewY: CGFloat = 210


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let cell_key = "cell_key"

    @IBOutlet weak var allPriceTF: UITextField!
    @IBOutlet weak var distributionCostTF: UITextField!
    @IBOutlet weak var discountTF: UITextField!
    @IBOutlet weak var payPriceTF: UITextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var explanLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBAction func clickCloseBtn(_ sender: Any) {
        scrollView.isHidden = true
        closeBtn.isHidden = true
    }
    @IBAction func clickExplanBtn(_ sender: Any) {
        view.endEditing(true)
        scrollView.isHidden = false
        closeBtn.isHidden = false
        
    }
    @IBAction func clickAllClearBtn(_ sender: Any) {
        allPriceTF.text = ""
        distributionCostTF.text = ""
        discountTF.text = ""
        payPriceTF.text = ""
        
    }
    @IBAction func clickCalculationBtn(_ sender: Any) {
        
        view.endEditing(true)
        
        print(groupArray!)
        
        if  !isAccordRule(text: allPriceTF.text, message: "总价没填 或者为0") ||
            !isAccordRule(text: distributionCostTF.text, message: "其他费用没填 或者为0") ||
            !isAccordRule(text: discountTF.text, message: "优惠没填 或者为0") ||
            !isAccordRule(text: payPriceTF.text, message: "支付费用没填 或者为0")
        {
            return
        }
        
        let allPrice = Float(allPriceTF.text!)!
        let distributionCost = Float(distributionCostTF.text!)!
        let discount = Float(discountTF.text!)!
        let payPrice = Float(payPriceTF.text!)!

        if allPrice != discount + payPrice {
            showAlert(message: "总价应该等于优惠 + 支付")
            return
        }
        
        if groupArray!.count == 1 {
            showAlert(message: "就你一个人还算什么算 =，=")
            return
        } else if groupArray!.count == 0 {
            showAlert(message: "没添加人~~~")
            return
        }
        
        var peopleAllPrice: Float = 0
        
        for data in groupArray! {
            if let priceStr = data[all_price_key] {
                let price = Float(priceStr)!
                peopleAllPrice += price
            }
        }
        
        if allPrice != peopleAllPrice + distributionCost {
            showAlert(message: "添加的人的花费之和 + 其他费用 需要等于总价")
            return
        }
        
        
        let distributionCostAverage = distributionCost / Float(groupArray!.count)
        
        
        for index in 0..<groupArray!.count {
            if var data = groupArray?.remove(at: index) {
                if let priceStr = data[all_price_key] {
                    let price = Float(priceStr)! + distributionCostAverage
                    
                    let result = price - (price / allPrice * discount)
                    data.updateValue("\(result)", forKey: result_key)
                    
                }
                groupArray?.insert(data, at: index)
            }
        }
        
        
        tableView?.reloadData()
        showAlert(message: "计算完成")
        
    }
    
    func isAccordRule(text: String?, message: String) -> Bool {
        if text == nil || text!.characters.count == 0 || Int(text!) == 0 {
            showAlert(message: message)
            return false
        }
        return true
    }
    
    func showAlert(message: String)  {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in}))
            
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func clickAllClearPersonBtn(_ sender: Any) {
        count = 0
        groupArray?.removeAll()
        tableView?.reloadData()
    }
   
    @IBAction func clickAddBtn(_ sender: Any) {
        count += 1
        groupArray?.append([name_key: "\(count)号"])
        tableView?.reloadData()
    }
   
    
    var tableView: UITableView?
    var groupArray: [[String : String]]?
   
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        groupArray = []

        tableView = UITableView(frame: CGRect(x: 0, y: tableViewY, width: kScreenWidth, height: kScreenHeight - tableViewY))
        tableView?.backgroundColor = UIColor.white
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: cell_key)
        tableView?.tableFooterView = UIView()
        
       
        
        view.addSubview(tableView!)
        
        
        view.sendSubview(toBack: tableView!)
        
        
        explanLabel.text = "\n本App是为了多人一起下单，快速计算出每人应付款。\n\n\n使用方法：\n\n回收键盘请点击任意空白处\n\n总价：整个订单的价格\n共优惠：所有的优惠（满减、红包等）\n共支付：最后支付的价格\n其他费用：打包费、配送费等\n\n+：添加人员\n\n清除：清除所有人员（单个删除可以左滑此人）\n\n计算：先验证填写是否正确，然后计算出每人应付款。\n\n\n计算规则：\n其他费用进行均摊，然后 \n\n(个人费用 + 其他费用的平均) - ((个人费用 + 其他费用的平均) ➗ 总价格 x 优惠价格) \n\n得出个人应付价格";
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: cell_key, for: indexPath) as! TableViewCell
        cell.myData = groupArray![indexPath.row]
        cell.indexPath = indexPath
        
        weak var weakSelf = self
        cell.setTFEndEditing { (tf, idxp, myData) in
            weakSelf!.textFieldDidEndEditing(tf)
            if let idxp = idxp {
                if let myData = myData {
                    weakSelf!.groupArray!.remove(at: idxp.row)
                    weakSelf!.groupArray!.insert(myData, at: idxp.row)
                }
            }
        }
        
        cell.setTFBegainEditing { (tf) in
            weakSelf!.textFieldDidBeginEditing(tf)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupArray?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    
    
    
    
    

    //MARK: - Text Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateTextView(tf: textField, up: false)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTextView(tf: textField, up: true)
    }
    
    
    func getScrollViewWithView(view: UIView) -> UIScrollView? {
        
        if view.superview == nil {
            return nil
        } else if (view.superview?.isKind(of: UIScrollView.classForCoder()))! {
            return view.superview as! UIScrollView?
        }
        
        return getScrollViewWithView(view: view.superview!)
    }
   
    
    var moveHight: CGFloat = 0
    func animateTextView(tf: UITextField, up: Bool) {
        weak var weakSelf = self
        DispatchQueue.global().async {
            var x = weakSelf!.moveHight
            
            if up {
                var keyBoard_height: CGFloat = 253;
                if tf.keyboardType == .numberPad {
                    keyBoard_height = 216
                }
                
                let scrollView = weakSelf!.getScrollViewWithView(view: tf)
                
                var offset: CGFloat = 0
                if scrollView != nil {
                    let frame = tf.superview?.convert(tf.frame, to: scrollView)
                    offset = ((scrollView?.frame.size.height)! - (frame?.origin.y)! + scrollView!.contentOffset.y) - tf.frame.size.height
                    if offset < 0 {
                        DispatchQueue.main.async {
                            scrollView?.setContentOffset(CGPoint(x: scrollView!.contentOffset.x, y: scrollView!.contentOffset.y - offset), animated: true)
                        }
                    }
                }
                
                
                let frame = tf.superview?.convert(tf.frame, to: kWindow)
                x = (frame?.maxY)! > kScreenHeight - keyBoard_height ? (frame?.maxY)! - kScreenHeight + keyBoard_height + 5 : 0
                
                if offset < 0 {
                    x += offset
                }
                weakSelf?.moveHight = x
                
            }
            
            if x == 0 {
                return
            }
            
            let movementDistance = x
            let movementDuration = 0.3
            
            let movement = up ? -movementDistance : movementDistance
            
            UIView.beginAnimations("anim", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)
            
            DispatchQueue.main.async {
                kWindow?.frame = kWindow!.frame.offsetBy(dx: 0, dy: movement)
                UIView.commitAnimations()
            }
        }
        
        
        
    }
    
    
    
  
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

