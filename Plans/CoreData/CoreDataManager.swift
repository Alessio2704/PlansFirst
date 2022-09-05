//
//  CoreDataManager.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let moc = PersistenceController.shared.container.viewContext
    
    func saveChanges() {
        do {
            try moc.save()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    //MARK: Exercise
    
    func createExercise(name:String, exerciseModel: ExerciseModel, day: String, plan:Plan, exercises: FetchedResults<Exercise>) {
        
        let exerciseToCreate = Exercise(context: moc)
        exerciseToCreate.id = UUID()
        exerciseToCreate.name = name
        exerciseToCreate.day = day
        exerciseToCreate.rowOrder = (exercises.last?.rowOrder ?? 0) + 1
        exerciseToCreate.plan = plan
        
        for index in exerciseModel.sets.indices {
            let setToCreate = SetExercise(context: moc)
            setToCreate.id = UUID()
            setToCreate.reps = Int64(exerciseModel.sets[index].reps) ?? 0
            setToCreate.weight = Double(exerciseModel.sets[index].weight.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            setToCreate.restTime = Int64(exerciseModel.sets[index].restTime) ?? 0
            setToCreate.latestReps = 0
            setToCreate.number = Int64(index) + 1
            setToCreate.exercise = exerciseToCreate
        }
        saveChanges()
    }
    
    func updateExerciseSets(exercise:Exercise,exerciseModel: ExerciseModel) {
        
        for index in exerciseModel.sets.indices {
            if let setToEdit = getSet(id: exerciseModel.sets[index].id) {
                setToEdit.reps = Int64(exerciseModel.sets[index].reps) ?? 0
                setToEdit.weight = Double(exerciseModel.sets[index].weight.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                setToEdit.restTime = Int64(exerciseModel.sets[index].restTime) ?? 0
                setToEdit.number = Int64(index + 1)
                saveChanges()
            } else {
                let setToCreate = SetExercise(context: moc)
                setToCreate.id = UUID()
                setToCreate.exercise = exercise
                setToCreate.number = Int64(index + 1)
                setToCreate.reps = Int64(exerciseModel.sets[index].reps) ?? 0
                setToCreate.weight = Double(exerciseModel.sets[index].weight) ?? 0.0
                setToCreate.restTime = Int64(exerciseModel.sets[index].restTime) ?? 0
                saveChanges()
            }
        }
    }
    
    func deleteExercise(at offsets: IndexSet, exercises: FetchedResults<Exercise>) {
        for offset in offsets {
            let exercise = exercises[offset]
            moc.delete(exercise)
            saveChanges()
        }
    }
    
    func getExercise(id:UUID) -> Exercise? {
        let request:NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let results = try? self.moc.fetch(request)
        return results?.first
    }
    
    func moveExercises(from source:IndexSet, to destination:Int, exercises: FetchedResults<Exercise>) {
        if (source.first! > destination) {
            exercises[source.first!].rowOrder = exercises[destination].rowOrder - 1
            for i in destination ... exercises.count - 1 {
                exercises[i].rowOrder = exercises[i].rowOrder + 1
            }
        }
        if (source.first! < destination) {
            exercises[source.first!].rowOrder = exercises[destination - 1].rowOrder + 1
            for i in 0 ... destination - 1 {
                exercises[i].rowOrder = exercises[i].rowOrder - 1
            }
        }
        saveChanges()
    }
    
    func updateExerciseNotes(id:UUID, notes: String) {
        let exerciseToUpdate = getExercise(id: id)
        if let exerciseToUpdate = exerciseToUpdate {
            exerciseToUpdate.notes = notes
        }
        saveChanges()
    }
    
    //MARK: Set
    
    func getSet(id:UUID) -> SetExercise? {
        let request:NSFetchRequest<SetExercise> = SetExercise.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let results = try? self.moc.fetch(request)
        return results?.first
    }
    
    func updateLatestReps(setObj:SetModel) {
        
        let setToUpdate = getSet(id: setObj.id)
        
        if let setToUpdate = setToUpdate {
            if (setObj.newReps != "") {
                setToUpdate.latestReps = Int64(setObj.newReps) ?? 0
            }
        }
        saveChanges()
    }
    
    func updateWeight(setObj:SetModel) {
        
        let setToUpdate = getSet(id: setObj.id)
        
        if let setToUpdate = setToUpdate {
            setToUpdate.weight = Double(setObj.weight.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        }
        saveChanges()
    }
    
    func updateExerciseSet(exerciseModel: ExerciseModel) {
        
        for setModelExercise in exerciseModel.sets {
            updateWeight(setObj: setModelExercise)
            updateLatestReps(setObj: setModelExercise)
        }
    }
    
    func deleteSet(setID: UUID) {
        
        if let setToDelete = getSet(id: setID) {
            moc.delete(setToDelete)
            saveChanges()
        }
    }
    
    //MARK: Plan
    
    func createPlan(planName: String, planNotes: String, level:String) {
        let planToCreate = Plan(context: moc)
        planToCreate.id = UUID()
        planToCreate.name = planName
        planToCreate.notes = planNotes
        planToCreate.isCurrent = false
        planToCreate.level = level
        
        saveChanges()
    }
    
    func getPlan(id:UUID) -> Plan? {
        let request:NSFetchRequest<Plan> = Plan.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let results = try? self.moc.fetch(request)
        return results?.first
    }
    
    func getArrayPlan() -> [Plan]? {
        let fetchRequest: NSFetchRequest<Plan> = Plan.fetchRequest()

        do {
            let array = try moc.fetch(fetchRequest) as [Plan]
            return array
        } catch let errore {
            print("error FetchRequest \(errore)")
        }

        return nil
    }
    
    func updatePlanNotes(plan: Plan, notes: String) {
        let planToUpdate = getPlan(id: plan.id!)
        
        if let planToUpdate = planToUpdate {
            planToUpdate.notes = notes
        }
        saveChanges()
    }
    
    func updateIsCurrent(plan: Plan,isCurrent:Bool) {
        
        let planToUpdate = getPlan(id: plan.id!)
        
        if let planToUpdate = planToUpdate {
            if (planToUpdate.isCurrent != isCurrent) {
                planToUpdate.isCurrent = isCurrent
            }
        }
        saveChanges()
    }
    
    func updateIsCurrentAll() {

        guard let plans = getArrayPlan() else { return }
        
        for plan in plans {
            let planToUpdate = getPlan(id: plan.id!)
            planToUpdate?.isCurrent = false
            saveChanges()
        }
    }
    
    func deletePlan(plan:Plan) {
        moc.delete(plan)
        saveChanges()
    }
    
    func downloadPlan(plan:PlanApi) {
        let planToCreate = Plan(context: moc)
        planToCreate.id = UUID()
        planToCreate.name = plan.planName
        planToCreate.isCurrent = false
        planToCreate.notes = plan.notes
        planToCreate.level = plan.level
        
        for ex in plan.exercises {
            let exerciseToCreate = Exercise(context: moc)
            exerciseToCreate.id = UUID()
            exerciseToCreate.name = ex.name
            exerciseToCreate.day = ex.day
            exerciseToCreate.rowOrder = Int64(ex.rowOrder)
            
            for setOBJApi in ex.sets {
                let setToCreate = SetExercise(context: moc)
                setToCreate.id = UUID()
                setToCreate.reps = Int64(setOBJApi.reps)
                setToCreate.weight = Double(setOBJApi.weight) ?? 0.0
                setToCreate.restTime = Int64(setOBJApi.restTime)
                setToCreate.latestReps = Int64(setOBJApi.latestReps ?? 0)
                setToCreate.number = Int64(setOBJApi.number)
                setToCreate.exercise = exerciseToCreate
            }
            
            exerciseToCreate.plan = planToCreate
        }
        
        for supersetExercise in plan.supersets {
            let exerciseToCreate = Exercise(context: moc)
            exerciseToCreate.id = UUID()
            exerciseToCreate.name = "Superset"
            exerciseToCreate.restTime = Int64(supersetExercise.restTime)
            exerciseToCreate.day = supersetExercise.day
            exerciseToCreate.rowOrder = Int64(supersetExercise.exerciseOrder)
            
            for superset in supersetExercise.supersets {
                let supersetToCreate = Superset(context: moc)
                supersetToCreate.id = UUID()
                supersetToCreate.exerciseName = superset.exerciseName
                supersetToCreate.exerciseOrder = Int64(superset.exerciseOrder)
                
                for superserSet in superset.sets {
                    let setToCreate = SetExercise(context: moc)
                    setToCreate.id = UUID()
                    setToCreate.reps = Int64(superserSet.reps)
                    setToCreate.weight = Double(superserSet.weight) ?? 0.0
                    setToCreate.latestReps = Int64(superserSet.latestReps)
                    setToCreate.number = Int64(superserSet.number)
                    setToCreate.superset = supersetToCreate
                    setToCreate.exercise = exerciseToCreate
                }
                supersetToCreate.exercise = exerciseToCreate
            }
            exerciseToCreate.plan = planToCreate
        }
    }
    
    //MARK: Superset
    
    func createSuperset(arrayOfExerciseModels: [ExerciseSupersetModel],exercises: FetchedResults<Exercise>, day:String, plan: Plan, restTime: Double) {
        
        let exerciseToCreate = Exercise(context: moc)
        exerciseToCreate.id = UUID()
        exerciseToCreate.name = "Superset"
        exerciseToCreate.day = day
        exerciseToCreate.plan = plan
        exerciseToCreate.restTime = Int64(restTime)
        exerciseToCreate.rowOrder = (exercises.last?.rowOrder ?? 0) + 1
        
        for model in arrayOfExerciseModels {
            let supersetToCreate = Superset(context: moc)
            supersetToCreate.id = UUID()
            supersetToCreate.exerciseName = model.name
            supersetToCreate.exerciseOrder = Int64(model.exerciseOrder)
            
            for index in model.sets.indices {
                let setToCreate = SetExercise(context: moc)
                setToCreate.id = UUID()
                setToCreate.reps = Int64(model.sets[index].reps) ?? 0
                setToCreate.weight = Double(model.sets[index].weight.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                setToCreate.latestReps = 0
                setToCreate.number = Int64(index + 1)
                setToCreate.superset = supersetToCreate
                
            }
            
            supersetToCreate.exercise = exerciseToCreate
        }
        
        saveChanges()
    }
    
    func updateLatestRepsSuperset(setObj:SetModelSuperset) {
        
        let setToUpdate = getSet(id: setObj.id)
        
        if let setToUpdate = setToUpdate {
            if (setObj.newReps != "") {
                setToUpdate.latestReps = Int64(setObj.newReps) ?? 0
            }
        }
        saveChanges()
    }
    
    func updateWeightSuperset(setObj:SetModelSuperset) {
        
        let setToUpdate = getSet(id: setObj.id)
        
        if let setToUpdate = setToUpdate {
            setToUpdate.weight = Double(setObj.weight.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        }
        saveChanges()
    }
    
    func updateSupersetSets(exerciseSupersetModel: ExerciseSupersetModel) {
        
        for setModelExercise in exerciseSupersetModel.sets {
            updateWeightSuperset(setObj: setModelExercise)
            updateLatestRepsSuperset(setObj: setModelExercise)
        }
    }
    
    func updateAllSupersetExercisesSets(exerciseSupersetModelArray:[ExerciseSupersetModel]) {
        for exerciseSupersetModel in exerciseSupersetModelArray {
            updateSupersetSets(exerciseSupersetModel: exerciseSupersetModel)
        }
    }
    
    func updateRestTimeSuperset (id:UUID, restTime: Int64) {
        let exerciseToUpdate = getExercise(id: id)
        
        if let exerciseToUpdate = exerciseToUpdate {
            exerciseToUpdate.restTime = restTime
        }
        
        saveChanges()
    }
    
    func editSingleSupersetExerciseSets(exercise:Exercise,supersetModel: ExerciseSupersetModel) {
        
        for index in supersetModel.sets.indices {
            if let setToEdit = getSet(id: supersetModel.sets[index].id) {
                setToEdit.reps = Int64(supersetModel.sets[index].reps) ?? 0
                setToEdit.weight = Double(supersetModel.sets[index].weight.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                setToEdit.number = Int64(index + 1)
                
            } else {
                let setToCreate = SetExercise(context: moc)
                setToCreate.id = UUID()
                setToCreate.exercise = exercise
                let supersetsDB = exercise.supersets?.allObjects as? [Superset] ?? [Superset]()
                setToCreate.superset = supersetsDB.first(where: { $0.exerciseName == supersetModel.name })
                setToCreate.number = Int64(index + 1)
                setToCreate.reps = Int64(supersetModel.sets[index].reps) ?? 0
                setToCreate.weight = Double(supersetModel.sets[index].weight) ?? 0.0

            }
        }
        saveChanges()
    }
}

