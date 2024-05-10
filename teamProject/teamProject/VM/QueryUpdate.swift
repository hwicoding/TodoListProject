//
//  QueryUpdate.wift.swift
//  teamProject
//
//  Created by lcy on 5/10/24.
//

import Foundation
import SQLite3


class QueryUpdate {
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
    }
    
    func updateItem(item: String, status: Int32, id: Int32) -> Bool {
        var stmt: OpaquePointer?
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "UPDATE todolist SET item=?, status=? where id=?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, item, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 2, status)
        sqlite3_bind_int(stmt, 3, id)
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        }
        
        return false
      }
    
    func updateStatus(status: Int32, id: Int32) -> Bool {
        var stmt: OpaquePointer?
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "UPDATE todolist SET status=? where id=?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_int(stmt, 1, status)
        sqlite3_bind_int(stmt, 2, id)
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        }
        
        return false
    }
}
