//
//  0_LoginViewController.swift
//  ARYIMBY
//
//  Created by Wenhao Wu on 3/18/23.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openAboutSite(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/wenhaowuuu/ARYIMBY"){
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func exitApp(_ sender: UIButton) {
        exit(0)
//        self.dismiss(animated: true, completion: nil)
    }

}
