//
//  ActionHistory.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 07/02/2016.
//  Copyright © 2016 LARCHER Maxime. All rights reserved.
//

import Foundation

class ActionHistory: NSObject, NSCoding
{
	// MARK: Archiving Path
	static let DocumentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
	static let ArchiveURL = DocumentDirectory.URLByAppendingPathComponent("ActionHistory")
	
	
	
	// MARK: -- Properties
	var actions: [Action]!
	
	
	
	// MARK: -- Keys
	struct PropertyKey {
		static let actionsKey = "actions"
	}
	
	
	
	// MARK: -- Initialisation
	override init() {
		super.init()
		actions = []
	}
	init(actions: [Action]?)
	{
		if let actions = actions
		{
			self.actions = actions
		}
		else
		{
			self.actions = []
		}
	}
	
	
	
	// MARK: -- NSCoding
	func encodeWithCoder(aCoder: NSCoder)
	{
		aCoder.encodeObject(actions, forKey: PropertyKey.actionsKey)
	}
	required convenience init?(coder aDecoder: NSCoder)
	{
		let actionList = aDecoder.decodeObjectForKey(PropertyKey.actionsKey) as? [Action]
		self.init(actions: actionList)
	}
}