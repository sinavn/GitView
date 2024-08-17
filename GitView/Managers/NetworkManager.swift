//
//  NetworkManager.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/27/1403 AP.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com"
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
    func getFollowers (for username :String , page :Int) async throws -> [Follower] {
        guard let url = URL(string: baseURL+"/users/\(username)/following?per_page=100&page=\(page)")else{throw NetworkError.invalidURL}
        do {
              let (data , response) = try await URLSession.shared.data(from: url)
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
}
