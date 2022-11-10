//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/23.
//

import XCTest
import CoreData
@testable import SwiftLint

class CoreDataHelperTests: XCTestCase {
    
    var helper: CoreDataHelper? =  nil
    
    override func setUp() {
        super.setUp()
        
        self.helper = CoreDataHelper("test", container: { name in
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            let container = NSPersistentContainer(name: name)
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        })
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testFindBy() {
        // helper.findBy(request: NSFetchRequest<User>)
        
        XCTAssertEqual(SwiftLint().text, "Hello, World!")
    }
    
}
