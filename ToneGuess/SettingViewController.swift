//
//  SettingViewController.swift
//  ToneGuess
//
//  Created by main on 2019/03/20.
//  Copyright © 2019年 soramaho. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let timbreKey:String = "timbre"
    let timbres:[String] = ["piano", "guitar"]
    
    @IBOutlet weak var timbrePicker: UIPickerView!
    
    // pickerの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // pickerの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timbres.count
    }
    
    // 表示する文字列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timbres[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let settings = UserDefaults.standard
        settings.setValue(timbres[row], forKey: timbreKey)
        settings.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timbrePicker.delegate = self
        timbrePicker.dataSource = self
        
        let settings = UserDefaults.standard
        let timbre = settings.string(forKey: timbreKey)
        
        for (index, row) in timbres.enumerated() {
            if row == timbre {
                timbrePicker.selectRow(index, inComponent: 0, animated: true)
            }
        }

        // Do any additional setup after loading the view.
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
