//
//  HistoryTableView.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 07/02/2016.
//  Copyright © 2016 LARCHER Maxime. All rights reserved.
//

import UIKit

class HistoryView: UIView, UITableViewDelegate, UITableViewDataSource
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
		tableView.delegate = self
		tableView.dataSource = self
        self.addSubview(tableView)
		actionHistory = loadActions()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	
	// MARK: -- UITableViewDelegate
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return actionHistory.actions.count
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 90
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "HistoryTableViewCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
		
		let cellSubviews = cell.subviews
		for i in cellSubviews
		{
			i.removeFromSuperview()
		}
		let action = actionHistory.actions[indexPath.row]
		let label = UILabel(frame: CGRect(x: 10, y: 15, width: cell.bounds.width-50, height: 60))
		label.numberOfLines = 2
		label.lineBreakMode = .ByWordWrapping
		label.text = action.getDetails()
		cell.addSubview(label)
		cell.userInteractionEnabled = false
		return cell
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

