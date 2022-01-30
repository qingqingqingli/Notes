//
//  CategoryNotesViewController.swift
//  Notes
//
//  Created by Qing Li on 17/01/2022.
//

import UIKit
import CoreData

var notes: [Note] = []

class NoteDetailsViewController: UIViewController {

    var titleField = UITextView()
    var contentField = UITextView()
    var saveButton = UIButton()
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (selectedNote != nil) {
            titleField.text = selectedNote?.title
            contentField.text = selectedNote?.content
        }
        
        self.view.backgroundColor = .white
        navigationItem.title = "Note Details"
        
        // set up titleField
        titleField.isScrollEnabled = false
        // did not work to wrap the text
        titleField.textContainer.lineBreakMode = .byCharWrapping
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.layer.borderWidth = 1
        titleField.layer.borderColor = UIColor.systemGray.cgColor
        titleField.layer.cornerRadius = 5
        titleField.autocorrectionType = .no
        titleField.font = UIFont.preferredFont(forTextStyle: .title3)
        
        // set up noteField
        contentField.translatesAutoresizingMaskIntoConstraints = false
        contentField.layer.borderWidth = 1
        contentField.layer.borderColor = UIColor.systemGray.cgColor
        contentField.layer.cornerRadius = 5
        contentField.autocorrectionType = .no
        contentField.font = UIFont.preferredFont(forTextStyle: .body)
        
        // set up save option on the right corner
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteButtonTapped))
        
        // set up deleteButton
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        view.addSubview(titleField)
        view.addSubview(contentField)
        view.addSubview(saveButton)
        
        setupConstraints()
        
    }
    
    @objc func deleteButtonTapped(_ sender: Any){
        if let note = selectedNote {
            CoreDataManager.sharedManager.delete(note)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func saveButtonTapped(_ sender: Any){
        CoreDataManager.sharedManager.save(
            selectedNote,
            title: titleField.text,
            content: contentField.text)
        navigationController?.popViewController(animated: true)
    }
    
    func setupConstraints(){
        let padding: CGFloat = 8
        let titleFieldHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            titleField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            titleField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            titleField.heightAnchor.constraint(equalToConstant: titleFieldHeight)
        ])
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalToConstant: titleFieldHeight),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
        NSLayoutConstraint.activate([
            contentField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            contentField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            contentField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: padding),
            contentField.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -padding)
        ])

    }
    
    
}