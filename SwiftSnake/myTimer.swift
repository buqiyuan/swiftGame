//
//  myTimer.swift
//  SwiftSnake
//
//  Created by bqy on 2019/6/19.
//

import Foundation

class myTimer {
    var calcTimer:Timer?
    var totalLife = 0
    var totalTimes = 30
    let userDefault = UserDefaults.standard
    
    @objc func timerIntervalx() {
        if totalTimes <= 0 {
            totalTimes = 30
            totalLife += 1
            self.saveHeart(heart: totalLife)
        }
        totalTimes -= 1;
        //        heartTotal?.text = "💖\(totalLife) \(totalTimes)s"
    }
    func timeStart() {
        if !(self.calcTimer != nil) {
            self.calcTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerIntervalx), userInfo: nil, repeats: true)
        }
    }
    func saveGrade(grade:Int) -> Void{
        userDefault.set(grade, forKey: "grade")
    }
    func saveHeart(heart:Int){
        userDefault.set(heart, forKey: "heart")
    }
    func getGrade() -> Int {
        let value = userDefault.integer(forKey: "grade")
        return value
    }
    func getHeart() -> Int{
        let value = userDefault.integer(forKey: "heart")
        return value
    }
}
