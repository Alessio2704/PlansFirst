//
//  StatsEncoder.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 06/02/22.
//

import Foundation
import SwiftUI

class StatsEncoder {
    
    func encodeStats(exercise: Exercise, exerciseModel: ExerciseModel, exercises: FetchedResults<Exercise>) -> StatsUploadAPI {
        
        var statsUploadAPI = StatsUploadAPI()
        var statUploadAPI = StatUploadApi()
        statsUploadAPI.planName = exercise.plan?.name ?? ""
        statsUploadAPI.exerciseName = exercise.name ?? ""
        statsUploadAPI.exerciseDay = exercise.day ?? ""
        
        let exerciseArray = exercises.filter { $0.name ?? "" == exercise.name }

        statUploadAPI.frequency = exerciseArray.count
        
        for setModel in exerciseModel.sets {
            let setApiStats = SetApiStats(reps: Int(setModel.newReps) ?? 0, weight: setModel.weight.replacingOccurrences(of: ",", with: "."), restTime: Int(setModel.restTime) ?? 0, number: setModel.number)
            
            statUploadAPI.sets.append(setApiStats)
        }
        
        statsUploadAPI.stats = statUploadAPI
        
        return statsUploadAPI
    }
    
    func encodeStatsSuperset(exercise: Exercise,arraySupersetModel:[ExerciseSupersetModel]) -> UploadStatsSupersetApi {
        
        var uploadStatsSupersetApi = UploadStatsSupersetApi()
        uploadStatsSupersetApi.planName = exercise.plan?.name ?? ""
        uploadStatsSupersetApi.exerciseDay = exercise.day ?? ""
        uploadStatsSupersetApi.exerciseOrder = Int(exercise.rowOrder)
        
        for exerciseSupersetModel in arraySupersetModel {
            var supersetStatsApi = SupersetStatsApi()
            var supersetStatsUploadApi = SupersetStatsUploadApi()
            supersetStatsApi.exerciseName = exerciseSupersetModel.name
            supersetStatsApi.exerciseOrder = exerciseSupersetModel.exerciseOrder
            
            for index in exerciseSupersetModel.sets.indices {
                var supersetSetApiStats = SupersetSetApiStats()
                supersetSetApiStats.reps = Int(exerciseSupersetModel.sets[index].newReps) ?? 0
                supersetSetApiStats.weight = exerciseSupersetModel.sets[index].weight
                supersetSetApiStats.number = index + 1
                supersetStatsUploadApi.sets.append(supersetSetApiStats)
            }
            supersetStatsApi.stats = supersetStatsUploadApi
            uploadStatsSupersetApi.supersets.append(supersetStatsApi)
        }
        return uploadStatsSupersetApi
    }
}

