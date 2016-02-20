//
//  LockList.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 18/02/2016.
//  Copyright © 2016 LARCHER Maxime. All rights reserved.
//

import Foundation

class LockArray: NSObject, NSCoding
{
	// MARK: -- Properties
	var lockArray: [Lock]!
	
	
	
	// MARK: -- Initialization
	init(lockArray: [Lock]?) {
		super.init()
		if lockArray != nil
		{
			self.lockArray = lockArray
		}
		else
		{
			self.lockArray = []
		}
	}
	
	
	
	// MARK: Keys
	struct PropertyKey {
		static let lockArrayKey = "lockArray"
	}
	
	
	// MARK: -- NSCoding
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(self.lockArray, forKey: PropertyKey.lockArrayKey)
	}
	required convenience init(coder aDecoder: NSCoder)
	{
		let lockArray = aDecoder.decodeObjectForKey(PropertyKey.lockArrayKey) as? [Lock]
		
		self.init(lockArray: lockArray)
	}
}
