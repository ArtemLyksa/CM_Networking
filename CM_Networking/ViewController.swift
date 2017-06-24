//
//  ViewController.swift
//  CM_Networking
//
//  Created by Artem Lyksa on 6/24/17.
//  Copyright © 2017 Artem Lyksa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func nativeReqestTest() {
        let todoEndpoint = "https://jsonplaceholder.typicode.com/todos"
        
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let newTodo: [String : Any] = ["title" : "My firstTodo", "completed" : false, "userId" : 1]
        let jsonTodo: Data
        
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            urlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create data for todo")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            //Error handling
            if let error = error {
                print("error occurred. Error = \(error)")
                return
            }
            
            //Check if data exists
            guard let responseData = data else {
                print("didnot receive data")
                return
            }
            
            do {
                guard let todo = try JSONSerialization.jsonObject(with:responseData, options: []) as? [String : Any] else {
                    print("error when trying convert data to JSON")
                    return
                }
                print ("todo = \(todo)")
                
            } catch {
                print("error is nil")
            }

        }
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

