//
//  MainMenuController.swift
//  HanTzy
//
//  Created by Jonathan Herbert on 30/04/21.
//

import UIKit

class MainMenuController: UIViewController {

    @IBOutlet weak var practiceButton: UIButton!
    
    @IBOutlet weak var menuTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTitle.font = UIFont.boldSystemFont(ofSize: 20)
        practiceButtonUpdate()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    func practiceButtonUpdate(){
        practiceButton.layer.cornerRadius = 20
        practiceButton.layer.borderColor = UIColor.black.cgColor
        practiceButton.layer.borderWidth = 4
        practiceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 44)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
