//
//  ViewController.swift
//  SumikkoPairing
//
//  Created by Chang Sophia on 2/18/20.
//  Copyright © 2020 Chang Sophia. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var sumikkoButtons: [UIButton]!
    @IBOutlet weak var movesMade: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    var count = 0
    var sumikkos = [Sumikko]()
    var selectedSumikkos = [Int]()
    var moves = 0
    var pairsFound = 0
    var time: Timer?
    var seconds = 60
    var isPlaying = false
    var stopTapped = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
         gameInit()
    }

    struct Sumikko {
        var name: String?
        var image: UIImage?
        var isFlipped: Bool = false
        var isAlive: Bool = true
        var timeoutHolding = false
    }

    func gameInit() -> Void {
        sumikkos.removeAll()
        sumikkos = [
            Sumikko(name: "bear", image: UIImage(named: "bear")),
              Sumikko(name: "cat", image: UIImage(named: "cat")),
               Sumikko(name: "penguin", image: UIImage(named: "penguin")),
               Sumikko(name: "dino", image: UIImage(named: "dino")),
               Sumikko(name: "pork", image: UIImage(named: "pork")),
                Sumikko(name: "shrimp", image: UIImage(named: "shrimp")),
        Sumikko(name: "bear", image: UIImage(named: "bear")),
        Sumikko(name: "cat", image: UIImage(named: "cat")),
         Sumikko(name: "penguin", image: UIImage(named: "penguin")),
         Sumikko(name: "dino", image: UIImage(named: "dino")),
         Sumikko(name: "pork", image: UIImage(named: "pork")),
          Sumikko(name: "shrimp", image: UIImage(named: "shrimp"))]
        sumikkos.shuffle()
        selectedSumikkos.removeAll()
        moves = 0
        displaySumikkos()
        
}
    //翻牌看是否相同
    func disableSumikko(index: Int) -> Void {
        sumikkos[index].isAlive = false
        sumikkoButtons[index].alpha = 0.4
        UIView.transition(with: sumikkoButtons[index], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
    }
    
    //展示牌
    func displaySumikkos() ->Void {
        
        for (i,_) in sumikkoButtons.enumerated() {
            if sumikkos[i].isAlive == true {
                if sumikkos[i].isFlipped == true {
                    sumikkoButtons[i].setImage(sumikkos[i].image, for:.normal)
                }else{
                    sumikkoButtons[i].setImage(UIImage(named: "Sumikko"), for: .normal)
                }
            }else {
                sumikkoButtons[i].setImage(sumikkos[i].image, for: .normal)
                sumikkoButtons[i].alpha = 0.4
                    
                }
            }
        }

//翻牌動作
    @IBAction func flipSumikko(_ sender: UIButton) {
        
        func flipSumikkoIndex(index: Int) ->Void {
            if sumikkos[index].isFlipped == true {
        sumikkoButtons[index].setImage(UIImage(named:"Sumikko"), for: .normal)
                UIView.transition(with: sumikkoButtons[index], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
                sumikkos[index].isFlipped = false
                
            } else {
                sumikkoButtons[index].setImage(sumikkos[index].image, for: .normal)
                UIView.transition(with: sumikkoButtons[index], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                sumikkos[index].isFlipped = true
            }
            
        }
        if time == nil {
           time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.UpdateTimer), userInfo: nil, repeats: true)
        }
        if let sumikkoIndex = sumikkoButtons.firstIndex(of: sender) {
            if sumikkos[sumikkoIndex].isAlive == false {
                return
            }
            if selectedSumikkos.count == 0 {
            selectedSumikkos.append(sumikkoIndex)
            flipSumikkoIndex(index: sumikkoIndex)
            } else if selectedSumikkos.count == 1 {
                moves += 1
                movesMade.text = String(moves)
                if selectedSumikkos.contains(sumikkoIndex) {
                    flipSumikkoIndex(index: sumikkoIndex)
                        selectedSumikkos.removeAll()
                } else {
                    selectedSumikkos.append(sumikkoIndex)
                    flipSumikkoIndex(index: sumikkoIndex)
                   
                    if sumikkos[selectedSumikkos[0]].name == sumikkos[selectedSumikkos[1]].name {
                        
                        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (_) in
                            for (_,num) in
                                self.selectedSumikkos.enumerated() {
                                    self.disableSumikko(index: num)
                            }
                            self.selectedSumikkos.removeAll()
                            self.pairsFound += 1
                            if self.pairsFound == 6 {
                                self.time?.invalidate()
                                //在時間內完成，跳出Alert, press "OK" to restart
                                let controller =
                                    UIAlertController(title: "挑戰成功", message: "再來一場!!", preferredStyle: .alert)
                                let okAction =  UIAlertAction(title: "OK", style: .default) { _ in
                                self.restartAction()
                                }
                                controller.addAction(okAction)
                                //在時間內結束時間也會暫停
                                self.present(controller, animated: true, completion: nil)
                                print("game over")
                            }
                        }
                    }else{
                        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) {
                            (_) in for (_,num) in
                                self.selectedSumikkos.enumerated(){
                                    flipSumikkoIndex(index: num)
                            }
                            self.selectedSumikkos.removeAll()
                        }
                    }
                }
                
            }
    }
    }
    //未在時間內完成遊戲，而會跳出警告訊息，按下ok則會重新開始
        @objc func UpdateTimer() {
            seconds = seconds - 1
            if seconds == 0 {
                time?.invalidate()
                time = nil
                isPlaying = false
                let controller = UIAlertController(title: "挑戰失敗", message: "回家練練再來吧！", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in self.restartAction()
                }
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
            }
            timeLabel.text = String(seconds)
        }
        
    //重新開始
    
    @IBAction func restart(_ sender: Any) {
        restartAction()
    }
    
        func restartAction() {
            gameInit()
            movesMade.text = String(moves)
            pairsFound = 0
            seconds = 0
            isPlaying = false
            time?.invalidate()
            time = nil
            timeLabel.text = String(seconds)
            for (i, _) in sumikkoButtons.enumerated() {
                sumikkoButtons[i].alpha = 1
            }
            
        }
        
}

