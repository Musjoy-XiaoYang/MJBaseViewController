//
//  BaseViewController.swift
//  MJBaseViewController_Example
//
//  Created by Podul on 2018/5/21.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import MJBaseViewController

class BaseViewController: MJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        
//        let textField = UITextField(frame: CGRect(x: 10, y: 50, width: 100, height: 44))
//        textField.center = view.center
//        textField.backgroundColor = .white
//        view.addSubview(textField)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
//        MJControllerManager.topWindow?.resignKey()
        
        window.makeKeyAndVisible()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss(animated: true, completion: nil)
    }
    
//    func address(o: UnsafeRawPointer) -> String {
//        return String.init(format: "%018p", Int(bitPattern: o))
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
