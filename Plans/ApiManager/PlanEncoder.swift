//
//  PlanEncoder.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 03/02/22.
//

import Foundation

class PlanApiManager {
    
    func encodeAndUploadPlan(plan: Plan, userID: String, token: String, coach:Bool, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var planApi = PlanApi()
        
        planApi.planName = plan.name ?? ""
        planApi.notes = plan.notes ?? ""
        planApi.level = plan.level ?? "Intermediate"

        guard let planDBExercises = plan.exercises?.allObjects as? [Exercise] else {
            print("Error during encoding plan")
            return
        }
        
        for exercise in planDBExercises {
            
            if (exercise.name ?? "" == "Superset") {
                
                var supersetExerciseApi = SupersetExerciseApi()
                supersetExerciseApi.exerciseOrder = Int(exercise.rowOrder)
                supersetExerciseApi.restTime = Int(exercise.restTime)
                supersetExerciseApi.day = exercise.day ?? ""
                
                guard let exerciseDBSupersets = exercise.supersets?.allObjects as? [Superset] else {
                    print("Error during encoding supersets")
                    return
                }
                
                for superset in exerciseDBSupersets {
                    
                    var supersetApi = SupersetApi()
                    supersetApi.exerciseName = superset.exerciseName ?? ""
                    supersetApi.exerciseOrder = Int(superset.exerciseOrder)
                    
                    guard let supersetDBSets = superset.sets?.allObjects as? [SetExercise] else {
                        print("Error during encoding sets")
                        return
                    }
                    
                    for setOBJ in supersetDBSets {
                        var setSupersetApi = SetSupersetApi()
                        setSupersetApi.reps = Int(setOBJ.reps)
                        setSupersetApi.weight = String(setOBJ.weight)
                        setSupersetApi.latestReps = Int(setOBJ.latestReps)
                        setSupersetApi.number = Int(setOBJ.number)
                        supersetApi.sets.append(setSupersetApi)
                    }
                    
                    supersetExerciseApi.supersets.append(supersetApi)
                }
                
                planApi.supersets.append(supersetExerciseApi)
                
            } else {
                var exerciseApi = ExerciseApi()
                exerciseApi.name = exercise.name ?? ""
                exerciseApi.day = exercise.day ?? ""
                exerciseApi.rowOrder = Int(exercise.rowOrder)
                
                guard let exerciseDBSets = exercise.sets?.allObjects as? [SetExercise] else {
                    print("Error during encoding sets")
                    return
                }
                
                for setOBJ in exerciseDBSets {
                    var setApi = SetApi()
                    setApi.reps = Int(setOBJ.reps)
                    setApi.weight = String(setOBJ.weight)
                    setApi.restTime = Int(setOBJ.restTime)
                    setApi.latestReps = Int(setOBJ.latestReps)
                    setApi.number = Int(setOBJ.number)
                    exerciseApi.sets.append(setApi)
                }
                planApi.exercises.append(exerciseApi)
            }

            
        }
        
        
        var urlString = "https://plansapp.herokuapp.com/api/user/personalplans/\(userID)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/personalplans/coach/\(userID)"
        }
        
        guard let url = URL(string: urlString) else  { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        request.httpBody = try? JSONEncoder().encode(planApi)
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }

            
            if (!(response.statusCode == 200)) {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(authRespone.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apiResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Server Error")))
                }
            }
        }.resume()
    }
    
    func encodeAndPublishPlan(plan: Plan, userID: String, token: String, coach:Bool, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var planApi = PlanApi()
        
        planApi.planName = plan.name ?? ""
        planApi.notes = plan.notes ?? ""
        planApi.level = plan.level ?? "Intermediate"

        guard let planDBExercises = plan.exercises?.allObjects as? [Exercise] else {
            print("Error during encoding plan")
            return
        }
        
        for exercise in planDBExercises {
            
            if (exercise.name ?? "" == "Superset") {
                
                var supersetExerciseApi = SupersetExerciseApi()
                supersetExerciseApi.exerciseOrder = Int(exercise.rowOrder)
                supersetExerciseApi.restTime = Int(exercise.restTime)
                supersetExerciseApi.day = exercise.day ?? ""
                
                guard let exerciseDBSupersets = exercise.supersets?.allObjects as? [Superset] else {
                    print("Error during encoding supersets")
                    return
                }
                
                for superset in exerciseDBSupersets {
                    
                    var supersetApi = SupersetApi()
                    supersetApi.exerciseName = superset.exerciseName ?? ""
                    supersetApi.exerciseOrder = Int(superset.exerciseOrder)
                    
                    guard let supersetDBSets = superset.sets?.allObjects as? [SetExercise] else {
                        print("Error during encoding sets")
                        return
                    }
                    
                    for setOBJ in supersetDBSets {
                        var setSupersetApi = SetSupersetApi()
                        setSupersetApi.reps = Int(setOBJ.reps)
                        setSupersetApi.weight = "0"
                        setSupersetApi.latestReps = 0
                        setSupersetApi.number = Int(setOBJ.number)
                        supersetApi.sets.append(setSupersetApi)
                    }
                    
                    supersetExerciseApi.supersets.append(supersetApi)
                }
                
                planApi.supersets.append(supersetExerciseApi)
                
            } else {
                var exerciseApi = ExerciseApi()
                exerciseApi.name = exercise.name ?? ""
                exerciseApi.day = exercise.day ?? ""
                exerciseApi.rowOrder = Int(exercise.rowOrder)
                
                guard let exerciseDBSets = exercise.sets?.allObjects as? [SetExercise] else {
                    print("Error during encoding sets")
                    return
                }
                
                for setOBJ in exerciseDBSets {
                    var setApi = SetApi()
                    setApi.reps = Int(setOBJ.reps)
                    setApi.weight = "0"
                    setApi.restTime = Int(setOBJ.restTime)
                    setApi.latestReps = 0
                    setApi.number = Int(setOBJ.number)
                    exerciseApi.sets.append(setApi)
                }
                planApi.exercises.append(exerciseApi)
            }

            
        }
        
        
        let urlString = "https://plansapp.herokuapp.com/api/user/publicplans/\(userID)"
        
        guard let url = URL(string: urlString) else  { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        request.httpBody = try? JSONEncoder().encode(planApi)
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }

            
            if (!(response.statusCode == 200)) {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(authRespone.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apiResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Server Error")))
                }
            }
        }.resume()
    }
}
