//
//  StatsCalculatorSupersets.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 01/03/22.
//

import Foundation

import Foundation

class StatsCalculatorSupersets {
    
    func calcRepsArray(supersetStats: [StatsSupersetApiResult]) -> [Double] {
        var repsArray = [Double]()
        for index in supersetStats.indices {
            var sum = 0.0
            supersetStats[index].sets.forEach { setApiStat in
                sum += Double(setApiStat.reps)
            }
            repsArray.append(sum)
            sum = 0.0
        }
        return repsArray
    }
    
    func calcWeightsArray(supersetStats: [StatsSupersetApiResult]) -> [Double] {
        var weightsArray = [Double]()
        for index in supersetStats.indices {
            var maxWeight = 0.0
            supersetStats[index].sets.forEach { setApiStat in
                if (Double(setApiStat.weight) ?? 0.0 > maxWeight) {
                    maxWeight = Double(setApiStat.weight) ?? 0.0
                }
            }
            weightsArray.append(maxWeight)
            maxWeight = 0.0
        }
        return weightsArray
    }
    
    

    func calcRestArray(supersetStats: [StatsSupersetApiResult], exercise:Exercise) -> [Double] {
        var restArray = [Double]()
        for index in supersetStats.indices {
            var sum = 0.0
            supersetStats[index].sets.forEach { setApiStat in
                sum += Double(exercise.restTime)
            }
            restArray.append(sum)
            sum = 0.0
        }
        return restArray
    }
    
    func calcVolumeArray(supersetStats: [StatsSupersetApiResult]) -> [Double] {
        var volumeArray = [Double]()
        for stat in supersetStats {
            var sum = 0.0
            for setObj in stat.sets {
                sum += Double(setObj.reps) * Double(setObj.weight)!
            }
            
            volumeArray.append(sum)
        }
        return volumeArray
    }
}
