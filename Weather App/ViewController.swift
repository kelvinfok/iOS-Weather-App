//
//  ViewController.swift
//  Weather App
//
//  Created by kelvinfok on 13/7/16.
//  Copyright © 2016 kelvinfok. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBAction func findWeather(sender: AnyObject) {
        
        var wasSuccessful = false
        resultLabel.text = ""
        weatherLabel.text = cityTextField.text
        let city = cityTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        ).stringByReplacingOccurrencesOfString(" ", withString: "-").stringByReplacingOccurrencesOfString(".", withString: "")
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + city + "/forecasts/latest")
        
       if attemptedUrl != nil {
           let url = attemptedUrl
        
            // if let url = attemptedUrl {
            
            
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            if let urlContent = data {
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                
                if websiteArray!.count > 1 {
                    let weatherArray = websiteArray![1].componentsSeparatedByString("</span>")
                    
                    if weatherArray.count > 1 {
                        
                        wasSuccessful = true
                        
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.resultLabel.text = weatherSummary
                        })
                        
                        
                    }
                }
                
            }
            if wasSuccessful == false {
                dispatch_async(dispatch_get_main_queue(), {
                    self.resultLabel.text = "Invalid city. Try another city."
                })
            }
        }
        task.resume()
      }
        
        else {
        dispatch_async(dispatch_get_main_queue(), {
            self.resultLabel.text = "Invalid city. Try another city."
        })
        
        }
        
        // Closes Keyboard
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityTextField.delegate = self
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Closes the keyboard when touch outside
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Close the keyboard with "Return" is pressed
    func textFieldShouldReturn(TextField: UITextField) -> Bool {
        TextField.resignFirstResponder()
        return true
    }
    
}

