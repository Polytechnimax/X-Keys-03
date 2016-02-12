//
//  MainViewController.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 06/11/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class MainViewController: BluredSideBarViewController {

	
	
	// MARK: - Visual properties
	var openMyDoorView: OpenMyDoorView!
	var guestManagementView: GuestsManagementView!
	var historyView: HistoryView!
	var views: [UIView]!
	
	
	
	// MARK: Properties
	var guests: [Guest] = []
	var storedIndexPath: NSIndexPath? = nil
	var viewDisplayed: Int = 0
	
	
	// MARK: - Initialisation
    override func viewDidLoad() {
        super.viewDidLoad()

		// Initialise data
		if let g = loadGuests() {guests = g}
		else {testLoad()}
		
		openMyDoorView = OpenMyDoorView(frame: view.frame)
		guestManagementView = GuestsManagementView(frame: CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height))
		historyView = HistoryView(frame: CGRect(x: 2*view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height))
		views = [openMyDoorView, guestManagementView, historyView]
		view.addSubview(openMyDoorView)
		view.addSubview(guestManagementView)
		view.addSubview(historyView)
		
		// Set delegates
		guestManagementView.tableView.delegate = self
		guestManagementView.tableView.dataSource = self
		historyView.tableView.delegate = self
		historyView.tableView.dataSource = self
    }
	
	
	
	// MARK: - Actions
	func addItem(sender: UIBarButtonItem)
	{
		performSegueWithIdentifier("AddItem", sender: sender)
	}
	
	
	
	// MARK: - Navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "Edit"
		{
			let navigationController = segue.destinationViewController as! UINavigationController
			let guestViewController = navigationController.childViewControllers[0] as! GuestEditingViewController
			if let selectedGuestCell = sender as? UITableViewCell
			{
				let indexPath = guestManagementView.tableView.indexPathForCell(selectedGuestCell)!
				let selectedGuest = guests[indexPath.row]
				guestViewController.guestToEdit = selectedGuest
			}
		}
		else if segue.identifier == "ShowDetail"
		{
			let navigationController = segue.destinationViewController as! UINavigationController
			let guestDetailViewController = navigationController.childViewControllers[0] as! GuestDetailViewController
			//let guestDetailViewController = segue.destinationViewController as! GuestDetailViewController
			if let selectedGuestCell = sender as? UITableViewCell
			{
				let indexPath = guestManagementView.tableView.indexPathForCell(selectedGuestCell)!
				let selectedGuest = guests[indexPath.row]
				guestDetailViewController.guestToShow = selectedGuest
			}
		}
		else if segue.identifier == "ShowDetailTest"
		{
			let guestDetailViewController = segue.destinationViewController as! GuestDetailViewController
			if let selectedGuestCell = sender as? UITableViewCell
			{
				let indexPath = guestManagementView.tableView.indexPathForCell(selectedGuestCell)!
				let selectedGuest = guests[indexPath.row]
				guestDetailViewController.guestToShow = selectedGuest
			}
		}
	}
	@IBAction func unwindToMainView(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.sourceViewController as? GuestEditingViewController, guest = sourceViewController.guestToEdit
		{
			// Checks if we have been adding (storedIndexPath == nil) or editing (storedIndexPath != nil) a guest
			if let selectedIndexPath = self.storedIndexPath
			{
				// Update an existing guest
				guests[selectedIndexPath.row] = guest
				guestManagementView.tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
				self.storedIndexPath = nil
			}
				
			else
			{
				// Add a new guest
				let newIndexPath = NSIndexPath(forRow: guests.count, inSection: 0)
				guests.append(guest)
				guestManagementView.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
			}
			saveGuests()
		}
	}
	
	
	
	// MARK: - User interaction management
	override func forbideUserInteraction() {
		openMyDoorView.userInteractionEnabled = false
		guestManagementView.userInteractionEnabled = false
	}
	override func allowUserInteraction() {
		openMyDoorView.userInteractionEnabled = true
		openMyDoorView.closeTheDoorButton.userInteractionEnabled = true
		guestManagementView.userInteractionEnabled = true
	}
	
	
	
	// MARK: - SideBar custom actions
	/*override func nonAnimatedActionForSideBarAtIndexPath(indexPath: NSIndexPath) {
		if viewDisplayed != indexPath.row-1 && indexPath.row <= views.count
		{
			views[indexPath.row-1].frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.width)
		}
		
		// Set a + button if in GuestMode
		if indexPath.row == 2
		{
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem:")
		}
		else
		{
			self.navigationItem.rightBarButtonItem = nil
		}
		
	}
	// This method causes problems under half the screen... WHY?
	override func animatedActionForSideBarAtIndexPath(indexPath: NSIndexPath) {
		if viewDisplayed != indexPath.row-1 && indexPath.row <= views.count
		{
			views[viewDisplayed].center.x = -view.bounds.width/2
			views[indexPath.row-1].center.x = view.bounds.width/2
		}
	}
	override func nonAnimatedActionAfterAnimatedAcionForSideBarAtIndexPath(indexPath: NSIndexPath) {
		if viewDisplayed != indexPath.row-1 && indexPath.row <= views.count
		{
			views[viewDisplayed].center.x = -view.bounds.width/2
			views[indexPath.row-1].center.x = view.bounds.width/2
			viewDisplayed = indexPath.row-1
		}
	}*/
	
	override func nonAnimatedActionForSideBarAtIndexPath(indexPath: NSIndexPath) {
	if viewDisplayed != indexPath.row-1 && indexPath.row <= views.count
	{
		views[viewDisplayed].center.x = -view.bounds.width/2
		views[indexPath.row-1].center.x = view.bounds.width/2
		viewDisplayed = indexPath.row-1
	}
	
	// Set a + button if in GuestMode
	if indexPath.row == 2
	{
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem:")
	}
	else
	{
		self.navigationItem.rightBarButtonItem = nil
	}
	
	}
	
	
	
	// MARK: - UITableView
	override func numberOfSectionsInCustomTableView(tableView: UITableView) -> Int {
		switch tableView {
			default: return 1
		}
	}
	override func customTableView_numberOfRowInSection(tableView: UITableView, section: Int) -> Int {
		switch tableView {
			case guestManagementView.tableView:
				return guests.count
			case historyView.tableView:
				return historyView.actionHistory.actions.count
			default:
				return 0
		}
	}
	override func customTableView_heightForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat {
		return 90
	}
	override func customTableView_cellForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
		switch tableView {
			
			case guestManagementView.tableView:
				let cellIdentifier = "GuestTableViewCell"
				let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
				
				// Empty the cell before adding content
				let cellSubviews: [UIView] = cell.subviews
				for i in cellSubviews
				{
					i.removeFromSuperview()
				}
				
				let guest = guests[indexPath.row]
				
				let picture: UIImageView = UIImageView(image: guest.picture)
				let label = UILabel(frame: CGRect(x: 100, y: 30, width: cell.bounds.width-100, height: 30))
				picture.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
				label.text = guest.firstName + " " + guest.name
				cell.addSubview(picture)
				cell.addSubview(label)
				return cell
			
			case historyView.tableView:
				let cellIdentifier = "HistoryTableViewCell"
				let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
			
				let cellSubviews = cell.subviews
				for i in cellSubviews
				{
					i.removeFromSuperview()
				}
				let action = historyView.actionHistory.actions[indexPath.row]
				let label = UILabel(frame: CGRect(x: 10, y: 15, width: cell.bounds.width-50, height: 60))
				label.numberOfLines = 2
				label.lineBreakMode = .ByWordWrapping
				label.text = action.getDetails()
				cell.addSubview(label)
				return cell
			
			default: return UITableViewCell()
			
		}
		
	}
	override func customTableView_editActionsForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		switch tableView {
			case guestManagementView.tableView:
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
					self.guestManagementView.tableView.reloadData()
					self.performSegueWithIdentifier("Edit", sender: tableView.cellForRowAtIndexPath(indexPath))
				}
				// Set the button title and link it to its action
				let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: editClosure)
				editAction.backgroundColor = UIColor.orangeColor()
				
				return [deleteAction, editAction]
			
			case historyView.tableView:
				return []
			
			default:
				return []
		}
		
	}
	override func customTableView_didSelectRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath){
		switch tableView {
			case guestManagementView.tableView:
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
				self.performSegueWithIdentifier("ShowDetailTest", sender: tableView.cellForRowAtIndexPath(indexPath))
			
			default:
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
	}
	
	
	
	// MARK: NSCoding
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






































