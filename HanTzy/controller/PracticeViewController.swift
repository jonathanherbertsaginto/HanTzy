//
//  PracticeViewController.swift
//  HanTzy
//
//  Created by Jonathan Herbert on 02/05/21.
//

import UIKit
import PencilKit

class PracticeViewController: UIViewController {
    
    var hanzi = [hanziData]()
    @IBOutlet weak var practiceNavBar: UINavigationItem!
    @IBOutlet weak var hanziName: UILabel!
    @IBOutlet weak var canvasView: PKCanvasView!
    
    var drawing = PKDrawing()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiUpdate()
        navBarUpdate()
        // Do any additional setup after loading the view.
    }
    func uiUpdate(){
        hanziName.text = hanzi[0].hanziName
        hanziName.font = UIFont.boldSystemFont(ofSize: 30)
        
        if #available(iOS 14.0, *) {
            // Both finger and pencil are always allowed on this canvas.
            canvasView.drawingPolicy = .anyInput
        }
        if self.traitCollection.userInterfaceStyle == .light{
            canvasView.tool = PKInkingTool(.marker,color: .black, width: 20)
        }else{
            canvasView.tool = PKInkingTool(.marker,color: .white, width: 20)
        }
        canvasView.drawing = drawing
        canvasView.backgroundColor = UIColor(patternImage: UIImage(named: hanzi[0].gifLocation)!)
        canvasView.layer.borderWidth = 4
        canvasView.becomeFirstResponder()
    }
    
    func navBarUpdate(){
        practiceNavBar.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(finishButton(sender:)))
    }
    
    @objc func finishButton(sender: AnyObject) {
        if canvasView.drawing.strokes.count==0 {
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Finish Drawing", message: "you have not drawn anything, are you sure to finish it now ?", preferredStyle: .alert)
            let quitActionButton = UIAlertAction(title: "Finish", style: .destructive) { [self]_ in
                finishButton()
            }
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            }
            actionSheetControllerIOS8.addAction(quitActionButton)
            actionSheetControllerIOS8.addAction(cancelActionButton)
               
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }else{
            finishButton()
        }
    }
    
    func finishButton() {
        performSegue(withIdentifier: "scoreSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ScoreViewController
        vc.drawingImg = canvasView.drawing.image(from:  self.canvasView.bounds, scale: 1.0)
        vc.strokes = canvasView.drawing.strokes.count
        vc.hanzi = hanzi
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
