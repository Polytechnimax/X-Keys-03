//
//  LockOpenerView.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 18/02/2016.
//  Copyright © 2016 LARCHER Maxime. All rights reserved.
//

import UIKit

class LockOpenerView : UIView, UITableViewDataSource, UITableViewDelegate
{
	// MARK: -- Properties
	var currentDate = NSDate()
	var lockTableView: UITableView!
	var lockArray: LockArray!
	
	
	
	// MARK: -- Initialisation
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		lockTableView = UITableView(frame: frame)
		lockTableView.delegate = self
		lockTableView.dataSource = self
	}
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	
	// MARK: -- UITableViewDelegate
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1 // Change this later, maybe we will have like "Personnal", "Work", "Friends"...
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return lockArray.lockArray.count
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 150
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let lock = lockArray.lockArray[indexPath.row]
		let cellIdentifier = "LockTableViewCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
		// Empty the cell before adding content
		let cellSubviews: [UIView] = cell.subviews
		for c in cellSubviews {c.removeFromSuperview()}
		let lockPicture: UIImageView = UIImageView(image: lock.image)
		lockPicture.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
		let lockNameLabel = UILabel(frame: CGRect(x: 160, y: 20, width: self.bounds.width - 170, height: 30))
		lockNameLabel.text = lock.name
		cell.addSubview(lockNameLabel)
		cell.addSubview(lockPicture)
		return cell
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}