//
//  SiteInfoViewController.swift
//  ARYIMBY
//
//  Created by Wenhao Wu on 4/30/23.
//

import UIKit

class SiteInfoViewController: UIViewController {
    
    
    @IBOutlet weak var SiteImage: UIImageView!
//    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        SiteImage.image = UIImage(named: "art.scnassets/site1_existing.png")
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
