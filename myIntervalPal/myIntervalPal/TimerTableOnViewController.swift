//
//  TimerTableOnViewController.swift
//  myIntervalPal
//
//  Created by Alexhu on 2019/4/3.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class TimerTableOnViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var setTimer: SetTimer!
    @IBOutlet weak var btnStartPauseTimer: UIButton!
    @IBOutlet weak var timeTableView: UITableView!
    var timerDataArray: [Any?]!
    
    var timer: Timer!
    var builtInIndicator = 0
    var isTimerPlayed = false
    var runningType = 0
    var workMinSec: (String, String) = ("","")
    var restMinSec: (String, String) = ("","")
    var timeInterval: TimeInterval!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerDataArray = setTimer.contentArray
        print(setTimer.contentArray)
        print(timerDataArray)
        timeTableView.delegate = self
        timeTableView.dataSource = self
        
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
    }
    
    //倒數計時功能
    @IBAction func btnStartPauseTimer(_ sender: UIButton) {
        if isTimerPlayed == false && timer == nil
        {
            isTimerPlayed = true
            btnStartPauseTimer.setTitle("暫停倒數", for: .normal)
            btnStartPauseTimer.setTitleColor(.red, for: .normal)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.builtInIndicator += 1
                print("timer is running... currentTime: \(self.builtInIndicator)")
                if self.runningType == 0
                {
                    
                   
                    //self.workoutTimer.lblMin.text! = self.countDownTimer(timerMin: self.workoutTimer.lblMin.text!, timerSec: self.workoutTimer.lblSec.text!).0
                    //self.workoutTimer.lblSec.text! = self.countDownTimer(timerMin: self.workoutTimer.lblMin.text!, timerSec: self.workoutTimer.lblSec.text!).1
                }
                else if self.runningType == 1
                {
                    
                    //self.restingTimer.lblMin.text! = self.countDownTimer(timerMin: self.restingTimer.lblMin.text!, timerSec: self.restingTimer.lblSec.text!).0
                    //self.restingTimer.lblSec.text! = self.countDownTimer(timerMin: self.restingTimer.lblMin.text!, timerSec: self.restingTimer.lblSec.text!).1
                }
            })
        }
        else if isTimerPlayed == true
        {
            isTimerPlayed = false
            btnStartPauseTimer.setTitle("倒數計時", for: .normal)
            btnStartPauseTimer.setTitleColor(.blue, for: .normal)
            timer.invalidate()
            timer = nil
        }
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 2 * (Int(timerDataArray[1] as! String)!)
        return 2 * (Int(setTimer.contentArray[1] as! String)!)
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTimerCell", for: indexPath) as! WorkoutTimerCell
            cell.workoutTimer.lblMinSec.text = String.timeString(time: (convertTimeInterval(minText: (setTimer.contentArray[indexPath.row+2] as! [String])[2], secText: (setTimer.contentArray[indexPath.row+2] as! [String])[3])))
            //cell.workoutTimer.lblMin.text = ((setTimer.contentArray[indexPath.row+2]) as! [String])[2]
            //cell.workoutTimer.lblSec.text = ((setTimer.contentArray[indexPath.row+2]) as! [String])[3]
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestingTimerCell", for: indexPath) as! RestingTimerCell
            cell.restingTimer.lblMinSec.text = String.timeString(time: (convertTimeInterval(minText: (setTimer.contentArray[indexPath.row+2] as! [String])[2], secText: (setTimer.contentArray[indexPath.row+2] as! [String])[3])))
            //cell.restingTimer.lblMin.text = ((setTimer.contentArray[indexPath.row+2]) as! [String])[2]
            //cell.restingTimer.lblSec.text = ((setTimer.contentArray[indexPath.row+2]) as! [String])[3]
            //cell.frame.height = cell.restingTimer.container.frame.height
            return cell
        }
        
        // Configure the cell...
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    
    /*
     // Override to support conditional editing of the table view.
      func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
        return true
     }

    

     // Override to support editing the table view.
    private  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
     }
    */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("第\(indexPath.row)行儲存格被點擊")
    }
}
