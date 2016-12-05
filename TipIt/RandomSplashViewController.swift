//
//  RandomSplashViewController.swift
//  TipIt
//
//  Created by Steven Hurtado on 11/30/16.
//  Copyright © 2016 Steven Hurtado. All rights reserved.
//

import UIKit

class RandomSplashViewController: UIViewController {

    @IBOutlet weak var randLabel: UILabel!
    
    let stringArr = ["Jimmy doesn't tip. Don't be Jimmy.", "Tip me baby one more time.", "The puns are just the TIP of the iceberg.", "Tipping is good karma!"]
    
    var timer = Timer()
    
    override func viewDidLoad()
    {
        
        //random index for splash label
        let randInd:UInt32 = arc4random_uniform(4) // range is 0 to 3
        
        super.viewDidLoad()

        randLabel.text = stringArr[Int(randInd)]
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(delayedSegue), userInfo: nil, repeats: false)
    }
    
    func delayedSegue()
    {
        self.performSegue(withIdentifier: "splashSegue", sender: self)
    }

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
