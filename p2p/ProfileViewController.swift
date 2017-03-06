//
//  ProfileViewController.swift
//  p2p
//
//  Created by 竹内将大 on 2017/03/07.
//  Copyright © 2017年 nakarinrin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameText.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendButton.sendActions(for: .touchUpInside)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showVC"{
            guard self.nameText.text != "" else{
                let alertController = UIAlertController(title: "ウップス！", message: "なまえをかこう！", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            return true
        }
        return true
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else{
            return
        }
        if identifier == "showVC"{
            let VC = segue.destination as! ViewController
            VC.myName = self.nameText.text!
        }
    }
    
    @IBAction func selectGender(for segue:UIStoryboardSegue, sender: UISegmentedControl){
        guard let identifier = segue.identifier else{
            return
        }
        if identifier == "showVC"{
            let VC = segue.destination as! ViewController
            VC.myGender = sender.selectedSegmentIndex
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
