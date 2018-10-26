//
//  ContentViewController.swift
//  Eateries
//
//  Created by user131656 on 11/7/17.
//  Copyright © 2017 Aleksey Kabishau. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageContol: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    
    @IBAction func pageButtonTapped(_ sender: UIButton) {
        switch index {
        case 0:
            let pageViewController = parent as! PageViewController
            pageViewController.displayNextViewController(atIndex: index)
        case 1:
            //getting access to UserDefaults
            let userDefaults = UserDefaults.standard
            // setting the value
            userDefaults.set(true, forKey: "wasIntroWatched")
            userDefaults.synchronize()
            
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    var header = ""
    var subHeader = ""
    var imageFile = ""
    var index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        pageButton.layer.borderColor = (#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)).cgColor
        
        switch index {
        case 0: pageButton.setTitle("Дальше", for: .normal)
        case 1: pageButton.setTitle("Начать пользоваться", for: .normal)
        default:
            break
        }
        
        headerLabel.text = header
        subHeaderLabel.text = subHeader
        imageView.image = UIImage(named: imageFile)
        pageContol.numberOfPages = 2
        pageContol.currentPage = index

    }

}
