//
//  QuizTopicsViewController.swift
//  ARYIMBY
//
//  Created by Wenhao Wu on 4/29/23.
//

import UIKit

class QuizTopicsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func learnMoreTopics(_ sender: UIButton) {
        if let url = URL(string: "https://www.cprelondon.org.uk/news/10-reasons-higher-density-living-is-good-for-communities/"){
            UIApplication.shared.open(url)
        }
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
