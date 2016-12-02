//
//  PopOverViewController.swift
//  TipIt
//
//  Created by Steven Hurtado on 12/2/16.
//  Copyright © 2016 Steven Hurtado. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController
{
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let index = defaults.integer(forKey: "default_tip_percentage")

        segmentedController.selectedSegmentIndex = index
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl)
    {
        defaults.set(segmentedController.selectedSegmentIndex, forKey: "default_tip_percentage")
        defaults.synchronize()

    }
    
    override func didReceiveMemoryWarning()
    {
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
