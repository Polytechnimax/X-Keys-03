//
//  HistoryTableView.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 07/02/2016.
//  Copyright © 2016 LARCHER Maxime. All rights reserved.
//

import UIKit

class HistoryView: UIView
{
    
    
    // MARK: -- Properties
	var actionHistory: ActionHistory!
	
	
	
	// MARK: -- Visual Properties
	var tableView: UITableView!
	
	
    
    // MARK: -- Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Initialise properties
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.bounds.width, height: self.bounds.height))
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
        self.addSubview(tableView)
		actionHistory = loadActions()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	
	
	// MARK: -- NSCoding
	func saveActions() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(actionHistory, toFile: ActionHistory.ArchiveURL.path!)
		
		if !isSuccessfulSave
		{
			print("Failed to save closing date...")
		}
	}
	func loadActions() -> ActionHistory {
		if let actionHistory = NSKeyedUnarchiver.unarchiveObjectWithFile(ActionHistory.ArchiveURL.path!) as? ActionHistory
		{
			return actionHistory
		}
		else
		{
			// Return something just to try, return [] otherwise.
			let action1 = Action(name: "Maxime", date: NSDate(), type: true)
			let action2 = Action(name: "Jérôme", date: NSDate(timeIntervalSinceNow: NSTimeInterval(-10000)), type: false)
			let actionHistory = ActionHistory(actions: [action1, action2])
			return actionHistory
		}
	}
}

