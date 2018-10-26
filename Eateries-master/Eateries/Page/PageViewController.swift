//
//  PageViewController.swift
//  Eateries
//
//  Created by user131656 on 11/7/17.
//  Copyright © 2017 Aleksey Kabishau. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var headersArray = ["Create", "Find"]
    var subHeaderArray = ["Create a list of your favourite restaurants", "Find and check on map your favourite restaurants"]
    var imagesArray = ["food", "iphoneMap"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstViewController = displayViewController(atIndex: 0) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        
        // checking to avoid crashing when user will try to swape to view controller that doesn't exist
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        
        contentViewController.header = headersArray[index]
        contentViewController.subHeader = subHeaderArray[index]
        contentViewController.imageFile = imagesArray[index]
        contentViewController.index = index
        
        return contentViewController
    }
    
    func displayNextViewController(atIndex index: Int) {
        if let contentViewController = displayViewController(atIndex: index + 1) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}

// method for supporting scrolling between pages back and force
extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
    
//    // standart implementing of Page Control
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headersArray.count
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController
//        return contentViewController!.index
//    }
    
    
}
