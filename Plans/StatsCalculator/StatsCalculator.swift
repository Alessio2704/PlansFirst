//
//  StatsCalculator.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 07/02/22.
//

import Foundation

class StatsCalculator {
    
    func calcRepsArray(exerciseStats: [StatDownloadApi]) -> [Double] {
        var repsArray = [Double]()
        for index in exerciseStats.indices {
            var sum = 0.0
            exerciseStats[index].sets.forEach { setApiStat in
                sum += Double(setApiStat.reps)
            }
            repsArray.append(sum)
            sum = 0.0
        }
        return repsArray
    }
    
    func calcWeightsArray(exerciseStats: [StatDownloadApi]) -> [Double] {
        var weightsArray = [Double]()
        for index in exerciseStats.indices {
            var maxWeight = 0.0
            exerciseStats[index].sets.forEach { setApiStat in
                if (Double(setApiStat.weight) ?? 0.0 > maxWeight) {
                    maxWeight = Double(setApiStat.weight) ?? 0.0
                }
            }
            weightsArray.append(maxWeight)
            maxWeight = 0.0
        }
        return weightsArray
    }
    
    

    func calcRestArray(exerciseStats: [StatDownloadApi]) -> [Double] {
        var restArray = [Double]()
        for index in exerciseStats.indices {
            var sum = 0.0
            exerciseStats[index].sets.forEach { setApiStat in
                sum += Double(setApiStat.restTime)
            }
            restArray.append(sum)
            sum = 0.0
        }
        return restArray
    }
    
    func calcVolumeArray(exerciseStats: [StatDownloadApi]) -> [Double] {
        var volumeArray = [Double]()
        
        for stat in exerciseStats {
            var sum = 0.0
            for setObj in stat.sets {
                sum += Double(setObj.reps) * Double(setObj.weight)!
            }
            
            volumeArray.append(sum)
        }
        return volumeArray
    }
    
    func calcFrequencyArray(exerciseStats: [StatDownloadApi]) -> [Double] {
        var frequencyArray = [Double]()
        for stat in exerciseStats {
            frequencyArray.append(Double(stat.frequency))
        }
        return frequencyArray
    }
}
