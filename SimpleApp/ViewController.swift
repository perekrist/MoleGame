//
//  ViewController.swift
//  SimpleApp
//
//  Created by Перегудова Кристина on 16/12/2019.
//  Copyright © 2019 perekrist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var screenHeight = UIScreen.main.bounds.height,
    screenWidth = UIScreen.main.bounds.width

    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    var pts = 0
    var seconds = 10
    var time = Timer()
    var moleTime = Timer()
    var isTimerRunning = false
    var a = 4
    var b = 3
    var timeInt = 1.0
    var index = 1
    var mole = 0
    @IBAction func StartBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Set configurations", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "1 - easy, 2 - medium, 3 - hard"
            textField.keyboardType = UIKeyboardType.numberPad
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if alert.textFields?.first?.text == "1" {
                self.a = 3
                self.b = 2
                self.timeInt = 1.3
            } else  if alert.textFields?.first?.text == "2" {
                self.a = 4
                self.b = 3
                self.timeInt = 1.0
            } else {
                self.a = 5
                self.b = 4
                self.timeInt = 0.7
            }
            self.restart()
        }))
        self.present(alert, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func runTimer() {
         time = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func runMoleTimer() {
         moleTime = Timer.scheduledTimer(timeInterval: timeInt, target: self,   selector: (#selector(ViewController.randMole)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        if seconds <= 0 {
            seconds = 0
            moleTime.invalidate()
            let alert = UIAlertController(title: "Time over", message: "Your score \(pts) pts.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: {action in
                self.restart()
                }))
            self.present(alert, animated: true, completion: nil)
            time.invalidate()
        }
        timer.text = "\(seconds)"
        if pts < 0 {
            moleTime.invalidate()
            time.invalidate()
            let alert = UIAlertController(title: "Game over", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: {action in
                self.restart()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func drawHoles() {
        let padding = 20
        let pX = 100
        let pY = 70
        for i in 0..<a {
            for j in 0..<b {
                let buttonWidth = (Int(screenWidth) - pX) / a - padding
                let buttonHeight = (Int(screenHeight) - pY) / b - padding
                let buttonX = i * (buttonWidth + padding) + pX / 2
                let buttonY = j * (buttonHeight + padding) + pY
                
                let button = UIButton(type: .system)
                button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
                button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
                button.tintColor = .white
                button.tag = index
                index += 1
                button.setImage(UIImage(named: "boxC")?.withRenderingMode(.alwaysOriginal), for: .normal)
                self.view.addSubview(button)
            }
        }
    }
    
    @objc func randMole() {
        closeAllBoxes()
        let r = Int.random(in: 1...index)
        mole = r
        let hole = self.view.viewWithTag(r) as? UIButton
        hole?.setImage(UIImage(named: "boxO")?.withRenderingMode(.alwaysOriginal), for: .normal)
        hole?.setTitle(" ", for: .normal)
    }
    
    @objc func buttonClicked(sender : UIButton){
        if sender.tag == mole {
            pts += 1
            sender.setImage(UIImage(named: "boxC")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            pts -= 1
        }
        points.text = "\(pts) pts."
    }
        
    func restart() {
        time.invalidate()
        moleTime.invalidate()
        pts = 0
        points.text = "\(self.pts) pts."
        seconds = 60
        timer.text = "\(self.seconds)"
        runTimer()
        runMoleTimer()
        for i in 1...index {
            let button = self.view.viewWithTag(i) as? UIButton
            button?.removeFromSuperview()
        }
        index = 1
        drawHoles()
    }
    
    func closeAllBoxes() {
        for i in 1...index {
            let button = self.view.viewWithTag(i) as? UIButton
            button?.setImage(UIImage(named: "boxC")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
}
