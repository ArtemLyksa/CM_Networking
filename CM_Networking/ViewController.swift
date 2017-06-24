//
//  ViewController.swift
//  CM_Networking
//
//  Created by Artem Lyksa on 6/24/17.
//  Copyright © 2017 Artem Lyksa. All rights reserved.
//


import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        alamofireDeleteRequest()
    }
    
    
    func alamofireDeleteRequest() {
        let todoEndpoint = "https://jsonplaceholder.typicode.com/todos/1"
        Alamofire.request(todoEndpoint, method: .delete)
            .responseJSON { response in
                
                if response.result.isSuccess == false {
                    print("CALL FAILED")
                    return
                }
                
                print("DELETE ok")
        }
    }
    
    func alamofirePostRequestTest()
    {
        let todoEndpoint = "https://jsonplaceholder.typicode.com/todos"
        let newTodo: [String: Any] = ["title": "My FirstPost Using Alamofire", "completed" : 0, "userId" : 1]
        
        Alamofire.request(todoEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            
            .responseJSON { response in
                
                if response.result.isSuccess == false {
                    print("CALL FAILED")
                    return
                }
                
                guard let json = response.result.value as? [String: Any] else {
                    print("error in .responseJSON")
                    return
                }
                
                guard let title = json["title"] else {
                    print("value with key title does not exist")
                    return
                }
                
                print(title)
                
            }
    }
    
    func alamofireGetRequestTest() {
        let todoEndpoint = "https://jsonplaceholder.typicode.com/todos/1"
        
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                
                if response.result.isSuccess == false {
                    print("CALL FAILED")
                    return
                }
                
                guard let json = response.result.value as? [String: Any] else {
                    print("error in .responseJSON")
                    return
                }
                
                guard let title = json["title"] else {
                    print("value with key title does not exist")
                    return
                }
                
                print(title)
                
            }
            .responseString { response in
                if let error = response.result.error {
                    print(error)
                }
                
                if let value = response.result.value {
                    print(value)
                }
        }
    }
    
    
    func nativeGetReqestTest() {
        let todoEndpoint = "https://jsonplaceholder.typicode.com/todos/1"
    
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
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
    
    
    func nativePostReqestTest() {
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

