//
//  ApiManager.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import Foundation
import SwiftUI

class ApiManager {
    
    func register(name:String,email:String,password:String, completion: @escaping(Result<authRespone,NetworkingError>) -> Void) {
        
        guard let url = URL(string: "https://plansapp.herokuapp.com/api/user/register") else {
            completion(.failure(.custom(message: "Bad URL")))
            return
        }
        
        let body = registerBody(name: name, email: email, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            print(response.statusCode)
            
            guard let data = data else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            guard let apiResponse = try? JSONDecoder().decode(authRespone.self, from: data) else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            if (!(response.statusCode == 200)) {
                completion(.failure(.custom(message: apiResponse.message ?? "")))
                return
            }
            
            
            DispatchQueue.main.async {
                completion(.success(apiResponse))
            }
            
        }.resume()
    }
    
    func registerCoach(name:String,email:String,password:String, completion: @escaping(Result<authRespone,NetworkingError>) -> Void) {
        
        guard let url = URL(string: "https://plansapp.herokuapp.com/api/user/register/coach") else {
            completion(.failure(.custom(message: "Bad URL")))
            return
        }
        
        let body = registerBody(name: name, email: email, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            print(response.statusCode)
            
            guard let data = data else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            guard let apiResponse = try? JSONDecoder().decode(authRespone.self, from: data) else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            if (!(response.statusCode == 200)) {
                completion(.failure(.custom(message: apiResponse.message ?? "")))
                return
            }
            
            
            DispatchQueue.main.async {
                completion(.success(apiResponse))
            }
            
        }.resume()
    }
    
