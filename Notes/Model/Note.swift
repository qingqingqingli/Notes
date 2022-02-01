//
//  CoreNote.swift
//  Notes
//
//  Created by Qing Li on 29/01/2022.
//

import CoreData

@objc(Note)
class Note: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var creationTime: Date?
    @NSManaged var deletedTime: Date?
}
