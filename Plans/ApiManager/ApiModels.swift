//
//  ApiModels.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import Foundation

enum NetworkingError: LocalizedError {
    case custom(message:String)
}

struct registerBody: Encodable {
    let name:String
    let email:String
    let password:String
}

struct authRespone: Decodable {
    let userID:String?
    let token:String?
    let name:String?
    let message:String?
}

struct loginBody: Encodable {
    let email:String
    let password:String
}

struct publicExercise: Decodable, Hashable {
    let exerciseName: String
}

extension NetworkingError {
    public var errorDescription: String? {
        switch self {
        case .custom(message: let message):
            return "\(message)"
        }
    }
}

struct SetApi: Decodable, Encodable {
    var reps: Int = 0
    var weight: String = ""
    var restTime: Int = 0
    var latestReps: Int? = 0
    var number: Int = 0
}

struct StatsApi : Decodable, Encodable {
    var date: String = ""
    var sets: [SetApi] = []
    var frequency: Int = 0
    
    private enum CodingKeys : String, CodingKey {
        case date, sets, frequency
    }
    
}

struct ExerciseApi: Decodable, Encodable, Identifiable {
    var id = UUID()
    var name: String = ""
    var day: String = ""
    var sets: [SetApi] = []
    var rowOrder: Int = 0
    var stats: [StatsApi] = []
    
    private enum CodingKeys : String, CodingKey {
        case name, day, sets, rowOrder, stats
    }
    
}

struct SetSupersetApi: Decodable, Encodable {
    var reps: Int = 0
    var weight: String = ""
    var latestReps: Int = 0
    var number: Int = 0
}

struct SupersetApi: Decodable, Encodable {
    
    var exerciseName: String = ""
    var sets: [SetSupersetApi] = []
    var exerciseOrder: Int = 0
}

struct SupersetExerciseApi: Decodable, Encodable {
    
    var supersets: [SupersetApi] = []
    var exerciseOrder: Int = 0
    var day: String = ""
    var restTime: Int = 0
}

struct PlanApi: Decodable, Encodable, Identifiable {
    let id = UUID()
    var planName: String = ""
    var exercises: [ExerciseApi] = []
    var supersets: [SupersetExerciseApi] = []
    var notes: String = ""
    var level: String = ""
    private enum CodingKeys : String, CodingKey {
        case planName, exercises, supersets, notes, level
    }
}

struct PlanNameStructAPI: Codable {
    var planName: String = ""
}

struct SetApiStats: Encodable,Decodable {
    var reps: Int = 0
    var weight: String = ""
    var restTime: Int = 0
    var number: Int = 0
}

struct StatUploadApi: Encodable {
    var sets: [SetApiStats] = []
    var frequency: Int = 0
    
}

struct StatDownloadApi: Identifiable, Decodable {
    var id: UUID = UUID()
    var sets: [SetApiStats] = []
    var date: String = ""
    var frequency: Int = 0
    
    private enum CodingKeys : String, CodingKey {
        case sets,date,frequency
    }
}

struct StatExerciseBodyApi: Encodable {
    var planName: String = ""
    var exerciseName: String = ""
    var exerciseDay: String = ""
}

struct StatsUploadAPI: Encodable {
    var planName: String = ""
    var exerciseName: String = ""
    var exerciseDay: String = ""
    var stats: StatUploadApi = StatUploadApi()
}

struct deleteExerciseApiModel: Encodable {
    var planName: String = ""
    var exerciseName: String = ""
    var exerciseDay: String = ""
    var rowOrder: Int = 0
}

struct addExerciseApiModel: Encodable {
    
    var planName: String = ""
    var exerciseName: String = ""
    var day: String = ""
    var sets: [SetApi] = [SetApi]()
    var rowOrder: Int = 0
}

struct addSupersetApiModel: Encodable {
    
    var planName: String = ""
    var exerciseName: String = ""
    var supersets: [SupersetApi] = []
    var exerciseOrder: Int = 0
    var day: String = ""
    var restTime: Int = 0
}

struct PublishedPlanApi: Decodable, Encodable, Identifiable {
    let id = UUID()
    var planName: String = ""
    var exercises: [ExerciseApi] = []
    var supersets: [SupersetExerciseApi] = []
    var likes: Int = 0
    var downloads: Int = 0
    var level: String = ""
    private enum CodingKeys : String, CodingKey {
        case planName, exercises, supersets, likes, downloads, level
    }
}

struct PublicPlanInfoApi: Decodable, Encodable, Identifiable {
    
    let id: UUID = UUID()
    var planId: String = ""
    var planName:String = ""
    var likes:Int = 0
    var downloads:Int = 0
    var createdBy:String = ""
    var workoutDays: Int = 0
    var level: String = ""
    
    private enum CodingKeys : String, CodingKey {
        case planId,planName,likes,downloads,createdBy,workoutDays,level
    }
}

struct GetPublicPlanRequestApi: Decodable, Encodable, Identifiable {
    let id: UUID = UUID()
    var likes:Int = 0
    var downloads:Int = 0
    var workoutDays: Int = 0
    var level: String = ""
    var createdBy: String = ""
    
    private enum CodingKeys : String, CodingKey {
        case likes, downloads,workoutDays,level,createdBy
    }
}

struct PublicPlanDownloaderStruct: Encodable {
    var planId: String = ""
}

struct SupersetSetApiStats: Encodable,Decodable {
    var reps: Int = 0
    var weight: String = ""
    var number: Int = 0
    
    private enum CodingKeys : String, CodingKey {
        case reps,weight,number
    }
}

struct SupersetStatsUploadApi: Encodable {
    var sets: [SupersetSetApiStats] = [SupersetSetApiStats]()
}

struct SupersetStatsApi: Encodable {
    var exerciseName: String = ""
    var stats: SupersetStatsUploadApi = SupersetStatsUploadApi()
    var exerciseOrder: Int = 0
}

struct UploadStatsSupersetApi: Encodable {
    var planName: String = ""
    var exerciseDay: String = ""
    var exerciseOrder: Int = 0
    var supersets: [SupersetStatsApi] = []
}

struct StatsSupersetBodyApi: Encodable {
    var planName: String = ""
    var exerciseName: String = ""
    var exerciseDay: String = ""
    var exerciseOrder: Int = 0
}

struct StatsSupersetApiResult: Decodable {
    var id: UUID = UUID()
    var sets: [SupersetSetApiStats] = [SupersetSetApiStats]()
    var date: String = ""
    private enum CodingKeys : String, CodingKey {
        case sets,date
    }
}
