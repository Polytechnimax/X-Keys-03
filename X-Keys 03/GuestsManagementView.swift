//
//  GuestsManagementView.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 08/11/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class GuestsManagementView: UIView, UITableViewDelegate, UITableViewDataSource
{
	
	
	
	// MARK: - Properties
	var tableView = UITableView()
	var guests: [Guest] = []
	var storedIndexPath: NSIndexPath? = nil
	var superViewController : UIViewController!
	
	
	
	// MARK: Initialisation
	init(frame: CGRect, superViewController: UIViewController) {
		super.init(frame: frame)
        
		// Initialise tableView
		tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.bounds.width, height: self.bounds.height))
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "GuestTableViewCell")
		tableView.delegate = self
		tableView.dataSource = self
		self.addSubview(tableView)
		
		// Remember the UIViewController it originated from
		self.superViewController = superViewController
		
		if let g = loadGuests() {guests = g}
		else {testLoad()}
	}
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	
	// MARK: -- UITableViewDelegate
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return guests.count
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 90
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "GuestTableViewCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
		
		// Empty the cell before adding content
		let cellSubviews: [UIView] = cell.subviews
		for c in cellSubviews
		{
			c.removeFromSuperview()
		}
		
		let guest = guests[indexPath.row]
		
		let picture: UIImageView = UIImageView(image: guest.picture)
		let label = UILabel(frame: CGRect(x: 100, y: 30, width: cell.bounds.width-100, height: 30))
		picture.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
		label.text = guest.firstName + " " + guest.name
		cell.addSubview(picture)
		cell.addSubview(label)
		return cell
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.superViewController.performSegueWithIdentifier("ShowDetailTest", sender: tableView.cellForRowAtIndexPath(indexPath))
	}
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		// Define the action to be called when the button is pressed
		let deleteClosure = {(action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
			self.guests.removeAtIndex(indexPath.row)
			self.saveGuests()
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		}
		// Set the button title and link it to its action
		let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
		deleteAction.backgroundColor = UIColor.redColor()
		
		// Define the action to be called when the button is pressed
		let editClosure = {(action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
			self.storedIndexPath = indexPath
			self.tableView.reloadData() // Why do I reload data now?
			self.superViewController.performSegueWithIdentifier("Edit", sender: tableView.cellForRowAtIndexPath(indexPath))
		}
		// Set the button title and link it to its action
		let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: editClosure)
		editAction.backgroundColor = UIColor.orangeColor()
		
		return [deleteAction, editAction]
	}
	
	
	// MARK: -- NSCoding
	func saveGuests()
	{
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(guests, toFile: Guest.ArchiveURL.path!)
		
		if !isSuccessfulSave
		{
			print("Failed to save guests...")
		}
	}
	func loadGuests() -> [Guest]?
	{
		return NSKeyedUnarchiver.unarchiveObjectWithFile(Guest.ArchiveURL.path!) as? [Guest]
	}
	func testLoad()
	{
		let picture = UIImage(named: "defaultImage")!
		let guest1 = Guest(name: "Marécal", firstName: "Étienne", picture: picture)!
		let guest2 = Guest(name: "Kafrouni", firstName: "Jérôme", picture: picture)!
		let guest3 = Guest(name: "Larcher", firstName: "Maxime", picture: picture)!
		guests += [guest1, guest2, guest3]
	}
}
































