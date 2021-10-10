//
//  SaveNote+CoreDataProperties.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 10/10/2021.
//
//

import Foundation
import CoreData


extension SaveNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaveNote> {
        return NSFetchRequest<SaveNote>(entityName: "SaveNote")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension SaveNote : Identifiable {

}
