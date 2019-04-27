//
//  ResultViewController.swift
//  ToneGuess
//
//  Created by main on 2019/04/23.
//  Copyright © 2019年 soramaho. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRanking()
        // Do any additional setup after loading the view.
    }
    
    func loadRanking(){
        let settings = UserDefaults.standard
        
        let rank1 = settings.integer(forKey: self.rank1)
        let rank2 = settings.integer(forKey: self.rank2)
        let rank3 = settings.integer(forKey: self.rank3)
        
        let rank1Str = timeFormat(timeCount: rank1)
        let rank2Str = timeFormat(timeCount: rank2)
        let rank3Str = timeFormat(timeCount: rank3)
        
        rank1Label.text = rank1Str
        rank2Label.text = rank2Str
        rank3Label.text = rank3Str
    }
    
    let rank1 = "rank1"
    let rank2 = "rank2"
    let rank3 = "rank3"
    
    @IBOutlet weak var rank1Label: UILabel!
    @IBOutlet weak var rank2Label: UILabel!
    @IBOutlet weak var rank3Label: UILabel!
    
    
    @IBAction func onResetButtonTapped(_ sender: UIButton) {
        let settings = UserDefaults.standard
        settings.setValue(0, forKey: rank1)
        settings.setValue(0, forKey: rank2)
        settings.setValue(0, forKey: rank3)
        settings.synchronize()
        loadRanking()
    }
    
    func timeFormat(timeCount: Int) -> String {
        if(timeCount == 0){
            return "00:00.00"
        }
        let ms = timeCount % 100
        let s = (timeCount - ms) / 100 % 60
        let m = (timeCount - s - ms) / 6000 % 3600
        return String(format: "%02d:%02d.%02d", m,s,ms)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
