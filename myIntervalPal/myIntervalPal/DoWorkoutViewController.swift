//
//  DoWorkoutViewController.swift
//  myIntervalPal
//
//  Created by 胡仁恩 on 2019/4/6.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit
import UICircularProgressRing
import AVFoundation

class DoWorkoutViewController: UIViewController, AVAudioPlayerDelegate {

    
    weak var timerTableViewController: TimerTableViewController!
    @IBOutlet weak var initialTimer: InitialTimer!
    @IBOutlet weak var currentTimer: UILabel!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var outletPlayPauseBtm: UIButton!
    @IBOutlet weak var timerTitle: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    var beepPlayer: AVAudioPlayer!
    var timer: Timer!
    var timerData = [Any?]()
    var timerNum = 0        //指向第幾個TimerData
    var totalTimers = 0
    var currentProgress = 1
    var isTimerPlayed = false
    var runningType = 0
    var currentTimerInterval: TimeInterval!
    var initialTimeInterval: TimeInterval = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerData = self.timerTableViewController.timerDataArray
        timerData.removeFirst(2)
        totalTimers = timerData.count
        
        progressRing.backgroundColor = .white
        progressRing.outerRingColor = .gray
        progressRing.innerRingColor = .orange
        progressRing.outerRingWidth = 10
        progressRing.innerRingWidth = 8
        progressRing.style = .inside
        progressRing.font = UIFont.boldSystemFont(ofSize: 40)
        progressRing.shouldShowValueText = false
        currentTimerInterval = convertTimeInterval(minText: (timerData[timerNum] as! [String])[2], secText: (timerData[timerNum] as! [String])[3])
        currentTimer.text = String.timeString(time: currentTimerInterval)
        progressRing.minValue = 0.0
        progressRing.value = 0.0
        progressRing.maxValue = CGFloat(currentTimerInterval)
        timerTitle.text = (timerData[timerNum] as! [String])[1]
        progressLabel.text = String(format: "%02i/%02i", currentProgress, totalTimers)
        initialTimer.isHidden = true
        
        // [Optional("Workout"), Optional("2"), Optional(["w", "WORK", "01", "30"]), Optional(["r", "REST", "01", "30"]), Optional(["w", "WORK", "01", "30"]), Optional(["r", "REST", "01", "30"])]...
        //Array of setTitle, setNumbers, workingTimerDataArray, restingTimerDataArray,...
        }
        
    
    
    @IBAction func btnPlay(_ sender: UIButton!) {
        if isTimerPlayed == false && timer == nil
        {
            initialTimer.isHidden = false   //顯示
            initialTimer.lblTimer.text = "5"
            initialTimeInterval = 5
            isTimerPlayed = true
            outletPlayPauseBtm.setTitle("pause", for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if self.initialTimer.isHidden == false && self.initialTimeInterval > 0
                {
                    self.initialTimeInterval -= 1
                    self.initialTimer.lblTimer.text = String(Int(self.initialTimeInterval))
                    do{
                        self.beepPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "beep_second", ofType: "mp3")!))
                        self.beepPlayer.delegate = self
                        self.beepPlayer.play()
                    }catch{
                        
                    }
                    if self.initialTimeInterval == 0 {
                        self.initialTimer.isHidden = true
                    }
                }
                else if self.currentTimerInterval > 0 && self.initialTimer.isHidden == true
                {
                    self.currentTimerInterval -= 1
                    self.currentTimer.text = String.timeString(time: self.currentTimerInterval)
                    self.progressRing.value += 1
                    print("Value:\(self.progressRing.value), MaxValue:\(self.progressRing.maxValue)")
                    if self.currentTimerInterval < 6
                    {
                        DispatchQueue.main.async {
                            self.playBeepSound(self.currentTimerInterval)
                        }
                    }
                    
                }
                else if self.currentTimerInterval == 0 && self.isTimerPlayed != false && self.initialTimer.isHidden == true
                {
                    self.currentProgress += 1
                    if self.checkTimerShouldKeepRunning(self.currentProgress, self.totalTimers)
                    {
                        self.setNextTimer()
                        DispatchQueue.main.async {
                            self.playSoundByTimerType((self.timerData[self.timerNum] as! [String])[1])
                        }
//                        self.timerNum += 1
//                        self.currentTimerInterval = convertTimeInterval(minText: (self.timerData[self.timerNum] as! [String])[2], secText: (self.timerData[self.timerNum] as! [String])[3])
//                        self.currentTimer.text = String.timeString(time: self.currentTimerInterval)
//                        self.progressRing.value = 0
//                        self.progressRing.maxValue = CGFloat(Double(self.currentTimerInterval))
//                        self.progressLabel.text =  self.setProgressLabel(self.currentProgress, self.totalTimers)
                        
                    }else if self.initialTimer.isHidden == true{
                        DispatchQueue.main.async {
                            self.playFinishedSound()
                        }
                        self.isTimerPlayed = false      //把狀況調成false，以期跳出閉包loop
                    }
                }
            })
        }
        else if isTimerPlayed == true
        {
            isTimerPlayed = false
            outletPlayPauseBtm.setTitle("play", for: .normal)
            timer.invalidate()
            timer = nil
        }
                    
    }
    
    //MARK: -自訂函式
    //標示已播放時間和剩餘播放時間
    func countDownTimer(timerMin: String, timerSec: String) -> String
    {
        currentTimerInterval = convertTimeInterval(minText: timerMin, secText: timerSec)
        print(currentTimerInterval)
        if currentTimerInterval > 0
        {
            currentTimerInterval -= 1
        }
        else if currentTimerInterval == 0
        {
            currentTimerInterval = 1
        }
        print(currentTimerInterval)
        return String.timeString(time: currentTimerInterval)
        
    }
    
    private func setNextTimer()
    {
        timerNum += 1
        currentTimerInterval = convertTimeInterval(minText: (timerData[timerNum] as! [String])[2], secText: (timerData[timerNum] as! [String])[3])
        currentTimer.text = String.timeString(time: currentTimerInterval)
        progressRing.value = 0
        progressRing.maxValue = CGFloat(Double(currentTimerInterval))
        progressLabel.text =  setProgressLabel(currentProgress, totalTimers)
    }
    
    func setProgressLabel(_ currentProgress:Int,_ totalTimers: Int) -> String
    {
        return String(format: "%02i/%02i", currentProgress, totalTimers)
    }
    
    func checkTimerShouldKeepRunning(_ currentProgress:Int,_ totalTimers: Int) -> Bool
    {
        return currentProgress <= totalTimers
    }
    
    private func playBeepSound(_ currentTimerInterval: TimeInterval) {
        
        let intervalCase = Int(currentTimerInterval)
        
        switch intervalCase {
        case (2...5):
            do{
                beepPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "beep_second", ofType: "mp3")!))
                beepPlayer.delegate = self
                beepPlayer.play()
            }catch{
                
            }
        default:
            do{
                beepPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "beep_second", ofType: "mp3")!))
                beepPlayer.delegate = self
                beepPlayer.play()
            }catch{
                
            }
        }
    }
    
    private func playFinishedSound() {
        
            do{
                beepPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "beep_finish", ofType: "mp3")!))
                beepPlayer.delegate = self
                beepPlayer.play()
            }catch{
                
            }
    }
    
    private func playSoundByTimerType(_ timerType: String) {
        
        var soundType = "beep_work"
        
        if timerType == "r"
        {
            soundType = "beep_rest"
        }
        do{
            beepPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "\(soundType)", ofType: "mp3")!))
            beepPlayer.delegate = self
            beepPlayer.play()
        }catch{
            
        }
    }

}
