//
//  Lock.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 18/02/2016.
//  Copyright © 2016 LARCHER Maxime. All rights reserved.
//

import UIKit

class Lock : NSObject
{
	// MARK: -- Properties
	var name: String!
	var image: UIImage!
	
	
	
	// MARK: -- Initilization
	init(name: String, image: UIImage)
	{
		super.init()
		self.name = name
		self.image = image
	}
}