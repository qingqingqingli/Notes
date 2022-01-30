//
//  ViewController.swift
//  Notes
//
//  Created by Qing Li on 17/01/2022.
//

import UIKit
import CoreData

// MARK: - create protocol to set up note content
protocol PresentNoteContentDelegate: AnyObject {
    func presentNoteContent(note: Note)
}

class RootViewController: UIViewController {
    
    // define tableView
    var tableView = UITableView()
    let reuseTableViewIdentifier = "notesCellReuse"
    let cellHeight: CGFloat = 70
    
    var firstLoad = true
    
    func exsitingNotes() -> [Note] {
        var existingNotes: [Note] = []
        for note in notes {
            if (note.deletedTime == nil) {
                existingNotes.append(note)
            }
        }
        return existingNotes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (firstLoad) {
            firstLoad = false
            notes = CoreDataManager.sharedManager.fetchAllNotes()
        }
        
        self.view.backgroundColor = .white
        navigationItem.title = "All Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapNew))
        
        // MARK: - initialise tableView
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
    
    @objc func didTapNew() {
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
        return exsitingNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notes = exsitingNotes()
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
        let selectedNote = exsitingNotes()[indexPath.row]
        let vc = NoteDetailsViewController()
        vc.selectedNote = selectedNote
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
