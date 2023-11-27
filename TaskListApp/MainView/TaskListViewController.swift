//
//  ViewController.swift
//  TaskListApp
//
//  Created by brubru on 23.11.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {
	private let storageManager = StorageManager.shared
	
	private let cellID = "task"
	private var taskList: [Task] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		view.backgroundColor = .white
		setupNavigationBar()
		fetchData()
	}
	
	@objc
	private func addNewTask() {
		showAlert(with: "New Task", and: "What do you want to do?")
	}
}

// MARK: - Private Methods
private extension TaskListViewController {
	func setupNavigationBar() {
		title = "Task List"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithOpaqueBackground()
		
		navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
		
		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addNewTask)
		)
		
		navigationController?.navigationBar.tintColor = .white
	}
	
	func showAlert(with title: String, and message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let saveAction = UIAlertAction(
			title: "Save Task",
			style: .default) { [unowned self] _ in
				guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
				
				storageManager.saveTask(task) { task in
					self.taskList.append(task)
					fetchData()
				}
			}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
		
		alert.addAction(saveAction)
		alert.addAction(cancelAction)
		alert.addTextField { textField in
			textField.placeholder = "NewTask"
		}
		
		present(alert, animated: true)
	}
	
	func deleteTask(at indexPath: IndexPath) {
		let task = taskList[indexPath.row]
		storageManager.deleteTask(task)
		
		taskList.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	func updateTask(_ task: Task, withTitle title: String) {
		storageManager.updateTask(task, withTitle: title)
		
		guard let index = taskList.firstIndex(of: task) else { return }
		taskList[index].title = title
		
		tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
	}
	
	func fetchData() {
		storageManager.fetchData { [weak self] taskList in
			self?.taskList = taskList
			DispatchQueue.main.async {
				self?.tableView.reloadData()
				
			}
		}
	}
}

extension TaskListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		taskList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		let task = taskList[indexPath.row]
		
		var content = cell.defaultContentConfiguration()
		content.text = task.title
		cell.contentConfiguration = content
		
		return cell
	}
	
	override func tableView(
		_ tableView: UITableView,
		commit editingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath) {
			
		if editingStyle == .delete {
			deleteTask(at: indexPath)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let task = taskList[indexPath.row]
		
		let alert = UIAlertController(title: "Edit Task", message: "Edit your task", preferredStyle: .alert)
		alert.addTextField { textField in
			textField.text = task.title
		}
		let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
			guard let title = alert.textFields?.first?.text, !title.isEmpty else { return }
			updateTask(task, withTitle: title)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
		alert.addAction(saveAction)
		alert.addAction(cancelAction)
		present(alert, animated: true)
	}
	
}

