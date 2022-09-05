//
//  Models.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import Foundation
import SwiftUI

class SetModel: ObservableObject, Identifiable {
    var id = UUID()
    @Published var reps = ""
    @Published var weight = ""
    @Published var latestReps = ""
    @Published var restTime = ""
    @Published var newReps = ""
    var number = 0
}

class SetModelSuperset: ObservableObject, Identifiable {
    var id = UUID()
    @Published var reps = ""
    @Published var weight = ""
    @Published var latestReps = ""
    @Published var newReps = ""
    var number = 0
}

class ExerciseModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: ExerciseModel, rhs: ExerciseModel) -> Bool {
        lhs.name == rhs.name
    }
    
    var id = UUID()
    @Published var name: String = ""
    @Published var sets: [SetModel] = [SetModel]()
    var day = ""
}

class ExerciseSupersetModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: ExerciseSupersetModel, rhs: ExerciseSupersetModel) -> Bool {
        lhs.sets.count != rhs.sets.count
    }
    
    var id = UUID()
    @Published var name: String = ""
    @Published var sets: [SetModelSuperset] = [SetModelSuperset]()
    var day = ""
    var exerciseOrder: Int = 0
    
    init(exerciseOrder: Int) {
        self.exerciseOrder = exerciseOrder
    }
}

class SupersetExercisesArray: ObservableObject {
    @Published var arrayOfSupersetExercises = [ExerciseSupersetModel]()
}
