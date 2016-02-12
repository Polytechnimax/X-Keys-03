//
//  ViewController.swift
//  bluredSideBar
//
//  Created by LARCHER Maxime on 26/10/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class BluredSideBarViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource{

	
	
	// MARK: Properties
	// Views
	var secondaryViewIsHidden = true
	var secondaryView: UIView!
	var bluredView: UIVisualEffectView!
	var sideBarTableView: UITableView!
	
	// Effects
	var blurEffect: UIBlurEffect!
	
	// Gesture recognizers
	var screenLeftEdgeSwiper: UIScreenEdgePanGestureRecognizer!
	var rightPanSwiper: UISwipeGestureRecognizer!
	
	// Data storage
	var sideBarMenus: [String] = ["Ouvrir ma porte", "Mes invités","Historique"]
	var segueIdentifiers: [String] = []
	
	
	
	// MARK: - Initialisation
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Initialize different views
		secondaryView = UIView(frame: CGRect(x: -view.bounds.width*3/4, y: 64, width: view.bounds.width*3/4, height: view.bounds.height - 64))
		
		blurEffect = UIBlurEffect(style: .Light)
		bluredView = UIVisualEffectView(effect: blurEffect)
		bluredView.frame = CGRect(x: 0, y: 0, width: secondaryView.bounds.width, height: secondaryView.bounds.height)
		sideBarTableView = UITableView(frame: CGRect(x: 0, y: 0, width: secondaryView.bounds.width, height: secondaryView.bounds.height))
		sideBarTableView.backgroundColor = .None
		
		// Add everything to the secondaryView
		secondaryView.addSubview(bluredView)
		secondaryView.addSubview(sideBarTableView)
		// Add the secondaryView to the view
		//view.addSubview(secondaryView)
		
		// Initialize left swiper
		screenLeftEdgeSwiper = UIScreenEdgePanGestureRecognizer(target: self, action: "screenEdgeSwipe:")
		screenLeftEdgeSwiper.edges = UIRectEdge.Left
		screenLeftEdgeSwiper.delegate = self
		view.addGestureRecognizer(screenLeftEdgeSwiper)
		
		// Initialize right swiper
		rightPanSwiper = UISwipeGestureRecognizer(target: self, action: "rightBackswipe:")
		rightPanSwiper.delegate = self
		view.addGestureRecognizer(rightPanSwiper)
		rightPanSwiper.enabled = false
		rightPanSwiper.direction = UISwipeGestureRecognizerDirection.Left
		
		// Fill tableView
		sideBarTableView.delegate = self
		sideBarTableView.dataSource = self
		sideBarTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SideBarTitle")
		sideBarTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SideBarMenu")
	}

	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
		view.addSubview(secondaryView)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	
	// MARK: Action
	func screenEdgeSwipe(sender: UIScreenEdgePanGestureRecognizer)
	{
		if secondaryViewIsHidden
		{
			UIView.animateWithDuration(0.5, animations: {
				self.secondaryView.center.x += self.secondaryView.bounds.width
			})
			secondaryViewIsHidden = false
			rightPanSwiper.enabled = true
			screenLeftEdgeSwiper.enabled = false
			forbideUserInteraction()
		}
	}
	
	func rightBackswipe(sender: UIPanGestureRecognizer)
	{
		if !secondaryViewIsHidden
		{
			UIView.animateWithDuration(0.5, animations: {
				self.secondaryView.center.x -= self.secondaryView.bounds.width
			})
			secondaryViewIsHidden = true
			rightPanSwiper.enabled = false
			screenLeftEdgeSwiper.enabled = true
			allowUserInteraction()
		}
	}
	
	
	
	// MARK: - User interaction removal
	// Override this function to remove user interaction of some elements while side bar is open
	func forbideUserInteraction()
	{
		
	}
	// Override this function to give him back interaction
	func allowUserInteraction()
	{
		
	}
	
	
	
	// MARK: UITableView
	// These functions MUST NOT be overrided or changed : on them relies the side bar tableView management
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		if tableView == self.sideBarTableView
		{
			if indexPath.row == 0
			{
				let cellIdentifier = "SideBarTitle"
				let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
				
				cell.backgroundColor = .None
				cell.textLabel?.font = UIFont.systemFontOfSize(30)
				cell.textLabel?.text = "X-Keys"
				cell.userInteractionEnabled = false
				return cell
			}
			else
			{
				
				let cellIdentifier = "SideBarMenu"
				let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
				
				cell.backgroundColor = .None
				cell.textLabel?.text = sideBarMenus[indexPath.row-1]
				return cell
			}
		}
		
		else
		{
			//return UITableViewCell()
			return customTableView_cellForRowAtIndexPath(tableView, indexPath: indexPath)
		}
	}
	func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		if tableView == self.sideBarTableView
		{
			return 1
		}
		else
		{
			return numberOfSectionsInCustomTableView(tableView)
		}
	}
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if tableView == self.sideBarTableView
		{
			print("Checking for side bar table")
			return 1 + sideBarMenus.count
		}
		else
		{
			print("Checking for custom tables")
			return customTableView_numberOfRowInSection(tableView, section: section)
		}
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if tableView == self.sideBarTableView
		{
			if indexPath.row == 0
			{
				return 70
			}
			else
			{
				return 45
			}
		}
		else
		{
			return customTableView_heightForRowAtIndexPath(tableView, indexPath: indexPath)
			//return customTableView_heightForRowAtIndexPath(tableView, indexPath: indexPath)
		}
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if tableView == self.sideBarTableView
		{
			nonAnimatedActionForSideBarAtIndexPath(indexPath)
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
			
			if !secondaryViewIsHidden
			{
				UIView.animateWithDuration(0.5, animations: {
					self.secondaryView.center.x -= self.secondaryView.bounds.width
					self.animatedActionForSideBarAtIndexPath(indexPath)
				})
				secondaryViewIsHidden = true
				rightPanSwiper.enabled = false
				screenLeftEdgeSwiper.enabled = true
			}
			
		}
		else
		{
			customTableView_didSelectRowAtIndexPath(tableView, indexPath: indexPath)
		}
		allowUserInteraction()
	}
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		if tableView == self.sideBarTableView
		{
			return false
		}
		else
		{
			return customTableView_canEditRowAtIndexPath(tableView, indexPath: indexPath)
		}
	}
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		if tableView == self.sideBarTableView
		{
			return[]
		}
		else
		{
			return customTableView_editActionsForRowAtIndexPath(tableView, indexPath: indexPath)
		}
	}
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
		if tableView != self.sideBarTableView
		{
			customTableView_commitEditingStyle_forRowAtIndexPath(tableView, editingStyle: editingStyle, indexPath: indexPath)
		}
	}
	
	
	
	// MARK: - Custom Actions
	func animatedActionForSideBarAtIndexPath(indexPath: NSIndexPath)
	{
		
	}
	func nonAnimatedActionForSideBarAtIndexPath(indexPath: NSIndexPath)
	{
		
	}
	func nonAnimatedActionAfterAnimatedAcionForSideBarAtIndexPath(indexPath: NSIndexPath){
		
	}
	
	
	
	// MARK: - Custom TableViews
	// If you wish to create your own table view override these functions
	func customTableView_cellForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell
	{
		return UITableViewCell()
	}
	func numberOfSectionsInCustomTableView(tableView: UITableView) -> Int
	{
		return 1
	}
	func customTableView_numberOfRowInSection(tableView: UITableView, section: Int) -> Int
	{
		return 0
	}
	func customTableView_heightForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat
	{
		return 45
	}
	func customTableView_didSelectRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath)
	{
		
	}
	func customTableView_editActionsForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> [UITableViewRowAction]?
	{
		return []
	}
	func customTableView_canEditRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> Bool
	{
		return true
	}
	func customTableView_commitEditingStyle_forRowAtIndexPath(tableView: UITableView, editingStyle: UITableViewCellEditingStyle, indexPath : NSIndexPath)
	{
		
	}
}
































