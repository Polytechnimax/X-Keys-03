//
//  GuestsManagementView.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 08/11/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class GuestsManagementView: UIView
{
	
	
	
	// MARK: - Properties
	var tableView = UITableView()
	var guests: [Guest] = []
	var storedIndexPath: NSIndexPath? = nil
	
	
	
	// MARK: Initialisation
	override init(frame: CGRect) {
		super.init(frame: frame)
        
		// Initialise tableView
		tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.bounds.width, height: self.bounds.height))
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "GuestTableViewCell")
		self.addSubview(tableView)
	}
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
		
	
	
}
































