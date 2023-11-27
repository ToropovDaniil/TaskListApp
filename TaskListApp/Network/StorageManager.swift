//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Даниил Торопов on 26.11.2023.
//

import Foundation
import CoreData

final class StorageManager {
	static let shared = StorageManager()
	private let context: NSManagedObjectContext
	
	// MARK: - Core Data stack
	private var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "TaskListApp")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	private init() {
		context = persistentContainer.viewContext
	}
	
	func saveTask(_ taskName: String, completion: (Task) -> Void) {
		let task = Task(context: context)
		task.title = taskName
		
		completion(task)
		saveContext()
	}
	
	func deleteTask(_ task: Task) {
		context.delete(task)
		saveContext()
	}
	
	func updateTask(_ task: Task, withTitle title: String) {
		task.title = title
		saveContext()
	}
	
	func fetchData(completion: ([Task]) -> Void) {
		let fetchRequest = Task.fetchRequest()
		
		do {
			let taskList = try context.fetch(fetchRequest)
			completion(taskList)
		} catch {
			print("Faild to fetch data", error)
		}
	}
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
