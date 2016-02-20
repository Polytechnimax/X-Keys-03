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
	var viewDisplayed: Int = 0
	
	
	// MARK: - Initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
		
		openMyDoorView = OpenMyDoorView(frame: view.frame)
		guestManagementView = GuestsManagementView(frame: CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height), superViewController: self)
		historyView = HistoryView(frame: CGRect(x: 2*view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height))
		views = [openMyDoorView, guestManagementView, historyView]
		view.addSubview(openMyDoorView)
		view.addSubview(guestManagementView)
		view.addSubview(historyView)
		
		// Set delegates
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
				let selectedGuest = guestManagementView.guests[indexPath.row]
				guestViewController.guestToEdit = selectedGuest
			}
		}
		else if segue.identifier == "ShowDetail"
		{
			let navigationController = segue.destinationViewController as! UINavigationController
			let guestDetailViewController = navigationController.childViewControllers[0] as! GuestDetailViewController
			if let selectedGuestCell = sender as? UITableViewCell
			{
				let indexPath = guestManagementView.tableView.indexPathForCell(selectedGuestCell)!
				let selectedGuest = guestManagementView.guests[indexPath.row]
				guestDetailViewController.guestToShow = selectedGuest
			}
		}
		else if segue.identifier == "ShowDetailTest"
		{
			let guestDetailViewController = segue.destinationViewController as! GuestDetailViewController
			if let selectedGuestCell = sender as? UITableViewCell
			{
				let indexPath = guestManagementView.tableView.indexPathForCell(selectedGuestCell)!
				let selectedGuest = guestManagementView.guests[indexPath.row]
				guestDetailViewController.guestToShow = selectedGuest
			}
		}
	}
	@IBAction func unwindToMainView(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.sourceViewController as? GuestEditingViewController, guest = sourceViewController.guestToEdit
		{
			// Checks if we have been adding (storedIndexPath == nil) or editing (storedIndexPath != nil) a guest
			if let selectedIndexPath = self.guestManagementView.storedIndexPath
			{
				// Update an existing guest
				guestManagementView.guests[selectedIndexPath.row] = guest
				guestManagementView.tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
				self.guestManagementView.storedIndexPath = nil
			}
				
			else
			{
				// Add a new guest
				let newIndexPath = NSIndexPath(forRow: guestManagementView.guests.count, inSection: 0)
				guestManagementView.guests.append(guest)
				guestManagementView.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
			}
			guestManagementView.saveGuests()
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
	// This method causes problems under half the screen... WHY?
	/*override func animatedActionForSideBarAtIndexPath(indexPath: NSIndexPath) {
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
}






































