//
//  Guest.swift
//  X-Keys 02
//
//  Created by LARCHER Maxime on 15/10/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class Guest: NSObject, NSCoding
{
	// MARK: Properties
	
	var name: String
	var firstName: String
	var picture: UIImage?
	
	// MARK: Archiving Path
	static let DocumentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
	static let ArchiveURL = DocumentDirectory.URLByAppendingPathComponent("guests")
	
	// MARK: Types
	struct propertyKey
	{
		static let nameKey = "name"
		static let firstNameKey = "first name"
		static let pictureKey = "picture"
		
	}
	
	// MARK: Initialization
	init?(name: String, firstName: String, picture: UIImage?)
	{
		// Initilize properties
		self.name = name
		self.firstName = firstName
		self.picture =  picture
		
		super.init()
		
		if picture == nil
		{
			self.picture = UIImage(named: "defaultImage")
		}
		
		if self.name.isEmpty || self.firstName.isEmpty
		{
			return nil
		}
	}
	
	// MARK: NSCoding
	func encodeWithCoder(aCoder: NSCoder)
	{
		aCoder.encodeObject(name, forKey: propertyKey.nameKey)
		aCoder.encodeObject(firstName, forKey: propertyKey.firstNameKey)
		aCoder.encodeObject(picture, forKey: propertyKey.pictureKey)
	}
	required convenience init?(coder aDecoder: NSCoder)
	{
		let name = aDecoder.decodeObjectForKey(propertyKey.nameKey) as! String
		let firstName = aDecoder.decodeObjectForKey(propertyKey.firstNameKey) as! String
		let picture = aDecoder.decodeObjectForKey(propertyKey.pictureKey) as? UIImage
		
		self.init(name: name, firstName: firstName, picture: picture)
	}
}










