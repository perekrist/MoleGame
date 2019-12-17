//
//  ViewController.swift
//  SimpleApp
//
//  Created by Перегудова Кристина on 16/12/2019.
//  Copyright © 2019 perekrist. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var screenHeight = UIScreen.main.bounds.height,
    screenWidth = UIScreen.main.bounds.width
    
    var audioPlayer = AVAudioPlayer()
    var soundPlayer = AVAudioPlayer()

    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var best: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    var score = 0
    var bestScore = 0
    var seconds = 10
    var time = Timer()
    var moleTime = Timer()
    var isTimerRunning = false
    var a = 4
    var b = 3
    var timeInt = 1.0
    var index = 1
    var mole = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let song = Bundle.main.path(forResource: "song", ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: song!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
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
            let alert = UIAlertController(title: "Time over", message: "Your score \(score) pts.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: {action in
                self.restart()
                }))
            self.present(alert, animated: true, completion: nil)
            time.invalidate()
        }
        timer.text = "Seconds: \(seconds)"
        if score < 0 {
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
    }
    
    @objc func buttonClicked(sender : UIButton){
        var sound = Bundle.main.path(forResource: "good", ofType: "mp3")
        if sender.tag == mole {
            score += 1
            sender.setImage(UIImage(named: "boxC")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            sound = Bundle.main.path(forResource: "bad", ofType: "mp3")
            score -= 1
        }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            soundPlayer.play()
        } catch {
            print(error)
        }
        points.text = "Score: \(score) pts."
    }
        
    func restart() {
        time.invalidate()
        moleTime.invalidate()
        if score > bestScore {
            bestScore = score
        }
        score = 0
        points.text = "Score: \(self.score) pts."
        seconds = 10
        timer.text = "Seconds: \(self.seconds)"
        best.text = "Best: \(bestScore) pts."
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
