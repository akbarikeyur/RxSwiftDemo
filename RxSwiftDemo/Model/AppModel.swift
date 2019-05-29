//
//  AppModel.swift
//  RxSwiftDemo
//
//  Created by Keyur on 29/05/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class AppModel: NSObject {
    static let shared = AppModel()
    
    var TripArr : [TripModel] = [TripModel]()
    
}

class TripModel : AppModel
{
    var id : String!
    var name : String!
    var startDate : String!
    var endDate : String!
    
    override init(){
        id = ""
        name = ""
        startDate = ""
        endDate = ""
        
    }
    
    init(dict : [String : Any])
    {
        id = ""
        name = ""
        startDate = ""
        endDate = ""
        
        
        if let temp = dict["id"] as? String {
            id = temp
        }
        if let temp = dict["name"] as? String {
            name = temp
        }
        if let temp = dict["startDate"] as? String {
            startDate = temp
        }
        if let temp = dict["endDate"] as? String {
            endDate = temp
        }
        
    }
    
    func dictionary() -> [String:Any]  {
        return ["id" : id, "name" : name ,"startDate":startDate, "endDate":endDate]
    }
 
}
