//
//  TutorialViewController.swift
//  HanTzy
//
//  Created by Jonathan Herbert on 02/05/21.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var tutorialNavBar: UINavigationItem!
    @IBOutlet weak var hanziName: UILabel!
    let gifView = UIImageView.init()
    
    let hanzi = [
        hanziData(gifLocation: "要", hanziName: "yào", hanziMeaning: "want", hanziCode: 3205, hanziStrokes: 9),
        hanziData(gifLocation: "回", hanziName: "huí", hanziMeaning: "return", hanziCode: 1089, hanziStrokes: 6),
        hanziData(gifLocation: "这", hanziName: "zhè", hanziMeaning: "this", hanziCode: 3543, hanziStrokes: 7),
        hanziData(gifLocation: "非", hanziName: "fēi", hanziMeaning: "not",hanziCode: 696, hanziStrokes: 8),
        hanziData(gifLocation: "时", hanziName: "shí", hanziMeaning: "time",hanziCode: 2460, hanziStrokes: 7)
    ]
    var number: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        number = Int.random(in: 1...5) - 1
        uiUpdate(index: Int(number))
        navBarUpdate()
        // Do any additional setup after loading the view.
    }
    
    func navBarUpdate(){
        tutorialNavBar.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(quitButton(sender:)))
        tutorialNavBar.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButton(sender:)))
    }
    
    func uiUpdate(index : Int){
        gifView.loadGif(name: hanzi[index].gifLocation)
        gifView.layer.borderWidth = 4
        gifView.frame = CGRect(x: 0 , y: 0,width:300,height:300)
        gifView.center = view.center
        view.addSubview(gifView)
        
        hanziName.text = hanzi[index].hanziName
        hanziName.font = UIFont.boldSystemFont(ofSize: 30)
    }
    @objc func quitButton(sender: AnyObject) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Quit Practice", message: "your practice just start, do you want to abandon the hanzi practice ?", preferredStyle: .alert)
        let quitActionButton = UIAlertAction(title: "Quit", style: .destructive) {_ in
            self.navigationController?.popViewController(animated: true)
        }
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        actionSheetControllerIOS8.addAction(quitActionButton)
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    @objc func nextButton(sender: AnyObject) {
        performSegue(withIdentifier: "practiceSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PracticeViewController
        vc.hanzi = [hanzi[Int(number)]]
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

