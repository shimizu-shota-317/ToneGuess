//
//  MainViewController.swift
//  ToneGuess
//
//  Created by main on 2019/03/20.
//  Copyright © 2019年 soramaho. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVAudioPlayerDelegate {
    
    // SettingViewControllerから戻ってきた時には呼ばれない
    override func viewDidLoad() {
        super.viewDidLoad()
        // 変数の初期化
        inputModeSwitch.setOn(false, animated: false)
    }
    
    // SettingViewControllerから戻ってきた時にも呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // SettingViewControllerで保存したUserDefaultの値を取得して、音色のpathを変更する
        // UserDefaultに登録されていない場合はelseに入る
        let settings = UserDefaults.standard
        if let timbre = settings.string(forKey: timbreKey){
            
            if timbre == "guitar" {
                print(timbre)
                paths = [guitarC4Path, guitarD4Path, guitarE4Path, guitarF4Path, guitarG4Path, guitarA4Path, guitarB4Path, guitarC5Path]
                
            } else {
                
                paths = [pianoC4Path, pianoD4Path, pianoE4Path, pianoF4Path, pianoG4Path, pianoA4Path, pianoB4Path, pianoC5Path]
                
            }
            
        } else {
            
            paths = [pianoC4Path, pianoD4Path, pianoE4Path, pianoF4Path, pianoG4Path, pianoA4Path, pianoB4Path, pianoC5Path]
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        quizGenerate()
        quizSoundPlay(url: paths[quizArray[quizCurrent]])
    }
    
    // AVAudioPlayerのデリゲートメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        quizCurrent += 1
        if quizCurrent > quizNumber - 1 { quizCurrent = 0; return }
        quizSoundPlay(url: paths[quizArray[quizCurrent]])
    }
    
    let timbreKey:String = "timbre"
    let quizNumber:Int = 5
    var quizArray:[Int] = [0, 1, 2, 3, 4]
    var quizCurrent:Int = 0
    var answeredPosition:Int = 0
    let tones:[String] = ["ド↓","レ","ミ","ファ","ソ","ラ","シ","ド↑"]
    var paths:[URL] = []
    var mode : Bool = false
    
    let correctPath = Bundle.main.bundleURL.appendingPathComponent("correct.mp3")
    let incorrectPath = Bundle.main.bundleURL.appendingPathComponent("incorrect.mp3")
    
    let pianoC4Path = Bundle.main.bundleURL.appendingPathComponent("C4-piano.wav")
    let pianoD4Path = Bundle.main.bundleURL.appendingPathComponent("D4-piano.wav")
    let pianoE4Path = Bundle.main.bundleURL.appendingPathComponent("E4-piano.wav")
    let pianoF4Path = Bundle.main.bundleURL.appendingPathComponent("F4-piano.wav")
    let pianoG4Path = Bundle.main.bundleURL.appendingPathComponent("G4-piano.wav")
    let pianoA4Path = Bundle.main.bundleURL.appendingPathComponent("A4-piano.wav")
    let pianoB4Path = Bundle.main.bundleURL.appendingPathComponent("B4-piano.wav")
    let pianoC5Path = Bundle.main.bundleURL.appendingPathComponent("C5-piano.wav")
    
    let guitarC4Path = Bundle.main.bundleURL.appendingPathComponent("C4-guitar.wav")
    let guitarD4Path = Bundle.main.bundleURL.appendingPathComponent("D4-guitar.wav")
    let guitarE4Path = Bundle.main.bundleURL.appendingPathComponent("E4-guitar.wav")
    let guitarF4Path = Bundle.main.bundleURL.appendingPathComponent("F4-guitar.wav")
    let guitarG4Path = Bundle.main.bundleURL.appendingPathComponent("G4-guitar.wav")
    let guitarA4Path = Bundle.main.bundleURL.appendingPathComponent("A4-guitar.wav")
    let guitarB4Path = Bundle.main.bundleURL.appendingPathComponent("B4-guitar.wav")
    let guitarC5Path = Bundle.main.bundleURL.appendingPathComponent("C5-guitar.wav")
    
    var quizPlayer = AVAudioPlayer()
    var correctPlayer = AVAudioPlayer()
    var incorrectPlayer = AVAudioPlayer()
    var C4Player = AVAudioPlayer()
    var D4Player = AVAudioPlayer()
    var E4Player = AVAudioPlayer()
    var F4Player = AVAudioPlayer()
    var G4Player = AVAudioPlayer()
    var A4Player = AVAudioPlayer()
    var B4Player = AVAudioPlayer()
    var C5Player = AVAudioPlayer()
    
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet weak var inputModeSwitch: UISwitch!
    
    @IBOutlet weak var C4Tone: UIButton!
    @IBOutlet weak var D4Tone: UIButton!
    @IBOutlet weak var E4Tone: UIButton!
    @IBOutlet weak var F4Tone: UIButton!
    @IBOutlet weak var G4Tone: UIButton!
    @IBOutlet weak var A4Tone: UIButton!
    @IBOutlet weak var B4Tone: UIButton!
    @IBOutlet weak var C5Tone: UIButton!
    
    @IBAction func onSettingButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoSettingVC", sender: nil)
    }
    
    @IBAction func onSoundButtonTapped(_ sender: UIButton) {
        quizCurrent = 0
        quizSoundPlay(url: paths[quizArray[quizCurrent]])
    }
    
    @IBAction func onNextButtonTapped(_ sender: UIButton) {
        quizCurrent = 0
        quizGenerate()
        quizSoundPlay(url: paths[quizArray[quizCurrent]])
        resetAnswer()
    }
    
    @IBAction func onCheckButtonTapped(_ sender: UIButton) {
        var allCollect = true
        for (index, flg) in checkAnswer().enumerated() {
            if flg == 1 && labelCollection[index].text != "" {
                labelCollection[index].textColor = UIColor.red
                allCollect = false
            }
            if labelCollection[index].text == "" {
                allCollect = false
            }
        }
        if allCollect {
            do {
                correctPlayer = try AVAudioPlayer(contentsOf: correctPath, fileTypeHint: nil)
                correctPlayer.play()
            } catch {
                print("正解音でエラーが発生しました。")
            }
        } else {
            do {
                incorrectPlayer = try AVAudioPlayer(contentsOf: incorrectPath, fileTypeHint: nil)
                incorrectPlayer.play()
            } catch {
                print("不正解音でエラーが発生しました。")
            }
        }
    }
    
    @IBAction func onInputModeChange(_ sender: Any) {
        mode = !mode
    }
    
    @IBAction func onCancelButtonTapped(_ sender: UIButton) {
        
        if answeredPosition == 0 {
            return
        }
        
        labelCollection[answeredPosition - 1].text = ""
        labelCollection[answeredPosition - 1].textColor = UIColor.black
        backAnsweredPosition()
    }
    
    // 回答のラベルを変更する
    func changeLabel(toneName:String){
        
        if answeredPosition > quizNumber - 1 {
            return
        }
        
        if mode {
            labelCollection[answeredPosition].text = toneName
        }
        
    }
    
    // 問題を１音、再生する
    func quizSoundPlay(url:URL){
        
        do {
            quizPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
            quizPlayer.delegate = self
            quizPlayer.play()
        } catch {
            print("テストサウンドでエラーが発生しました。")
        }
        
    }
    
    // 回答済みのカウントを進める
    func proceedAnswerdPosition(){
        if mode && answeredPosition < quizNumber {
            answeredPosition += 1
        }
    }
    
    // 回答済みのカウントを戻す
    func backAnsweredPosition(){
        if answeredPosition > 0 {
            answeredPosition -= 1
        }
    }
    
    // 問題をランダムに生成する
    func quizGenerate(){
        let array:[Int] = [
            Int.random(in: 0 ... 7),
            Int.random(in: 0 ... 7),
            Int.random(in: 0 ... 7),
            Int.random(in: 0 ... 7),
            Int.random(in: 0 ... 7),
        ]
        quizArray = array
    }
    
    // 回答をリセットする、文字色を黒に戻す
    func resetAnswer(){
        for label in labelCollection {
            label.text = ""
            label.textColor = UIColor.black
        }
        answeredPosition = 0
    }
    
    // 答え合わせをして間違いを渡す、0は正解、1は不正解
    func checkAnswer() -> [Int]{
        // quizArrayの表す音名とlabelCollectionの音名を比較する
        var result:[Int] = [Int](repeating: 0, count: 5)
        print(result)
        for i in 0..<quizNumber {
            if tones[quizArray[i]] != labelCollection[i].text {
                result[i] = 1
            }
        }
        
        return result
    }
    
    
    /********************
     鍵盤ボタンのアクション
    ********************/
    
    // ド
    @IBAction func onC4ButtonTapped(_ sender: UIButton) {
        do {
            C4Player = try AVAudioPlayer(contentsOf: paths[0], fileTypeHint: nil)
            C4Player.play()
            changeLabel(toneName:tones[0])
            proceedAnswerdPosition()
        } catch {
            print("C4でエラーが発生しました。")
        }
    }
    
    // レ
    @IBAction func onD4ButtonTapped(_ sender: UIButton) {
        do {
            D4Player = try AVAudioPlayer(contentsOf: paths[1], fileTypeHint: nil)
            D4Player.play()
            changeLabel(toneName:tones[1])
            proceedAnswerdPosition()
        } catch {
            print("D4でエラーが発生しました。")
        }
    }
    
    // ミ
    @IBAction func onE4ButtonTapped(_ sender: UIButton) {
        do {
            E4Player = try AVAudioPlayer(contentsOf: paths[2], fileTypeHint: nil)
            E4Player.play()
            changeLabel(toneName:tones[2])
            proceedAnswerdPosition()
        } catch {
            print("E4でエラーが発生しました。")
        }
    }
    
    // ファ
    @IBAction func onF4ButtonTapped(_ sender: UIButton) {
        do {
            F4Player = try AVAudioPlayer(contentsOf: paths[3], fileTypeHint: nil)
            F4Player.play()
            changeLabel(toneName:tones[3])
            proceedAnswerdPosition()
        } catch {
            print("F4でエラーが発生しました。")
        }
    }
    
    // ソ
    @IBAction func onG4ButtonTapped(_ sender: UIButton) {
        do {
            G4Player = try AVAudioPlayer(contentsOf: paths[4], fileTypeHint: nil)
            G4Player.play()
            changeLabel(toneName:tones[4])
            proceedAnswerdPosition()
        } catch {
            print("G4でエラーが発生しました。")
        }
    }
    
    // ラ
    @IBAction func onA4ButtonTapped(_ sender: UIButton) {
        do {
            A4Player = try AVAudioPlayer(contentsOf: paths[5], fileTypeHint: nil)
            A4Player.play()
            changeLabel(toneName:tones[5])
            proceedAnswerdPosition()
        } catch {
            print("A4でエラーが発生しました。")
        }
    }
    
    // シ
    @IBAction func onB4BuutonTapped(_ sender: UIButton) {
        do {
            B4Player = try AVAudioPlayer(contentsOf: paths[6], fileTypeHint: nil)
            B4Player.play()
            changeLabel(toneName:tones[6])
            proceedAnswerdPosition()
        } catch {
            print("B4でエラーが発生しました。")
        }
    }
    
    // ド
    @IBAction func onC5ButtonTapped(_ sender: UIButton) {
        do {
            C5Player = try AVAudioPlayer(contentsOf: paths[7], fileTypeHint: nil)
            C5Player.play()
            changeLabel(toneName:tones[7])
            proceedAnswerdPosition()
        } catch {
            print("C5でエラーが発生しました。")
        }
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
