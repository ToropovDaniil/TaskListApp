//
//  AppDelegate.swift
//  TaskListApp
//
//  Created by brubru on 23.11.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	private var storageManager = StorageManager.shared
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}
	
	// MARK: UISceneSession Lifecycle
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		storageManager.saveContext()
	}
}
