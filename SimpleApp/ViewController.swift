//
//  ViewController.swift
//  SimpleApp
//
//  Created by Перегудова Кристина on 16/12/2019.
//  Copyright © 2019 perekrist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    var pts = 0
    var seconds = 60
    var time = Timer()
    var isTimerRunning = false

    @IBOutlet weak var start: NSLayoutConstraint!
    @IBAction func StartBtn(_ sender: Any) {
        runTimer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func runTimer() {
         time = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        if seconds <= 0 {
            seconds = 0
        }
        timer.text = "\(seconds)"
    }


}

