//
//  CurrentPlanManager.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import Foundation
import CoreData
import SwiftUI

class CurrentPlanManager: ObservableObject {
    @Published var isCurrentPlan = [Plan]()
    let moc = PersistenceController.shared.container.viewContext
    
    init() {
        let request = NSFetchRequest<Plan>(entityName: "Plan")
        let sort = NSSortDescriptor(keyPath: \Plan.isCurrent, ascending: false)
        let filter = NSPredicate(format: "isCurrent == %@", NSNumber(value: true))
        request.sortDescriptors = [sort]
        request.predicate = filter
        
        do {
            self.isCurrentPlan = try moc.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

