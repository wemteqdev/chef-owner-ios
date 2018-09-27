//
//  DBManager.swift
//  RealmDatabase
//
//  Created by kunal on 22/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
import RealmSwift





import UIKit

import RealmSwift

class DBManager {
    
    public var   database:Realm
    static let   sharedInstance = DBManager()
    
    
    
    private init() {
        
        database = try! Realm()
        
    }
    
    func deleteAllFromDatabase()  {
        do{
        let realm =  try database.write {
            database.deleteAll()
            
        }
        }catch let error as NSError {
           print("ss", error)
        }
        
    }
    
    
}
