//
//  ViewController.swift
//  TipIt
//
//  Created by Steven Hurtado on 11/30/16.
//  Copyright © 2016 Steven Hurtado. All rights reserved.
//

import UIKit

class TipViewController: UIViewController
{
    
    struct Currency
    {
        static func getIdentifier(forLocale locale: Locale = Locale.current) -> String
        {
            return locale.currencySymbol!
        }
    }
    
    func dismissKeyboard()
    {
        billTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var billTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //nav bar font and text color
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: (95/255.0), green: (198/255.0), blue: (97/255.0), alpha: 1), NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
       
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        
    
        //gradient for background layer
            let bottomColor = UIColor(red: (95/255.0), green: (198/255.0), blue: (97/255.0), alpha: 1)
            let topColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        
            let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
            let gradientLocations: [Float] = [0.0, 1.0]
        
            let gradientLayer: CAGradientLayer = CAGradientLayer()
            gradientLayer.colors = gradientColors
            gradientLayer.locations = gradientLocations as [NSNumber]?
        
            gradientLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        //tap dismisses number pad
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TipViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //set text field with default currency identifier
            billTextField.resignFirstResponder()
            billTextField.becomeFirstResponder()
            billTextField.placeholder = Currency.getIdentifier()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

