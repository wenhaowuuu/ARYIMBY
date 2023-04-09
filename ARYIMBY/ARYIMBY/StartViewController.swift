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