    func login(email:String,password:String,coach:Bool, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/login"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/login/coach"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.custom(message: "Bad URL")))
            return
        }
        
        let body = loginBody(email: email, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            print(response.statusCode)
            
            guard let data = data else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            guard let apiResponse = try? JSONDecoder().decode(authRespone.self, from: data) else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            if (!(response.statusCode == 200)) {
                completion(.failure(.custom(message: apiResponse.message ?? "")))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(apiResponse))
            }
            
        }.resume()
    }
    
    func deleteAccount(userid:String,token:String,coach:Bool, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/delete/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/delete/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.custom(message: "Bad URL")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Delete Response: \(response.statusCode)")
            
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
    
    func fetchPublicExercises(completion: @escaping ([publicExercise])->()) {
        
        guard let url = URL(string: "https://plansapp.herokuapp.com/api/user/publicexercises") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, err in
            
            if let data = data {
                do {
                    let exercises = try JSONDecoder().decode([publicExercise].self, from: data)
                    DispatchQueue.main.async {
                        completion(exercises)
                    }
                } catch let error{
                    print(error)
                }
            }
        }.resume()
    }
    
    func decodePlan(userID: String, token: String,coach:Bool, completion: @escaping(Result<[PlanApi],NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/personalplans/\(userID)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/personalplans/coach/\(userID)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Get Personal Plans Response: \(response.statusCode)")
            
            do {
                let planResponse = try JSONDecoder().decode([PlanApi].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(planResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "\(error)")))
                }
            }
        }.resume()
    }
    
    func deletePlan(userid:String,token:String,planName: String,coach:Bool, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/personalplans/delete/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/personalplans/coach/delete/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        let bodyStruct = PlanNameStructAPI(planName: planName)
        request.httpBody = try? JSONEncoder().encode(bodyStruct)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Delete Response: \(response.statusCode)")
            
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
    
    
    func checkPlanExistence(userid:String,token:String,planName: String,coach:Bool, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/personalplans/check/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/personalplans/coach/check/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        let bodyStruct = PlanNameStructAPI(planName: planName)
        request.httpBody = try? JSONEncoder().encode(bodyStruct)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard (response as? HTTPURLResponse) != nil else {
                completion(.failure(.custom(message: "Server Error")))
                return
            }
            
            guard let data = data else {
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
    
    func checkPublishedPlanExistence(userid:String,token:String,planName: String,completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        let urlString = "https://plansapp.herokuapp.com/api/user/personalplans/coach/check/published/\(userid)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        let bodyStruct = PlanNameStructAPI(planName: planName)
        request.httpBody = try? JSONEncoder().encode(bodyStruct)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard (response as? HTTPURLResponse) != nil else {
                completion(.failure(.custom(message: "Server Response Error")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom(message: "Server Data Error")))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(authRespone.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apiResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Decoding Error")))
                }
            }
        }.resume()
    }
    
    
    func uploadStats(exercise: Exercise, exerciseModel:ExerciseModel, exercises: FetchedResults<Exercise>, userid:String?,token:String?, coach:Bool, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        guard let userid = userid else {
            return
        }
        
        guard let token = token else {
            return
        }
        
        var urlString = "https://plansapp.herokuapp.com/api/user/plan/exercisestats/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/plan/exercisestats/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        let statsUploadAPI =  StatsEncoder().encodeStats(exercise: exercise, exerciseModel: exerciseModel, exercises: exercises)
        
        request.httpBody = try? JSONEncoder().encode(statsUploadAPI)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard (response as? HTTPURLResponse) != nil else {
                completion(.failure(.custom(message: "Http response found nil")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom(message: "No data upload stats response")))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(authRespone.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apiResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Decoding Error")))
                }
            }
            
            
        }.resume()
    }
    
    func downloadStats(exercise: Exercise,userid:String?,token:String?,coach:Bool, completion: @escaping(Result<[StatDownloadApi],NetworkingError>) -> ()) {
        
        guard let userid = userid else {
            return
        }
        
        guard let token = token else {
            return
        }
        
        var urlString = "https://plansapp.herokuapp.com/api/user/plan/exercisestats/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/plan/exercisestats/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        let statExerciseBodyApi = StatExerciseBodyApi(planName: exercise.plan?.name ?? "", exerciseName: exercise.name ?? "", exerciseDay: exercise.day ?? "")
        
        request.httpBody = try? JSONEncoder().encode(statExerciseBodyApi)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard (response as? HTTPURLResponse) != nil else {
                completion(.failure(.custom(message: "Http response found nil")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom(message: "No data upload stats response")))
                return
            }
            
            do {
                let statDownloadApi = try JSONDecoder().decode([StatDownloadApi].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(statDownloadApi))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Server Error")))
                }
            }
            
            
        }.resume()
    }
    
    func addExercise(userid:String,token:String,exerciseName:String,day:String,planName: String,coach:Bool,exercise: ExerciseModel, exercises: FetchedResults<Exercise>, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/personalplans/add/exercise/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/personalplans/add/exercise/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        
        var setsAPIArray = [SetApi]()
        
        for index in exercise.sets.indices {
            
            var setApi = SetApi()
            setApi.reps = Int(exercise.sets[index].reps) ?? 0
            setApi.weight = exercise.sets[index].weight.replacingOccurrences(of: ",", with: ".")
            setApi.restTime = Int(exercise.sets[index].restTime) ?? 0
            setApi.latestReps = Int(exercise.sets[index].latestReps)
            setApi.number = index + 1
            setsAPIArray.append(setApi)
        }
        
        let bodyStruct = addExerciseApiModel(planName: planName, exerciseName: exerciseName, day: day, sets: setsAPIArray, rowOrder: Int(exercises.last?.rowOrder ?? 0) + 1)

        request.httpBody = try? JSONEncoder().encode(bodyStruct)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Add Exercise Response: \(response.statusCode)")
            
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
    
    func addSuperset(userid:String,token:String,day:String,planName: String,coach:Bool,exerciseSupersetArrayModel: [ExerciseSupersetModel],restTime:Int, exercises: FetchedResults<Exercise>, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/personalplans/add/exercise/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/personalplans/add/exercise/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        var supersets = [SupersetApi]()
        
        for exerciseSupersetModel in exerciseSupersetArrayModel {
            
            var supersetApi = SupersetApi()
            supersetApi.exerciseName = exerciseSupersetModel.name
            supersetApi.exerciseOrder = exerciseSupersetModel.exerciseOrder
            for index in exerciseSupersetModel.sets.indices {
                var setSupersetApi = SetSupersetApi()
                setSupersetApi.reps = Int(exerciseSupersetModel.sets[index].reps) ?? 0
                setSupersetApi.latestReps = Int(exerciseSupersetModel.sets[index].latestReps) ?? 0
                setSupersetApi.weight = exerciseSupersetModel.sets[index].weight
                setSupersetApi.number = index + 1
                supersetApi.sets.append(setSupersetApi)
            }
            
            supersets.append(supersetApi)
        }
        
        
        
        
        
        let bodyStruct = addSupersetApiModel(planName: planName, exerciseName: "Superset", supersets: supersets, exerciseOrder: Int((exercises.last?.rowOrder ?? 0)) + 1, day: day, restTime: restTime)

        request.httpBody = try? JSONEncoder().encode(bodyStruct)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Delete Response: \(response.statusCode)")
            
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
    
    func deleteExercise(userid:String,token:String,planName: String,coach:Bool,exercise: Exercise, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/personalplans/delete/exercise/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/personalplans/delete/exercise/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        let bodyStruct = deleteExerciseApiModel(planName: exercise.plan?.name ?? "", exerciseName: exercise.name ?? "", exerciseDay: exercise.day ?? "", rowOrder: Int(exercise.rowOrder))
        request.httpBody = try? JSONEncoder().encode(bodyStruct)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Delete Response: \(response.statusCode)")
            
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
    
    func decodePublishedPlan(userID: String, token: String, completion: @escaping(Result<[PublishedPlanApi],NetworkingError>) -> ()) {
        
        let urlString = "https://plansapp.herokuapp.com/api/user/publicplans/coach/\(userID)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Get Published Plans Response: \(response.statusCode)")
            
            do {
                let planResponse = try JSONDecoder().decode([PublishedPlanApi].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(planResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "\(error)")))
                }
            }
        }.resume()
    }
    
    func deletePublishedPlan(userID: String, token: String,planName:String, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        let urlString = "https://plansapp.herokuapp.com/api/user/publicplans/coach/delete/\(userID)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        let bodyStruct = PlanNameStructAPI(planName: planName)
        request.httpBody = try? JSONEncoder().encode(bodyStruct)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Delete Published Plans Response: \(response.statusCode)")
            
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
    
    func getPublishedPlanInfo(userID: String, token: String,coach:Bool,getPublishedPlanRequestApi: GetPublicPlanRequestApi,page:Int, completion: @escaping(Result<[PublicPlanInfoApi],NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/publicplans/user/\(userID)?page=\(page)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/publicplans/coach/\(userID)?page=\(page)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        request.httpBody = try? JSONEncoder().encode(getPublishedPlanRequestApi)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Get Published Plans Info Response: \(response.statusCode)")
            
            do {
                let apiResponse = try JSONDecoder().decode([PublicPlanInfoApi].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apiResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Decoding Error")))
                }
            }
        }.resume()
    }
    
    func getPublishedPlanData(userID: String, token: String,coach:Bool,planToDownloadId:String, completion: @escaping(Result<PlanApi,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/publicplans/user/download/\(userID)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/publicplans/coach/download/\(userID)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        request.httpBody = try? JSONEncoder().encode(PublicPlanDownloaderStruct(planId: planToDownloadId))
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Get Published Plans Data Response: \(response.statusCode)")
            
            do {
                let apiResponse = try JSONDecoder().decode(PlanApi.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apiResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Decoding Error")))
                }
            }
        }.resume()
    }
    
    func updateExercise(userid:String,token:String,coach:Bool,apiStruct:addExerciseApiModel, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/plan/updateexercise/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/api/user/plan/updateexercise/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        request.httpBody = try? JSONEncoder().encode(apiStruct)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Update Sets Response: \(response.statusCode)")
            
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
    
    func updateSuperset(userid:String,token:String,coach:Bool,apiStruct:addSupersetApiModel, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        var urlString = "https://plansapp.herokuapp.com/api/user/plan/updatesuperset/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/api/user/plan/updatesuperset/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        request.httpBody = try? JSONEncoder().encode(apiStruct)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            print("Update Sets Superset Response: \(response.statusCode)")
            
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
    
    func uploadSupersetStats(exercise: Exercise, exerciseSupersetModelArray:[ExerciseSupersetModel], userid:String?,token:String?, coach:Bool, completion: @escaping(Result<authRespone,NetworkingError>) -> ()) {
        
        guard let userid = userid else {
            return
        }
        
        guard let token = token else {
            return
        }
        
        var urlString = "https://plansapp.herokuapp.com/api/user/plan/supersetstats/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/plan/supersetstats/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        let statsUploadAPI =  StatsEncoder().encodeStatsSuperset(exercise: exercise, arraySupersetModel: exerciseSupersetModelArray)
        
        request.httpBody = try? JSONEncoder().encode(statsUploadAPI)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard (response as? HTTPURLResponse) != nil else {
                completion(.failure(.custom(message: "Http response found nil")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom(message: "No data upload stats response")))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(authRespone.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apiResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Decoding Error Superset Stats Upload")))
                }
            }
            
            
        }.resume()
    }
    
    func downloadSupersetStats(superset: Superset,userid:String?,token:String?,coach:Bool, completion: @escaping(Result<[StatsSupersetApiResult],NetworkingError>) -> ()) {
        
        guard let userid = userid else {
            return
        }
        
        guard let token = token else {
            return
        }
        
        var urlString = "https://plansapp.herokuapp.com/api/user/plan/supersetstats/\(userid)"
        
        if (coach) {
            urlString = "https://plansapp.herokuapp.com/api/user/plan/supersetstats/coach/\(userid)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "auth-token")
        
        let statsSupersetBodyApi = StatsSupersetBodyApi(planName: superset.exercise?.plan?.name ?? "", exerciseName: superset.exerciseName ?? "", exerciseDay: superset.exercise?.day ?? "", exerciseOrder: Int(superset.exercise?.rowOrder ?? 1))
        
        request.httpBody = try? JSONEncoder().encode(statsSupersetBodyApi)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard (response as? HTTPURLResponse) != nil else {
                completion(.failure(.custom(message: "Http response found nil")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom(message: "No data download stats superset response")))
                return
            }
            
            do {
                let statDownloadApi = try JSONDecoder().decode([StatsSupersetApiResult].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(statDownloadApi))
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.custom(message: "Decoding Error Download Superset Stats")))
                }
            }
        }.resume()
    }
}

