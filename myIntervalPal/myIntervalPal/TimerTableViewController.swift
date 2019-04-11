//
//  TimerTableViewController.swift
//  myIntervalPal
//
//  Created by 胡仁恩 on 2019/3/26.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class TimerTableViewController: UITableViewController {


    weak var setTimer: SetTimer!
    var timerDataArray: [Any?]!
    
    //紀錄單一資料行
    var arrRow = [Any?]()
    //查詢到的資料表所存放的陣列（用於離線資料集）
    var arrTable = [Any?]()
    //目前被點選的資料行
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // [Optional("Workout"), Optional("2"), Optional(["w", "WORK", "01", "30"]), Optional(["r", "REST", "01", "30"]), Optional(["w", "WORK", "01", "30"]), Optional(["r", "REST", "01", "30"])]...
        //Array of setTitle, setNumbers, workingTimerDataArray, restingTimerDataArray,...
        //self.tableView.reloadData()
        timerDataArray = setTimer.contentArray
        print(setTimer.contentArray)
        print(timerDataArray)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //在導覽列右側增加"新增"按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Workout!", style: .plain, target: self, action: #selector(btnWorkout))
    }
    
    
    
    //點選儲存格換頁時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print("點選儲存格由導覽線換頁時")
        let setDetailVC = segue.destination as! SetDetailTableCellViewController
        setDetailVC.timerTableViewController = self
        
    }
    
    //由導覽列右側的"新增"按鈕呼叫
    @objc func btnWorkout()
    {
        print("新增按鈕被按下")
        //從StoryBoard上以特定ID來初始化新增頁面
        let doWorkoutVC = self.storyboard?.instantiateViewController(withIdentifier: "DoWorkoutViewController") as! DoWorkoutViewController
        //讓新增畫面取得此頁的類別實體
        doWorkoutVC.timerTableViewController = self
        
        //推入新增頁面
        self.show(doWorkoutVC, sender: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 2 * (Int(timerDataArray[1] as! String)!)
        return 2 * (Int(setTimer.contentArray[1] as! String)!) - 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("第\(indexPath.row)行儲存格被點擊")
        currentRow = indexPath.row
    }
}
