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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 変数の初期化
        inputModeSwitch.setOn(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // SettingViewControllerで保存したUserDefaultの値を取得して、音色のpathを変更する
        // UserDefaultに登録されていない場合はelseに入る
        let settings = UserDefaults.standard
        if let timbre = settings.string(forKey: timbreKey){
            
            switch timbre {
                case "guitar" :
                    paths = [guitarC4Path, guitarD4Path, guitarE4Path, guitarF4Path, guitarG4Path, guitarA4Path, guitarB4Path, guitarC5Path]
                default:
                    paths = [pianoC4Path, pianoD4Path, pianoE4Path, pianoF4Path, pianoG4Path, pianoA4Path, pianoB4Path, pianoC5Path]
            }
            
        } else {
            
            // UserDefaultに保存されていない場合はデフォルトでピアノ
            paths = [pianoC4Path, pianoD4Path, pianoE4Path, pianoF4Path, pianoG4Path, pianoA4Path, pianoB4Path, pianoC5Path]
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // 問題を作成して初回の音を鳴らす
        quizGenerate()
        quizSoundPlay(url: paths[quizArray[quizCurrent]])
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    // AVAudioPlayerのデリゲートメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        quizCurrent += 1
        if quizCurrent > quizNumber - 1 { quizCurrent = 0; return }
        quizSoundPlay(url: paths[quizArray[quizCurrent]])
    }
    
    @objc func updateTimerLabel(){
        timeCount += 1
        let ms = timeCount % 100
        let s = (timeCount - ms) / 100 % 60
        let m = (timeCount - s - ms) / 6000 % 3600
        millisecondLabel.text = String(format: "%02d", ms)
        secondLabel.text = String(format: "%02d", s)
        minuteLabel.text = String(format: "%02d", m)
    }
    
    func resetTimer(){
        timer.invalidate()
        timeCount = 0
        millisecondLabel.text = "00"
        secondLabel.text = "00"
        minuteLabel.text = "00"
    }
    
    let timbreKey = "timbre"
    let rank1 = "rank1"
    let rank2 = "rank2"
    let rank3 = "rank3"
    
    let quizNumber = 5 // 出題する音の個数
    let tones:[String] = ["ド↓","レ","ミ","ファ","ソ","ラ","シ","ド↑"]
    
    var quizArray:[Int] = [] // quizGenerateメソッドで出題する音のインデックスを格納する [4 2 4 5 1] -> [ソ ミ ソ ラ レ]
    var quizCurrent:Int = 0 // quizArrayの何番目が再生中か保持しておく
    var answerCursor:Int = 0
    var paths:[URL] = []
    var mode : Bool = false
    var timer: Timer = Timer()
    var timeCount: Int = 0
    
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
    
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var millisecondLabel: UILabel!
    
    @IBOutlet var labelCollection: [UILabel]! // 回答用ラベルの配列
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
        resetTimer()
        resetAnswer()
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
        resetTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    @IBAction func onCheckButtonTapped(_ sender: UIButton) {
        
        var allCollect = true
        
        for (index, flg) in checkAnswer().enumerated() {
            // 間違えのフラグが立っていたら赤文字で表示、不正解
            if flg == 1 && labelCollection[index].text != "" {
                labelCollection[index].textColor = UIColor.red
                allCollect = false
            }
            // 回答が入力されてなくても不正解
            if labelCollection[index].text == "" {
                allCollect = false
            }
        }
        
        if allCollect {
            do {
                correctPlayer = try AVAudioPlayer(contentsOf: correctPath, fileTypeHint: nil)
                correctPlayer.play()
                timer.invalidate()
                addToRanking()
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
        
        // 回答が入力されていなかったら早期リターン
        if answerCursor == 0 {
            return
        }
        
        labelCollection[answerCursor - 1].text = ""
        backanswerCursor()
    }
    
    @IBAction func onTestButtonTapped(_ sender: UIButton) {
        if !mode {
            return
        }
        resetAnswer()
        for (index, label) in labelCollection.enumerated(){
            label.text = tones[quizArray[index]]
            label.textColor = UIColor.black
        }
    }
    
    
    // 回答のラベルを変更する
    func changeLabel(toneName:String){
        
        if !mode || answerCursor > quizNumber - 1 {
            return
        }
        
        labelCollection[answerCursor].text = toneName
        labelCollection[answerCursor].textColor = UIColor.black
        
    }
    
    // 問題を１音再生する
    func quizSoundPlay(url:URL){
        
        do {
            quizPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
            quizPlayer.delegate = self
            quizPlayer.play()
        } catch {
            print("quizSoundPlayメソッドでエラーが発生しました。")
        }
        
    }
    
    // 回答のカーソルを進める
    func proceedAnswerCursor(){
        if mode && answerCursor < quizNumber {
            answerCursor += 1
        }
    }
    
    // 回答のカーソルを戻す
    func backanswerCursor(){
        if answerCursor > 0 {
            answerCursor -= 1
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
        answerCursor = 0
    }
    
    // 答え合わせをして間違いを渡す、0は正解、1は不正解
    func checkAnswer() -> [Int]{
        
        var result:[Int] = [Int](repeating: 0, count: 5)
        // 出題(quizArray)の音名と回答ラベル(labelCollection)の音名を比較する
        for i in 0..<quizNumber {
            if tones[quizArray[i]] != labelCollection[i].text {
                result[i] = 1
            }
        }
        
        return result
    }
    
    func addToRanking(){
        let settings = UserDefaults.standard
        // 登録されてない場合は0になる
        let rank1 = settings.integer(forKey: self.rank1)
        let rank2 = settings.integer(forKey: self.rank2)
        let rank3 = settings.integer(forKey: self.rank3)

        if(timeCount < rank1 || rank1 == 0){

            settings.setValue(rank1, forKey: self.rank2)
            settings.setValue(rank2, forKey: self.rank3)
            settings.setValue(timeCount, forKey: self.rank1)

        } else if(timeCount < rank2 || rank2 == 0) {

            settings.setValue(rank2, forKey: self.rank3)
            settings.setValue(timeCount, forKey: self.rank2)

        } else if(timeCount < rank3 || rank3 == 0) {

            settings.setValue(timeCount, forKey: self.rank3)

        }
        settings.synchronize()

        //print(String(settings.integer(forKey: self.rank1)) + "," + String(settings.integer(forKey: self.rank2)) + "," + String(settings.integer(forKey: self.rank3)))
        
//        // テスト用
//        let settings = UserDefaults.standard
//        settings.setValue(0, forKey: self.rank1)
//        settings.setValue(0, forKey: self.rank2)
//        settings.setValue(0, forKey: self.rank3)
//        print(settings.integer(forKey: self.rank1))
//        print(settings.integer(forKey: self.rank2))
//        print(settings.integer(forKey: self.rank3))
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
            proceedAnswerCursor()
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
            proceedAnswerCursor()
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
            proceedAnswerCursor()
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
            proceedAnswerCursor()
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
            proceedAnswerCursor()
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
            proceedAnswerCursor()
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
            proceedAnswerCursor()
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
            proceedAnswerCursor()
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
