//
//  UserDefaults.swift
//  Meshtastic
//
//  Copyright(c) Garth Vander Houwen 4/24/23.
//

import Foundation

extension UserDefaults {
	enum Keys: String, CaseIterable {
		case enableRangeTest
		case preferredPeripheralId
		case preferredPeripheralNum
		case provideLocation
		case provideLocationInterval
		case mapLayer
		case meshMapRecentering
		case meshMapShowNodeHistory
		case meshMapShowRouteLines
		case enableMapConvexHull
		case enableMapTraffic
		case enableMapPointsOfInterest
		case enableOfflineMaps
		case mapTileServer
		case mapTilesAboveLabels
		case mapUseLegacy
		case enableDetectionNotifications
		case detectionSensorRole
	}

	func reset() {
		Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
	}
	static var blockRangeTest: Bool {
		get {
			UserDefaults.standard.bool(forKey: "blockRangeTest") 
		} set {
			UserDefaults.standard.set(newValue, forKey: "blockRangeTest")
		}
	}
	static var preferredPeripheralId: String {
		get {
			UserDefaults.standard.string(forKey: "preferredPeripheralId") ?? ""
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "preferredPeripheralId")
		}
	}
	static var preferredPeripheralNum: Int {
		get {
			UserDefaults.standard.integer(forKey: "preferredPeripheralNum")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "preferredPeripheralNum")
		}
	}
	static var provideLocation: Bool {
		get {
			UserDefaults.standard.bool(forKey: "provideLocation")
		} set {
			UserDefaults.standard.set(newValue, forKey: "provideLocation")
		}
	}
	static var provideLocationInterval: Int {
		get {
			UserDefaults.standard.integer(forKey: "provideLocationInterval")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "provideLocationInterval")
		}
	}
	static var mapLayer: MapLayer {
		get {
			MapLayer(rawValue: UserDefaults.standard.string(forKey: "mapLayer") ?? MapLayer.standard.rawValue) ?? MapLayer.standard
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: "mapLayer")
		}
	}
	static var enableMapRecentering: Bool {
		get {
			UserDefaults.standard.bool(forKey: "meshMapRecentering")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "meshMapRecentering")
		}
	}
	static var enableMapNodeHistoryPins: Bool {
		get {
			UserDefaults.standard.bool(forKey: "meshMapShowNodeHistory")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "meshMapShowNodeHistory")
		}
	}
	static var enableMapRouteLines: Bool {
		get {
			UserDefaults.standard.bool(forKey: "meshMapShowRouteLines")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "meshMapShowRouteLines")
		}
	}
	static var enableMapConvexHull: Bool {
		get {
			UserDefaults.standard.bool(forKey: "enableMapConvexHull")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "enableMapConvexHull")
		}
	}
	static var enableMapTraffic: Bool {
		get {
			UserDefaults.standard.bool(forKey: "enableMapTraffic")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "enableMapTraffic")
		}
	}
	static var enableMapPointsOfInterest: Bool {
		get {
			UserDefaults.standard.bool(forKey: "enableMapPointsOfInterest")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "enableMapPointsOfInterest")
		}
	}
	static var enableOfflineMaps: Bool {
		get {
			UserDefaults.standard.bool(forKey: "enableOfflineMaps")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "enableOfflineMaps")
		}
	}
	static var enableOfflineMapsMBTiles: Bool {
		get {
			UserDefaults.standard.bool(forKey: "enableOfflineMapsMBTiles")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "enableOfflineMapsMBTiles")
		}
	}
	static var mapTileServer: MapTileServer {
		get {
			MapTileServer(rawValue: UserDefaults.standard.string(forKey: "mapTileServer") ?? MapTileServer.openStreetMap.rawValue) ?? MapTileServer.openStreetMap
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: "mapTileServer")
		}
	}
	static var enableOverlayServer: Bool {
		get {
			UserDefaults.standard.bool(forKey: "enableOverlayServer")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "enableOverlayServer")
		}
	}
	static var mapOverlayServer: MapOverlayServer {
		get {
			MapOverlayServer(rawValue: UserDefaults.standard.string(forKey: "mapOverlayServer") ?? MapOverlayServer.baseReReflectivityCurrent.rawValue) ?? MapOverlayServer.baseReReflectivityCurrent
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: "mapOverlayServer")
		}
	}
	static var mapTilesAboveLabels: Bool {
		get {
			UserDefaults.standard.bool(forKey: "mapTilesAboveLabels")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "mapTilesAboveLabels")
		}
	}
	
	static var mapUseLegacy: Bool {
		get {
			UserDefaults.standard.bool(forKey: "mapUseLegacy")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "mapUseLegacy")
		}
	}
	
	static var enableDetectionNotifications: Bool {
		get {
			UserDefaults.standard.bool(forKey: "enableDetectionNotifications")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "enableDetectionNotifications")
		}
	}
	
	static var detectionSensorRole: DetectionSensorRole {
		get {
			DetectionSensorRole(rawValue: UserDefaults.standard.string(forKey: "detectionSensorRole") ?? DetectionSensorRole.sensor.rawValue) ?? DetectionSensorRole.sensor
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: "detectionSensorRole")
		}
	}
}
