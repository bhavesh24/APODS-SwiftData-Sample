//
//  NetworkManager.swift
//  SwiftUISampleApp
//
//  Created by Bhavesh on 18/11/23.
//

import Foundation

enum NetworkConstants {
    static let baseUrl = "https://api.nasa.gov/planetary/apod"
    static let apiKey = "DUlWZSiH9duTHak3AVHOAwB6lvnp0tjtDJaP6HpU"
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse(Data?, URLResponse?)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse(_, _):
            return "We're facing some issues!"
        }
    }
}

enum QueryParams {
    static let count = "count"
    static let apiKey = "api_key"
}

class NetworkManager {
    
    let session: URLSession?
    
    private init(session: URLSession) {
        self.session = session
    }
    
    static func shared() -> NetworkManager {
        let session = URLSession(configuration: .default)
        return NetworkManager(session: session)
    }
    
    public func getData(queryParams: [String: String]) async throws -> Data {
        var queryItems = [URLQueryItem(name: QueryParams.apiKey, value: NetworkConstants.apiKey)]
        queryItems = queryItems + queryParams.compactMap({ key, value in
            URLQueryItem(name: key, value: value)
        })
        var urlComps = URLComponents(string: NetworkConstants.baseUrl)
        urlComps?.queryItems = queryItems
        let url = urlComps?.url
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        do {
            let dataAndResponse = try await session?.data(for: request)
            if let data = dataAndResponse?.0,
               let httpResponse = dataAndResponse?.1 as? HTTPURLResponse,
               200 ..< 300 ~= httpResponse.statusCode {
                return data
            } else {
                throw NetworkError.invalidResponse(dataAndResponse?.0, dataAndResponse?.1)
            }
        } catch {
            throw error
        }
    }
    
    func loadImageData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        // Compute a path to the URL in the cache
        let fileCachePath = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                url.lastPathComponent,
                isDirectory: false
            )
        let cacheUrl = URL(fileURLWithPath: fileCachePath.path)
        // If the image exists in the cache,
        // load the image from the cache and exit
        if let data = try?Data(contentsOf: cacheUrl) {
            completion(data, nil)
            return
        }
        // If the image does not exist in the cache,
        // download the image to the cache
        download(url: url, toFile: cacheUrl) { (error) in
            if let data = try?Data(contentsOf: cacheUrl) {
                completion(data, nil)
                return
            }
            completion(nil, error)
        }
    }
    
    func download(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
        // Download the remote URL to a file
        let task = session?.downloadTask(with: url) {
            (tempURL, response, error) in
            
            guard let tempURL = tempURL else {
                completion(error)
                return
            }
            do {
                // Remove any existing document at file
                if FileManager.default.fileExists(atPath: file.path) {
                    try FileManager.default.removeItem(at: file)
                }
                // Copy the tempURL to file
                try FileManager.default.copyItem(
                    at: tempURL,
                    to: file
                )
                completion(nil)
            }
            // Handle potential file system errors
            catch let fileError {
                completion(fileError)
            }
        }
        // Start the download
        task?.resume()
    }
}
