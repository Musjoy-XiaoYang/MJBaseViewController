//
//  TestViewController.swift
//  MJBaseViewController_Example
//
//  Created by Podul on 2018/3/6.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import MJBaseViewController

class TestViewController: MJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
//        MJBaseViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(MJControllerManager.topViewController)
        view.endEditing(true)
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
//
//extension TestViewController: KeyboardDelegate {
//    func keyboardWillShow(_ notification: Notification) {
//        print(notification)
//    }
//    
//    func keyboardWillHide(_ notification: Notification) {
//        print(notification)
//    }
//    
//    
//}

