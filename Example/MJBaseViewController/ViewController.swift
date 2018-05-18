//
//  ViewController.swift
//  MJBaseViewController
//
//  Created by ylpodul@163.com on 02/27/2018.
//  Copyright (c) 2018 ylpodul@163.com. All rights reserved.
//

import UIKit
import MJBaseViewController

class ViewController: UIViewController {
    @IBOutlet weak var sd: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        MJControllerManager.topWindow;
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let namespace = Bundle.main.infoDictionary?[kCFBundleExecutableKey as String] as! String
//        let classVC: AnyClass? = NSClassFromString(namespace + ".MJBaseViewController")
//        print(classVC)
//        MJControllerManager.showShareViewWith(["aaaa"], onView: nil) { (success, str, data) in
//            
//        }
//        MJControllerManager.topWindow
//        let window = UIWindow(frame: view.bounds)
        
//        super.touchesBegan(touches, with: event)
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "TestViewController")
        present(vc, animated: true, completion: nil)
        
//        window.rootViewController = vc
//        window.makeKeyAndVisible()
//        MJControllerManager.mainWindow?.resignKey()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//extension ViewController: KeyboardDelegate {
//    func keyboardWillShow(_ notification: Notification) {
//        
//    }
//    
//    func keyboardWillHide(_ notification: Notification) {
//        
//    }
//    
//    
//}



