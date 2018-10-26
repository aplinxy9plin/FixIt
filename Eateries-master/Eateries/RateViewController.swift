//
//  RateViewController.swift
//  Eateries
//
//  Created by user131656 on 11/1/17.
//  Copyright © 2017 Aleksey Kabishau. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var brilliantButton: UIButton!
    
    // for rating system
    var restaurantRating: String?
    @IBAction func rateRestaurant(_ sender: UIButton) {
        switch sender.tag {
        case 0: restaurantRating = "bad"
        case 1: restaurantRating = "good"
        case 2: restaurantRating = "brilliant"
        default: break
        }
        performSegue(withIdentifier: "unwindSegueToDetailViewController", sender: sender)
    }
    
    
    
    // goes after the view did load
    // in this case is used for animating of smile-buttons
    override func viewDidAppear(_ animated: Bool) {
        
        /* option for the whole stack view
        let ratingStackView = stackView
        UIView.animate(withDuration: 0.5) {
            ratingStackView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        */
        
        // animating separate buttons
        let buttonArray = [badButton, goodButton, brilliantButton]
        // for loop for reaching every button in right order
        
        for (index, button) in buttonArray.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.4, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // scales whole stack view 0% from original size
        //stackView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        // scaling to 0% every button in stack view
        badButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        brilliantButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        // creating of blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // setting size of blurEffectView
        blurEffectView.frame = self.view.bounds
        // this is requered for phone rotation to keep blur effect
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // setting the position of blurEffectView - "1" mean in this case right above background
        self.view.insertSubview(blurEffectView, at: 1)
        
    }


}
