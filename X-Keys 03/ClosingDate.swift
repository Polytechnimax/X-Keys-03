//
//  OpeningDate.swift
//  X-Keys 02
//
//  Created by LARCHER Maxime on 24/10/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class ClosingDate : NSObject, NSCoding
{
	// MARK: Archiving Path
	static let DocumentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
	static let ArchiveURL = DocumentDirectory.URLByAppendingPathComponent("closingDate")
	
	// MARK: Instances
	var closingDate: NSDate?
	var foreverOpen: Bool?
	
	// MARK: -- Keys
	struct PropertyKey {
		static let closingDateKey = "closingDate"
		static let foreverOpenKey = "foreverOpen"
	}
	
	// MARK: Initialisers
	init?(duration: Int?)
	{
		super.init()
		
		foreverOpen = false
		
		if let dur = duration
		{
			if dur == 0
			{
				closingDate = NSDate()
			}
				
			else if dur < 0
			{
				closingDate = nil
			}
				
			else
			{
				closingDate = NSDate(timeIntervalSinceNow: NSTimeInterval(dur))
			}
		}
		else
		{
			closingDate = nil
		}
	}
	
	init?(closingDate: NSDate?)
	{
		super.init()
		
		foreverOpen = false
		
		if let cD = closingDate
		{
			self.closingDate = cD
		}
		else
		{
			self.closingDate = nil
		}
	}
	
	// MARK: NSCoding
	func encodeWithCoder(aCoder: NSCoder)
	{
		aCoder.encodeObject(closingDate, forKey: PropertyKey.closingDateKey)
		aCoder.encodeObject(foreverOpen, forKey: PropertyKey.foreverOpenKey)
	}
	required convenience init?(coder aDecoder: NSCoder)
	{
		let closingDate = aDecoder.decodeObjectForKey(PropertyKey.closingDateKey) as? NSDate, fO = aDecoder.decodeObjectForKey(PropertyKey.foreverOpenKey) as? Bool
		
		self.init(closingDate: closingDate)
		self.foreverOpen = fO
	}
}









































