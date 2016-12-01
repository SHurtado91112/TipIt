//
//  ViewController.swift
//  TipIt
//
//  Created by Steven Hurtado on 11/30/16.
//  Copyright © 2016 Steven Hurtado. All rights reserved.
//

import UIKit
import HGCircularSlider
import Foundation

extension Double
{
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

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
    
    var timer = Timer()
    var perc = 0
    
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var splitBtn: UIButton!
    @IBOutlet weak var slider: CircularSlider!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var splitView: UIView!
    @IBOutlet weak var splitNumLabel: UILabel!
    @IBOutlet weak var splitTotalLabel: UILabel!
    var split = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //user default values
            let defaultGratuity = 15
            splitView.alpha = 0
        
        //nav bar font and text color
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: (95/255.0), green: (198/255.0), blue: (97/255.0), alpha: 1), NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
       
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        
    
        //gradient for background layer
            setGradientLayer()
        
        //tap dismisses number pad
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TipViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tap)
        
        //set up circular slider
            slider.minimumValue = 0
            slider.maximumValue = 100
            slider.endPointValue = CGFloat(defaultGratuity)
        
        //update tip label
            percentLabel.textColor = UIColor.white
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTip), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //set text field with default currency identifier
            billTextField.resignFirstResponder()
            billTextField.becomeFirstResponder()
            billTextField.placeholder = Currency.getIdentifier()

    }

    func setGradientLayer()
    {
        let bottomColor = UIColor(red: (95/255.0), green: (198/255.0), blue: (97/255.0), alpha: 1)
        let topColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func updateTip()
    {
        var userValue = Double(billTextField.text!)
        userValue = userValue?.roundTo(places: 2)
        
        perc = Int(round(slider.endPointValue))
        
        percentLabel.text = "\(perc)%"
        
        if(userValue != nil)
        {
            let tip = (userValue)! * Double(perc) * 0.01
            
            tipAmountLabel.text = "\(Currency.getIdentifier()) \(String(format: "%.2f", tip))"
            
            let total = (userValue)! + tip
            totalAmountLabel.text = "\(Currency.getIdentifier()) \(String(format: "%.2f", total))"
            
            if(split)
            {
                let splitNum = Double(splitNumLabel.text!)
                
                let splitTotal = total/splitNum!
                
                splitTotalLabel.text = "\(Currency.getIdentifier()) \(String(format: "%.2f", splitTotal))"
            }
        }
        else
        {
            tipAmountLabel.text = "\(Currency.getIdentifier()) \(String(format: "%.2f", 0))"
            
            totalAmountLabel.text = "\(Currency.getIdentifier()) \(String(format: "%.2f", 0))"
            
            splitTotalLabel.text = "\(Currency.getIdentifier()) \(String(format: "%.2f", 0))"
        }
    }

    @IBAction func splitBtnPressed(_ sender: Any)
    {
        
        if(!split)
        {
            split = true
            
            splitView.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations:
            {
                    self.splitView.alpha = 1
            })
        }
        else
        {
            split = false
            
            UIView.animate(withDuration: 0.4, animations:
            {
                    self.splitView.alpha = 0
            })
        }
    }
    
    @IBAction func stepChanged(_ sender: Any)
    {
        splitNumLabel.text = "\(Int(stepper.value))"
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


}

