//
//  NetworkManager.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/27/1403 AP.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let cache = NSCache<NSString,UIImage>()
    private init () {}
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingFailed(Error)
        case serverError(statusCode: Int)
        case unknownError

        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "The URL provided was invalid."
            case .noData:
                return "No data was received from the server."
            case .decodingFailed(let error):
                return "Failed to decode the data: \(error.localizedDescription)"
            case .serverError(let statusCode):
                return "User not found : \(statusCode)."
            case .unknownError:
                return "An unknown error occurred."
            }
        
        }
    }
    
    private func createRequest (url : URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.addValue("Bearer \(Constants.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func getFollowers (for username :String , page :Int) async throws -> [Follower] {
        guard let url = URL(string: Constants.baseURL+"/users/\(username)/followers?per_page=100&page=\(page)")else{throw NetworkError.invalidURL}
        let request = createRequest(url: url)
        do {
              let (data , response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else{
                throw NetworkError.unknownError
            }
                if response.statusCode >= 200 && response.statusCode < 300 {
                    do{
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode([Follower].self, from: data)
                        return result
                    }catch let decodingError{
                       throw  NetworkError.decodingFailed(decodingError)
                    }
                }else{
                    throw NetworkError.serverError(statusCode: response.statusCode)
                }
            
        } catch let error as NetworkError {
            throw error
        }
        
    }
    
    func getUserInfo (userName: String) async throws -> User{
        guard let url = URL(string: Constants.baseURL + "/users/" + userName) else {throw NetworkError.invalidURL}
        
        let request = createRequest(url: url)
        
        do {
            let (data , response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {throw NetworkError.unknownError}
            if response.statusCode >= 200 , response.statusCode < 300 {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(User.self, from: data)
                return result
            }else{
                throw NetworkError.serverError(statusCode: response.statusCode)
            }
        } catch let error as NetworkError {
            throw error
        }
        
    }
    
    func getUserReadme(userName : String) async throws -> String{
        guard let url = URL(string: Constants.baseURL + "/repos/\(userName)/\(userName)/readme") else {
            throw NetworkError.invalidURL
        }
        let request = createRequest(url: url)
        do{
            let (data,_) =  try await URLSession.shared.data(for: request)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] ,
                    let base64Content = json["content"] as? String ,
                    let encoding = json["encoding"] as? String ,
                  encoding == "base64" else {
                throw NetworkError.noData
            }
            let cleanBase64Content = base64Content.replacingOccurrences(of: "\n", with: "")

            guard let decodedContent = Data(base64Encoded: cleanBase64Content) ,
                  let decodedString = String(data: decodedContent, encoding: .utf8) else {
                throw NetworkError.unknownError
            }
             return decodedString
        }catch let error as NetworkError {
            throw error
        }
    }
    
    func convertMarkdownToHTML ( content : String) async throws -> String {
        guard let url = URL(string: "https://api.github.com/markdown") else {
            throw NetworkError.invalidURL
        }
        var request = createRequest(url: url)
        request.httpMethod = "POST"
        
        let body : [String : Any] = [
            "text" : content ,
            "mode" : "gfm"
        ]

        let jsonData = try JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        let (data,_) = try await URLSession.shared.data(for: request)
        
        if let htmlString = String(data: data, encoding: .utf8){
            return htmlString
        } else {
            throw NetworkError.unknownError
        }
    }
}
