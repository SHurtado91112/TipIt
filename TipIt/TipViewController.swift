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
    func roundTo(places:Int) -> Double
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct Currency
{
    static func getIdentifier(forLocale locale: Locale = Locale.current) -> String
    {
        return locale.currencySymbol!
    }
    
    static func getSeparator(forLocale locale: Locale = Locale.current) -> String
    {
        return locale.groupingSeparator!
    }
    
    static func getDec(forLocale locale: Locale = Locale.current) -> String
    {
        return locale.decimalSeparator!
    }
}

struct Number
{
    static let withSeparator: NumberFormatter =
    {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = Currency.getSeparator()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer
{
    var stringWithSeparator: String
    {
        return Number.withSeparator.string(from: NSNumber(value: hashValue)) ?? ""
    }
}

class TipViewController: UIViewController, UIPopoverPresentationControllerDelegate
{
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
            let defaults = UserDefaults.standard
        
            var defaultGratuity = defaults.integer(forKey: "default_tip_percentage")
        
            switch(defaultGratuity)
            {
            case 0:
                defaultGratuity = 15
            case 1:
                defaultGratuity = 18
            case 2:
                defaultGratuity = 20
            default:
                break;
            }
        
            splitView.alpha = 0
            splitBtn.layer.borderColor = UIColor.white.cgColor
            splitBtn.layer.borderWidth = 1
            splitBtn.layer.cornerRadius = 5
        
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
            billTextField.becomeFirstResponder()
            billTextField.placeholder = "\(Currency.getIdentifier()) Bill Amount"

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
            
            var wholeNum = Int(tip).stringWithSeparator
            
            var decSub = String(format: "%.2f", Float(tip.truncatingRemainder(dividingBy: 1))).index(String(format: "%.2f", Float(tip.truncatingRemainder(dividingBy: 1))).startIndex, offsetBy: 2)
            
            var decimalPortion = String(format: "%.2f", Float(tip.truncatingRemainder(dividingBy: 1))).substring(from: decSub)
            
            tipAmountLabel.text = "\(Currency.getIdentifier()) \(String(wholeNum)!)\(Currency.getDec())\(decimalPortion)"
        
            let total = (userValue)! + tip
            
            wholeNum = Int(total).stringWithSeparator
            
            decSub = String(format: "%.2f", Float(total.truncatingRemainder(dividingBy: 1))).index(String(format: "%.2f", Float(total.truncatingRemainder(dividingBy: 1))).startIndex, offsetBy: 2)
            
            decimalPortion = String(format: "%.2f", Float(total.truncatingRemainder(dividingBy: 1))).substring(from: decSub)
            
            totalAmountLabel.text = "\(Currency.getIdentifier()) \(String(wholeNum)!)\(Currency.getDec())\(decimalPortion)"
            
            if(split)
            {
                let splitNum = Double(splitNumLabel.text!)
                
                let splitTotal = total/splitNum!

                wholeNum = Int(splitTotal).stringWithSeparator
                
                decSub = String(format: "%.2f", Float(splitTotal.truncatingRemainder(dividingBy: 1))).index(String(format: "%.2f", Float(splitTotal.truncatingRemainder(dividingBy: 1))).startIndex, offsetBy: 2)
                
                decimalPortion = String(format: "%.2f", Float(splitTotal.truncatingRemainder(dividingBy: 1))).substring(from: decSub)
                
                splitTotalLabel.text = "\(Currency.getIdentifier()) \(String(wholeNum)!)\(Currency.getDec())\(decimalPortion)"
            }
        }
        else
        {
            tipAmountLabel.text = "\(Currency.getIdentifier()) Gratuity"
            
            totalAmountLabel.text = "\(Currency.getIdentifier()) Total"
            
            splitTotalLabel.text = "\(Currency.getIdentifier()) Split Total"
        }
    }

    @IBAction func splitBtnPressed(_ sender: Any)
    {
        
        if(!split)
        {
            split = true
            splitBtn.setTitle("Not splitting anymore?", for: .normal)
            splitView.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations:
            {
                    self.splitView.alpha = 1
            })
        }
        else
        {
            split = false
            splitBtn.setTitle("Splitting the bill?", for: .normal)
            
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
    
    @IBAction func popPressed(_ sender: Any)
    {
        self.performSegue(withIdentifier: "popSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "popSegue")
        {
            let vc = segue.destination as! PopOverViewController
            
            vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
            
            let contr = vc.popoverPresentationController
            
            if(contr != nil)
            {
                contr?.delegate = self
            }
        }
    }

}

