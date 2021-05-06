//
//  ScoreViewController.swift
//  HanTzy
//
//  Created by Jonathan Herbert on 03/05/21.
//

import UIKit
import CoreML
import SAConfettiView

class ScoreViewController: UIViewController {

    @IBOutlet weak var scoreNavBar: UINavigationItem!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var hanziName: UILabel!
    @IBOutlet weak var hanziMeaning: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var yourfinalscore: UILabel!
    @IBOutlet weak var strokesLabel: UILabel!
    @IBOutlet weak var motivationLabel: UILabel!
    
    
    var drawingImg = UIImage()
    var strokes = Int()
    var hanzi = [hanziData]()
    
    var motivation = [
        "An investment in education pays the best interest.",
        "Anyone who stops learning is old, whether at twenty or eighty.",
        "If you're determined to learn, no one can stop you.",
        "Never discourage anyone who continually makes progress, no matter how slow.",
        "You can get help from teachers, but you're going to have to learn a lot by yourself, sitting alone in a room."
    ]
    
    let function = imagePreprocess()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiUpdate()
        // Do any additional setup after loading the view.
    }
    
    func uiUpdate(){
        navBarUpdate()
        img.image = drawingImg
        img.backgroundColor = .clear
        img.frame = CGRect(x: 0 , y: 0,width:200,height:200)
        view.addSubview(img)
        
        yourfinalscore.font = UIFont.boldSystemFont(ofSize: 25)
        
        hanziName.text = hanzi[0].hanziName
        hanziName.font = UIFont.boldSystemFont(ofSize: 17)
        
        hanziMeaning.text = hanzi[0].hanziMeaning
        hanziMeaning.font = UIFont.boldSystemFont(ofSize: 17)
        
        strokesLabel.text = String(strokes) + "/" + String(hanzi[0].hanziStrokes)
        strokesLabel.font = UIFont.boldSystemFont(ofSize: 17)

        let acc = Int(function.predict(image: drawingImg, index: hanzi[0].hanziCode) * 100)
        var finalscore = acc - (abs(strokes - hanzi[0].hanziStrokes) * 5)
        if finalscore < 0 {
            finalscore = 0
        }
        
        resultLabel.font = UIFont.boldSystemFont(ofSize: 50)
        resultLabel.text = String(finalscore)
        
        let confetti = SAConfettiView(frame: self.view.bounds)
        confetti.type = .Confetti
        confetti.intensity = 0.5
        confetti.startConfetti()
        view.addSubview(confetti)
        
        motivationLabel.sizeToFit()
        motivationLabel.numberOfLines = 3
        motivationLabel.adjustsFontSizeToFitWidth = true
        motivationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        motivationLabel.text = motivation[Int.random(in: 1...5)-1]
        
    }
    
    func navBarUpdate(){
        scoreNavBar.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(quitButton(sender:)))
    }
    
    @objc func quitButton(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
