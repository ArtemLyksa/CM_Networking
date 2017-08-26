//
//  GitHubAPIManager.swift
//  CM_Networking
//
//  Created by Artem Lyksa on 8/26/17.
//  Copyright © 2017 Artem Lyksa. All rights reserved.
//

import Foundation
import Alamofire

enum GitHubAPIManagerError: Error {
    case network(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
}

class GitHubAPIManager {
    
    static let sharedInstance = GitHubAPIManager()
    
    func printPublicGists() -> Void {
        Alamofire.request(GistRouter.getPublic)
            .responseString { response in
                
                if let receivedString = response.result.value {
                    print(receivedString)
                }
                
        }
    }
    
    func fetchPublicGists(
        _ completionHandler: @escaping ((Result<[Gist]>) -> Void)
    )
    {
        Alamofire.request(GistRouter.getPublic)
            .responseJSON { response in
                let result = self.gistArrayFromResponse(response: response)
                completionHandler(result)
        }
    }
    
    
    private func gistArrayFromResponse(response: DataResponse<Any>) -> Result<[Gist]> {
        
        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(GitHubAPIManagerError.network(error: response.result.error!))
        }
        
        
        if
            let jsonDictionary = response.result.value as? [String: Any],
            let errorMessage = jsonDictionary["message"] as? String
        {
            return .failure(GitHubAPIManagerError.apiProvidedError(reason: errorMessage))
        }
        
        
        //make sure we got a JSON dictionary
        guard let jsonArray = response.result.value as? [[String: Any]] else {
            print("didn't get todo object as JSON from API")
            return .failure(GitHubAPIManagerError.objectSerialization(reason: "Did not get JSON dictionary in response"))
            
        }
        
        
        
        //        var gists = [Gist]()
        //
        //        for item in jsonArray {
        //            if let gist = Gist(json: item) {
        //                gists.append(gist)
        //            }
        //        }
        //
        //        let success = Result<[Gist]>.success(gists)
        
        let gists = jsonArray.flatMap({ Gist(json: $0) })
        return .success(gists)
    }
}
