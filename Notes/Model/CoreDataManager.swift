//
//  CoreDataManager.swift
//  Notes
//
//  Created by Qing Li on 30/01/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Singleton
    static let shared = CoreDataManager()
    
    private(set) var notes = [Note]()
    
    // MARK: - Avoid additional initialization
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
        
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Note operations
    func delete(_ note: Note){
        let context = persistentContainer.viewContext
        context.delete(note)
        do {
            try context.save()
            fetchAllNotes()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func createNote(title: String, content: String) {
        let context = persistentContainer.viewContext
        let newNote = Note(context: context)
        newNote.id = UUID().uuidString
        newNote.title = title
        newNote.content = content
        newNote.creationTime = Date()
        do {
            try context.save()
            fetchAllNotes()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateNote(note: Note, title: String, content: String) {
        let context = persistentContainer.viewContext
        note.title = title
        note.content = content
        do {
            try context.save()
            fetchAllNotes()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(_ selectedNote: Note?, title: String, content: String) {
        if (selectedNote == nil) {
            createNote(title: title, content: content)
        }
        else {
            updateNote(note: selectedNote!, title: title, content: content)
        }
    }
    
    func fetchAllNotes() {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            notes = try context.fetch(request) as? [Note] ?? []
        } catch let error as NoteError {
            if case .notFound = error {
                print("Not found!")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

enum NoteError: Error {
    case notFound
}
