//
//  BluetoothManager.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 08/02/2016.
//  Copyright © 2016 LARCHER Maxime. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate
{
	// MARK: -- Peripheral related properties
	let RBL_SERVICE_UUID = "713D0000-503E-4C75-BA94-3148F18D941E"
	let RBL_CHAR_TX_UUID = "713D0002-503E-4C75-BA94-3148F18D941E"
	let RBL_CHAR_RX_UUID = "713D0003-503E-4C75-BA94-3148F18D941E"
	let nameOfPeripheralToConnect = "BLE Shield"
	let KEY = 012343210 // The Key to identify, basic for now, need to be improved
	var activePeripheral: CBPeripheral?
	var characteristics = [String : CBCharacteristic]()
	
	
	
	// MARK: -- Properties
	var centralManager: CBCentralManager!
	
	
	
	// MARK: -- Initialisation
	override init() {
		super.init()
		centralManager = CBCentralManager(delegate: self, queue: nil)
		activePeripheral = nil
	}
	
	
	
	// MARK: -- CBCentralManagerDelegate
	func centralManagerDidUpdateState(central: CBCentralManager) {
		
	}
	func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
		let nameOfPeripheral = peripheral.name
		if nameOfPeripheral == nameOfPeripheralToConnect
		{
			print("Discovered BLE Shield")
			centralManager.stopScan()
			print("Scanning stopped")
			print("Attempting to connect")
			activePeripheral = peripheral
			activePeripheral?.delegate = self
			centralManager.connectPeripheral(activePeripheral!, options: nil)
	}
}
	func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
		print("Connected successfuly")
		activePeripheral?.discoverServices([CBUUID(string: RBL_SERVICE_UUID)])
	}
	func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
		print("Disconnected from peripheral")
		activePeripheral = nil
	}
	func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
		print("Failed to connect to peripheral")
}
	
	
	
	// MARK: -- PeripheralDelegate
	func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
		if error != nil
		{
			print("Erreur lors de la découverte de services")
		}
		else
		{
			for service in peripheral.services! as [CBService]!
			{
				let theCharacteristics = [CBUUID(string: RBL_CHAR_RX_UUID), CBUUID(string: RBL_CHAR_TX_UUID)]
				peripheral.discoverCharacteristics(theCharacteristics, forService: service)
			}
		}
	}
	func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
		
		if error != nil {
			print("Erreur lors de la découverte de caractéristiques de services")
		}
		else
		{
			for characteristic in service.characteristics! as [CBCharacteristic] {
				
				self.characteristics[characteristic.UUID.UUIDString] = characteristic
			}
		}
	}
	
	
	
	// MARK: -- Communication
	func scan() {
		centralManager.scanForPeripheralsWithServices(nil, options: nil)
		print("Started scanning")
	}
	func sendRequest(type: String, value: Int?, key: Int)
	{
		let stringToSend = type + "\n" + String(value) + "\n" + String(key)
		for character in stringToSend.characters
		{
			let bytesToSend: [Character] = [character]
			let data = NSData(bytes: bytesToSend, length: bytesToSend.count)
			self.activePeripheral?.writeValue(data, forCharacteristic: self.characteristics[RBL_CHAR_RX_UUID]!, type: .WithoutResponse)
		}
	}
}






























