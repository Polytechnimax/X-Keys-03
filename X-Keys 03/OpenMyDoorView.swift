//
//  OpenMyDoorView.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 06/11/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class OpenMyDoorView: UIView
{
	
	
	
	// MARK: - Properties
	var timer = NSTimer()
	var timerRunning = false
	var currentDate = NSDate()
	var pickerViewIsHidden: Bool = true
	var closingDate: ClosingDate!
	
	
	
	// MARK: - Visual Properties
	var openTheDoorButton: UIButton!
	var openTheDoorForDurationButton: UIButton!
	var closeTheDoorButton: UIButton!
	var doorStateLabel: UILabel!
	var backgroundImageView: UIImageView!
	var timePickerManagementView: TimePickerManagementView!
	
	
	// MARK: - Initialisation
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		initialiseBackgoundImage()
		initialiseDoorStateLabel()
		initialiseOpenTheDoorButton()
		initialiseOpenTheDoorForDurationButton()
		initialiseCloseTheDoorButton()
		timePickerManagementView = TimePickerManagementView(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 200))
		self.addSubview(timePickerManagementView)
		
		// Add proper targets to the PickerView
		timePickerManagementView.OKButton.addTarget(self, action: "pickerViewOKButtonIsPressed:", forControlEvents: .TouchUpInside)
		timePickerManagementView.CancelButton.addTarget(self, action: "pickerViewCancelButtonIsPressed:", forControlEvents: .TouchUpInside)
		
		closingDate = ClosingDate(closingDate: NSDate())
		closingDate.foreverOpen = false
		
		// Load last know closing date
		if let cD = loadClosingDate()
		{
			closingDate = cD
		}
		else
		{
			closingDate = ClosingDate(closingDate: NSDate())
			closingDate.foreverOpen = false
		}
		count()
	}
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	
	// MARK: - Initialise buttons
	func initialiseOpenTheDoorButton()
	{
		openTheDoorButton = UIButton(frame: CGRect(x: self.bounds.width/2 - 120, y: self.bounds.height/2 - 80, width: 240, height: 40))
		openTheDoorButton.layer.cornerRadius = 10
		openTheDoorButton.layer.masksToBounds = true
		openTheDoorButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
		openTheDoorButton.setTitle("Ouvrir ma porte", forState: .Normal)
		openTheDoorButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Normal)
		openTheDoorButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.25), forState: .Highlighted)
		openTheDoorButton.addTarget(self, action: "openTheDoorButtonIsPressed:", forControlEvents: .TouchUpInside)
		self.addSubview(openTheDoorButton)
	}
	func initialiseOpenTheDoorForDurationButton()
	{
		openTheDoorForDurationButton = UIButton(frame: CGRect(x: self.bounds.width/2 - 120, y: self.bounds.height/2 - 20, width: 240, height: 40))
		openTheDoorForDurationButton.layer.cornerRadius = 10
		openTheDoorForDurationButton.layer.masksToBounds = true
		openTheDoorForDurationButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
		openTheDoorForDurationButton.setTitle("Ouvrir ma porte pendant...", forState: .Normal)
		openTheDoorForDurationButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Normal)
		openTheDoorForDurationButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.25), forState: .Highlighted)
		openTheDoorForDurationButton.addTarget(self, action: "openTheDoorForDurationButtonIsPressed:", forControlEvents: .TouchUpInside)
		self.addSubview(openTheDoorForDurationButton)
	}
	func initialiseCloseTheDoorButton()
	{
		closeTheDoorButton = UIButton(frame: CGRect(x: self.bounds.width/2 - 120, y: self.bounds.height/2 + 40, width: 240, height: 40))
		closeTheDoorButton.layer.cornerRadius = 10
		closeTheDoorButton.layer.masksToBounds = true
		closeTheDoorButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
		closeTheDoorButton.setTitle("Fermer ma porte", forState: .Normal)
		closeTheDoorButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Normal)
		closeTheDoorButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.25), forState: .Highlighted)
		closeTheDoorButton.addTarget(self, action: "closeTheDoorButtonIsPressed:", forControlEvents: .TouchUpInside)
		self.addSubview(closeTheDoorButton)
	}
	
	
	
	// MARK: - Initialise image
	func initialiseBackgoundImage()
	{
		backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
		backgroundImageView = UIImageView(image: UIImage(named: "colorfulDoor"))
		self.addSubview(backgroundImageView)
	}
	
	
	
	// MARK: - Initialise label
	func initialiseDoorStateLabel()
	{
		doorStateLabel = UILabel(frame: CGRect(x: 0, y: 64, width: self.bounds.width, height: 40))
		doorStateLabel.textAlignment = NSTextAlignment.Center
		self.addSubview(doorStateLabel)
	}
	func configureDoorStateLabel(timeUntilClosingDate: Int)
	{
		var stringToDisplay: String
		var open = true
		
		// Configure the text according to the timeUntilClosingDate, check if door is opened
		if closingDate.foreverOpen!
		{
			stringToDisplay = "Porte ouverte"
			
		}
		else if timeUntilClosingDate <= 0
		{
			stringToDisplay = "Porte fermée"
			open = false
		}
			// Door opened for a finite time
		else
		{
			if timeUntilClosingDate < 60
			{
				stringToDisplay = "Porte ouverte pendant \(timeUntilClosingDate+1)s"
			}
			else if timeUntilClosingDate < 300
			{
				let m:Int = (timeUntilClosingDate+1)/60, s:Int = (timeUntilClosingDate+1)%60
				stringToDisplay = "Porte ouverte pendant \(m)m\(s)s"
			}
			else if timeUntilClosingDate < 3600
			{
				let m:Int = timeUntilClosingDate/60 + 1
				stringToDisplay = "Porte ouverte pendant \(m)m"
			}
			else
			{
				let h:Int = (timeUntilClosingDate+60)/3600, m:Int = (timeUntilClosingDate+60)%3600/60
				stringToDisplay = "Porte ouverte pendant \(h)h\(m)m"
			}
		}
		
		
		if open
		{
			doorStateLabel.backgroundColor = UIColor.greenColor()
		}
		else
		{
			doorStateLabel.backgroundColor = UIColor.redColor()
		}
		doorStateLabel.alpha = 3/4
		doorStateLabel.text = stringToDisplay
	}

	
	
	// MARK: - Actions
	func openTheDoorButtonIsPressed(sender: UIButton)
	{
		// Cancel permanent opening if need be
		closingDate.foreverOpen = false
		// Set closingDate to proper value & save it
		closingDate.closingDate = NSDate(timeIntervalSinceNow: 45)
		saveClosingDate()
		// Use count to configure timer and display right content
		count()
		if !timerRunning
		{
			timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("count"), userInfo: nil, repeats: true)
			timerRunning = true
		}
	}
	func openTheDoorForDurationButtonIsPressed(sender: UIButton)
	{
		if pickerViewIsHidden
		{
			// Cancel hiding and animate
			UIView.animateWithDuration(0.5, animations: {
				self.timePickerManagementView.center.y -= self.timePickerManagementView.bounds.height
			})
			pickerViewIsHidden = false
		}
			
		else
		{
			//Animate and hide
			UIView.animateWithDuration(0.5, animations: {
				self.timePickerManagementView.center.y += self.timePickerManagementView.bounds.height
			})
			pickerViewIsHidden = true
		}	}
	func closeTheDoorButtonIsPressed(sender: UIButton)
	{
		// Cancel permanent opening if need be
		closingDate.foreverOpen = false
		// Set closing date to now & save it
		closingDate.closingDate = NSDate()
		saveClosingDate()
		// Use count to configure timer and display right content
		count()
	}
	
	
	
	// MARK: - PickerView Acions
	func pickerViewCancelButtonIsPressed(sender: UIButton)
	{
		//Animate and hide
		UIView.animateWithDuration(0.5, animations: {
			self.timePickerManagementView.center.y += self.timePickerManagementView.bounds.height
		})
		pickerViewIsHidden = true
	}
	func pickerViewOKButtonIsPressed(sender: UIButton)
	{
		// Cancel permanent opening if need be
		closingDate.foreverOpen = false
		//Animate and hide
		UIView.animateWithDuration(0.5, animations: {
			self.timePickerManagementView.center.y += self.timePickerManagementView.bounds.height
		})
		pickerViewIsHidden = true
		
		// Set closingDate to appropriate value
		let h = timePickerManagementView.pickerView.selectedRowInComponent(0), m = timePickerManagementView.pickerView.selectedRowInComponent(1)
		if h==0 && m==0
		{
			closingDate.foreverOpen = true
			saveClosingDate()
			count()
		}
		else
		{
			let timeAmount = NSTimeInterval(3600*h + 60*m)
			closingDate.closingDate = NSDate(timeIntervalSinceNow: timeAmount)
			saveClosingDate()
			if !timerRunning
			{
				timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("count"), userInfo: nil, repeats: true)
				timerRunning = true
			}
		}
		
	}
	
	
	
	// MARK/ - NSTimer
	func count()
	{
		// Update current date
		currentDate = NSDate()
		// timeInterval = time between currenrDate and closingDate (in seconds)
		let timeInterval = Int(closingDate.closingDate!.timeIntervalSinceDate(currentDate))
		
		configureDoorStateLabel(timeInterval)
		
		// Manage timer
		// If door is closed or opened forever, no need of timer
		if closingDate.foreverOpen! || timeInterval <= 0
		{
			timer.invalidate()
			timerRunning = false
		}
			// Door is opened, timer should be running, if not...
		else if !timerRunning
		{
			// ...cancel timer in case it is actually running...
			timer.invalidate()
			// ...and set timer on
			timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("count"), userInfo: nil, repeats: true)
			timerRunning = true
		}
	}
	
	
	
	// MARK: NSCoding
	func saveClosingDate()
	{
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(closingDate, toFile: ClosingDate.ArchiveURL.path!)
		
		if !isSuccessfulSave
		{
			print("Failed to save closing date...")
		}
	}
	func loadClosingDate() -> ClosingDate?
	{
		return NSKeyedUnarchiver.unarchiveObjectWithFile(ClosingDate.ArchiveURL.path!) as? ClosingDate
	}
}



























