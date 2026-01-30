//
//  DayRecord+CoreDataProperties.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 29.01.2026.
//
//

import Foundation
import CoreData


public typealias DayRecordCoreDataPropertiesSet = NSSet

extension DayRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayRecord> {
        return NSFetchRequest<DayRecord>(entityName: "DayRecord")
    }

    @NSManaged public var date: Date?
    @NSManaged public var energy: Int16
    @NSManaged public var isPeriodDay: Bool
    @NSManaged public var mood: Int16
    @NSManaged public var painLevel: Int16

}

extension DayRecord : Identifiable {

}
