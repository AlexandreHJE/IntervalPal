//
//  SetDetailTableCellViewController.swift
//  myIntervalPal
//
//  Created by 胡仁恩 on 2019/4/6.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class SetDetailTableCellViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtMin: UITextField!
    @IBOutlet weak var txtSec: UITextField!
    
    var pkvMin: UIPickerView!
    var pkvSec: UIPickerView!
    let arrMinSec = (0...59).map{$0}
    var currentObjectBottomYPosion:CGFloat = 0
    var aryCurrentData = [String]()
    var aryCurrentRow = 0
    
    weak var timerTableViewController: TimerTableViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        //取得iOS系統上目前的通知中心實體
        let notificationCenter = NotificationCenter.default
        //註冊鍵盤彈出通知
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //註冊鍵盤收合通知
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        aryCurrentRow = self.timerTableViewController.currentRow
        aryCurrentData = self.timerTableViewController.timerDataArray[aryCurrentRow+2] as! [String]
        // [Optional("Workout"), Optional("2"), Optional(["w", "WORK", "01", "30"]), Optional(["r", "REST", "01", "30"]), Optional(["w", "WORK", "01", "30"]), Optional(["r", "REST", "01", "30"])]...
        //Array of setTitle, setNumbers, workingTimerDataArray, restingTimerDataArray,...
        txtTitle.text = aryCurrentData[1]
        txtMin.text = aryCurrentData[2]
        txtSec.text = aryCurrentData[3]
        
        pkvMin = UIPickerView()
        pkvMin.tag = 1
        pkvSec = UIPickerView()
        pkvSec.tag = 2
        
        pkvMin.delegate = self
        pkvMin.dataSource = self
        pkvSec.delegate = self
        pkvSec.dataSource = self
        
        txtMin.inputView = pkvMin
        txtSec.inputView = pkvSec
        
        pkvMin.selectRow(Int(txtMin.text!)!, inComponent: 0, animated: false)
        pkvSec.selectRow(Int(txtSec.text!)!, inComponent: 0, animated: false)
        
        
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
            txtMin.text = String(arrMinSec[row])
        case 2:
            txtSec.text = String(arrMinSec[row])
        default:
            txtMin.text = String(arrMinSec[row])
        }
    }
    
    @IBAction func btnSaveSetting(_ sender: UIButton)
    {
        
        aryCurrentData[1] = txtTitle.text!
        aryCurrentData[2] = txtMin.text!
        aryCurrentData[3] = txtSec.text!
        print(aryCurrentData)
        self.timerTableViewController.timerDataArray[aryCurrentRow+2] = aryCurrentData
        self.timerTableViewController.setTimer.contentArray[aryCurrentRow+2] = aryCurrentData
        self.timerTableViewController.tableView.reloadData()
        print(timerTableViewController.timerDataArray)
    }
    
}

