//
//  TimePickerManagementView.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 07/11/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class TimePickerManagementView: UIView, UIPickerViewDelegate, UIPickerViewDataSource
{
	
	
	
	// MARK: - Properties
	var hourPickerDate: [String] = []
	var minutePickerDate: [String] = []
	
	
	
	// MARK: - Visual properties
	var pickerView = UIPickerView()
	var blurEffect = UIBlurEffect(style: .Light)
	var blurView = UIVisualEffectView()
	var OKButton = UIButton()
	var CancelButton = UIButton()

	
	
	// MARK: Initialisation
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		// Initialize pickerView
		pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: self.bounds.width, height: self.bounds.height-50))
		pickerView.delegate = self
		pickerView.dataSource = self
		
		// Initialize OKButton
		OKButton = UIButton(frame: CGRect(x: self.bounds.width - 80, y: 10, width: 60, height: 30))
		OKButton.setTitle("OK", forState: .Normal)
		OKButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Normal)
		OKButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.25), forState: .Highlighted)
		// Initialize CancelButton
		CancelButton = UIButton(frame: CGRect(x: 20, y: 10, width: 60, height: 30))
		CancelButton.setTitle("Cancel", forState: .Normal)
		CancelButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Normal)
		CancelButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.25), forState: .Highlighted)
		
		// Initialize blurView
		blurView = UIVisualEffectView(effect: blurEffect)
		blurView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
		
		// Add everything to the backgroundView
		self.addSubview(blurView)
		self.addSubview(pickerView)
		self.addSubview(OKButton)
		self.addSubview(CancelButton)
		
		// Initialize _PickerDate
		for i in 0...23
		{
			hourPickerDate += ["\(i)"]
		}
		for i in 0...59
		{
			minutePickerDate += ["\(i)"]
		}
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UIPickerView
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 2
	}
	// Set the number of rows in each component
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == 0
		{
			return 24
		}
		else
		{
			return 60
		}
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if component == 0
		{
			return hourPickerDate[row]
		}
		else
		{
			return minutePickerDate[row]
		}
	}
	
}



































