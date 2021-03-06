//
//  SetTimer.swift
//  myIntervalPal
//
//  Created by 胡仁恩 on 2019/3/26.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class SetTimer: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var txtWorkMin: UITextField!
    @IBOutlet weak var txtWorkSec: UITextField!
    @IBOutlet weak var txtRestMin: UITextField!
    @IBOutlet weak var txtRestSec: UITextField!
    @IBOutlet weak var txtSetNumber: UITextField!
    @IBOutlet weak var txtSetTitle: UITextField!
    
    var pkvWMin: UIPickerView!
    var pkvWSec: UIPickerView!
    var pkvRMin: UIPickerView!
    var pkvRSec: UIPickerView!
    var pkvSetNum: UIPickerView!
    let arrMinSec = (0...59).map{$0}
    let arrSetNum = (1...10).map{$0}
    var currentObjectBottomYPosion:CGFloat = 0
    
    var contentArray: [Any?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取得iOS系統上目前的通知中心實體
        let notificationCenter = NotificationCenter.default
        //註冊鍵盤彈出通知
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //註冊鍵盤收合通知
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        pkvWMin = UIPickerView()
        pkvWMin.tag = 1
        pkvWSec = UIPickerView()
        pkvWSec.tag = 2
        pkvRMin = UIPickerView()
        pkvRMin.tag = 3
        pkvRSec = UIPickerView()
        pkvRSec.tag = 4
        pkvSetNum = UIPickerView()
        pkvSetNum.tag = 5
        
        pkvWMin.delegate = self
        pkvWMin.dataSource = self
        pkvWSec.delegate = self
        pkvWSec.dataSource = self
        pkvRMin.delegate = self
        pkvRMin.dataSource = self
        pkvRSec.delegate = self
        pkvRSec.dataSource = self
        pkvSetNum.delegate = self
        pkvSetNum.dataSource = self
        
        txtWorkMin.inputView = pkvWMin
        txtWorkSec.inputView = pkvWSec
        txtRestMin.inputView = pkvRMin
        txtRestSec.inputView = pkvRSec
        txtSetNumber.inputView = pkvSetNum
        
        pkvWMin.selectRow(Int(txtWorkMin.text!)!, inComponent: 0, animated: false)
        pkvWSec.selectRow(Int(txtWorkSec.text!)!, inComponent: 0, animated: false)
        pkvRMin.selectRow(Int(txtRestMin.text!)!, inComponent: 0, animated: false)
        pkvRSec.selectRow(Int(txtRestSec.text!)!, inComponent: 0, animated: false)
        pkvSetNum.selectRow(Int(txtSetNumber.text!)! - 1, inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnCreateTime(_ sender: UIButton)
    {
        createTimerData(title: txtSetTitle.text!, wMin: txtWorkMin.text!, wSec: txtWorkSec.text!, rMin: txtRestMin.text!, rSec: txtRestSec.text!, setNum: txtSetNumber.text!)
    }
    
    @IBAction func btnTest(_ sender: UIButton)
    {
        createTimerData(title: txtSetTitle.text!, wMin: txtWorkMin.text!, wSec: txtWorkSec.text!, rMin: txtRestMin.text!, rSec: txtRestSec.text!, setNum: txtSetNumber.text!)
    }
    
    @IBAction func btnLeftArrow(_ sender: UIButton)
    {
        var setNumber = Int(txtSetNumber.text!)!
        if setNumber > 1
        {
            setNumber -= 1
        }
        txtSetNumber.text! = String(setNumber)
    }
    
    @IBAction func btnRightArrow(_ sender: UIButton)
    {
        var setNumber = Int(txtSetNumber.text!)!
        if setNumber < 10
        {
            setNumber += 1
        }
        txtSetNumber.text! = String(setNumber)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue)
        
        //let testVC = segue.destination as! TestViewController
        //testVC.setTimer = self
        
        let tableVC = segue.destination as! TimerTableViewController
        tableVC.setTimer = self
        //let tableOVC = segue.destination as! TimerTableOnViewController
        //tableOVC.setTimer = self
        
    }
    
    //觸碰開始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        //將目前頁面上任何存在的鍵盤收起
        self.view.endEditing(true)
    }
    
    //MARK: - Target Action
    //鍵盤彈出的觸發事件
    @objc func keyBoardWillShow(_ sender:Notification)
    {
        print("鍵盤彈出！！！")
        print("通知資訊：\(sender)")
        if let keyboardHeight = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
        {
            print("鍵盤高度：\(keyboardHeight)")
            //計算扣除鍵盤後的可視高度
            let visiableHeight = self.view.frame.height - keyboardHeight
            //如果『Y軸底緣位置』比『可視高度』還高，表示輸入元件被鍵盤遮住
            if currentObjectBottomYPosion > visiableHeight
            {
                //移動『Y軸底緣位置』與『可視高度』之間的差值（即被遮住的範圍高度，再少10點）
                self.view.frame.origin.y -= currentObjectBottomYPosion - visiableHeight + 10
            }
        }
    }
    
    //鍵盤收合的觸發事件
    @objc func keyBoardWillHide()
    {
        print("鍵盤收合！！！")
        //將已經上移的畫面回到原點位置
        self.view.frame.origin.y = 0
    }
    
    
    //文字輸入框對應的Did End On Exit事件，拉出後不需撰寫程式碼，即可讓虛擬鍵盤的return鍵收起鍵盤
    @IBAction func didEndOnExit(_ sender: UITextField)
    {
        
    }
    
    //文字輸入框開始編輯事件
    @IBAction func editingDidBegin(_ sender: UITextField)
    {
        //個別指定特殊鍵盤
        switch sender.tag
        {
            default:
            sender.keyboardType = .default
        }
        //紀錄目前輸入元件的Y軸底緣位置（＝原點的y座標+輸入元件的高度）
        currentObjectBottomYPosion = sender.frame.origin.y + sender.frame.size.height
    }
    
    //MARK: - UIPickerViewDataSource
    //每一個滾輪有幾段
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch pickerView.tag
        {
        case 5:     //Set組滾輪的數量
            return arrSetNum.count
        default:     //分鐘秒鐘滾輪的數量
            return arrMinSec.count
        }
    }
    
    //MARK: - UIPickerViewDelegate
    //提供滾輪每一段每一行所呈現的文字
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch pickerView.tag
        {
        case 5:    //Set組滾輪的文字
            return String(arrSetNum[row])
        default:  //分鐘秒鐘滾輪的文字
            return String(arrMinSec[row])
        }
    }
    
    //選定滾輪的特定資料行時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch pickerView.tag
        {
        case 1:
            txtWorkMin.text = String(arrMinSec[row])
        case 2:
            txtWorkSec.text = String(arrMinSec[row])
        case 3:
            txtRestMin.text = String(arrMinSec[row])
        case 4:
            txtRestSec.text = String(arrMinSec[row])
        case 5:
            txtSetNumber.text = String(arrSetNum[row])
        default:
            txtSetNumber.text = String(arrSetNum[row])
        }
    }
    
    //MARK: - 產生Timer們的資料陣列
    func createTimerData(title: String, wMin: String, wSec: String, rMin: String, rSec: String, setNum: String)
    {
        
        var contents: [String] = []
        
        func createWorkTimerData()
        {
            contents = []
            contents.append("w")
            contents.append("WORK")
            contents.append(wMin)
            contents.append(wSec)
            contentArray.append(contents)
        }
        
        func createRestTimerData()
        {
            contents = []
            contents.append("r")
            contents.append("REST")
            contents.append(rMin)
            contents.append(rSec)
            contentArray.append(contents)
        }
        
        contentArray.append(title)
        contentArray.append(setNum)
        for _ in 1...Int(setNum)! {
            createWorkTimerData()
            createRestTimerData()
            
        }
        contentArray.removeLast()
        //print(contentArray)
    }
    
    
}
