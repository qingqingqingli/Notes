//
//  ViewController.swift
//  Notes
//
//  Created by Qing Li on 17/01/2022.
//

import UIKit
import CoreData
import UserNotifications

// MARK: - create protocol to set up note content
protocol PresentNoteContentDelegate: AnyObject {
    func presentNoteContent(note: Note)
}

class RootViewController: UIViewController {
    
    var tableView = UITableView()
    let reuseTableViewIdentifier = "notesCellReuse"
    let cellHeight: CGFloat = 70
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataManager.sharedManager.fetchAllNotes()
        
        self.view.backgroundColor = .white
        navigationItem.title = "All Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapNew))
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: reuseTableViewIdentifier)
        view.addSubview(tableView)
        
        setupViewConstraints()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc private func didTapNew() {
        let vc = NoteDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseTableViewIdentifier, for: indexPath) as? NoteTableViewCell {
            let note = notes[indexPath.row]
            cell.configure(note: note)
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

// MARK: - UITableViewDelegate
extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        let vc = NoteDetailsViewController()
        vc.selectedNote = selectedNote
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let selectedNote = notes[indexPath.row]
            CoreDataManager.sharedManager.delete(selectedNote)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}
