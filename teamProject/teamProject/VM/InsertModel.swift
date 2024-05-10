//
//  InsertModel.swift
//  teamProject
//
//  Created by 김소리 on 5/10/24.
//

import Foundation
import SQLite3

class InsertModel{
    var db: OpaquePointer?
    
    init() {
        // db 경로
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "TodoListProject.sqlite")
        
        // db Open
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK {
            print("error opening database")
        }
        
        // db Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS todolist(id INTEGER PRIMARY KEY AUTOINCREMENT, item TEXT, status INT)", nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error creating table : \(errorMessage)")
        }
        
        func insertDB(item: String, status: Int) -> Bool {
            var stmt: OpaquePointer?
            
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            let queryString = "INSERT INTO todolist (item,status) VALUES (?,0)"
            
            sqlite3_prepare(db, queryString, -1, &stmt, nil)
            
            sqlite3_bind_text(stmt, 1, item, -1, SQLITE_TRANSIENT)
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                return true
            }
            
            return false
        }
    }
}
