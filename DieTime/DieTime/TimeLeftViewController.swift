//
//  LifeViewController.swift
//  DieTime
//
//  Created by Charles Kang on 8/10/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class TimeLeftViewController: UIViewController
{
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let detailVC: TimeLeftDetailViewController = {
        let vc = UIStoryboard(name: "Main", bundle:  nil).instantiateViewControllerWithIdentifier("DetailVC") as! TimeLeftDetailViewController
        vc.loadView()
        return vc
    }()
    
    let dateFormatter = NSDateFormatter()
    let date = NSDate()
    let lifeExpectanctyService = LifeExpectancyService()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        lifeExpectanctyService.delegate = self
    }
    
    @IBAction func showDeathTouchUpInside(sender: AnyObject)
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: datePicker.date)
        let month = components.month
        let months = dateFormatter.monthSymbols
        let monthSymbol = months[month-1]
        
        lifeExpectanctyService.getLifeInfo(components.day, month: monthSymbol, year: components.year, gender: Gender.allValues[genderPicker.selectedRowInComponent(0)])
    }
    
    // MARK: Picker View Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Gender.allValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return Gender.allValues[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        genderPicker.selectedRowInComponent(component)
        Gender.allValues[row]
    }
}

extension TimeLeftViewController: LifeExpectancyServiceDelegate
{
    func setLifeExpectancy(lifeExpectancy: LifeExpectancy)
    {
        detailVC.ageLabel.text = String(format: "You are a %.2f year old \(Gender.allValues[genderPicker.selectedRowInComponent(0)]).", lifeExpectancy.currentAge)
        detailVC.yearsLeftLabel.text = String(format: "You have %.2f years left to live.", lifeExpectancy.yearsLeft)
        detailVC.monthsLeftLabel.text = String(format: "You have %.2f months left to live.", lifeExpectancy.monthsLeft)
        detailVC.daysLeftLabel.text = String(format: "You have %.2f days left to live.", lifeExpectancy.daysLeft)
        detailVC.lifeCompleteLabel.text = String(format: "You are %.2f percent done with your life.", lifeExpectancy.lifeComplete)
        showViewController(detailVC, sender: self)
    }
}