//
//  DeleteModel.swift
//  teamProject
//
//  Created by 김소리 on 5/11/24.
//

import Foundation
import SQLite3

struct DeleteModel{
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
    
    func deleteDB(id: Int32) -> Bool {
    var stmt: OpaquePointer?

    let queryString = "DELETE FROM todolist where id=?"
    
    sqlite3_prepare(db, queryString, -1, &stmt, nil)
    sqlite3_bind_int(stmt, 1, id)
    
    if sqlite3_step(stmt) == SQLITE_DONE {
        return true
    }
    
    return false
  }
}
