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
    static let sharedManager = CoreDataManager()
    
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
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // TODO: Change the delete logic
    func delete(_ selectedNote: Note){
        let context: NSManagedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let note = result as! Note
                if (note == selectedNote) {
                    note.deletedTime = Date()
                    try context.save()
                }
            }
        } catch {
            print("Fetch failed")
        }
    }
    
    // TODO: Change the save logic
    func save(_ selectedNote: Note?, title: String, content: String) {
        let context: NSManagedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        // create a new note
        if (selectedNote == nil) {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = notes.count as NSNumber
            newNote.title = title
            newNote.content = content
            newNote.creationTime = Date()
            do {
                try context.save()
                notes.append(newNote)
            }
            catch {
                print("context save error")
            }
        }
        // edit an existing note
        else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Note
                    if (note == selectedNote) {
                        note.title = title
                        note.content = content
                        note.creationTime = Date()
                        try context.save()
                    }
                }
            } catch {
                print("Fetch failed")
            }
        }
    }
    
    func fetchAllNotes() -> [Note] {
        var notes: [Note] = []
        let context: NSManagedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let note = result as! Note
                notes.append(note)
            }
        } catch {
            print("Fetch failed")
        }
        return notes
    }
}