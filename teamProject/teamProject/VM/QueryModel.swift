import Foundation
import SQLite3

protocol QueryModelProtocol {
    func itemDownloaded(items: [TodoListModel])
}

class QueryModel {
  var db: OpaquePointer?
  var todoLists: [TodoListModel] = []
  var delegate: QueryModelProtocol!
 
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
  
  // Select
  func queryDB() {
    var stmt: OpaquePointer?
    let queryString = "SELECT * FROM todolist order by status"
    
    if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
        let errorMessage = String(cString: sqlite3_errmsg(db)!)
        print("error preparing select : \(errorMessage)")
    }
    
    while sqlite3_step(stmt) == SQLITE_ROW {
        let id = Int(sqlite3_column_int(stmt, 0))
        let item = String(cString: sqlite3_column_text(stmt, 1))
        let status = Int(sqlite3_column_int(stmt, 2))
        
        todoLists.append(TodoListModel(id: id, item: item, status: status))
        print("------------------------------------- append")
    }
    delegate.itemDownloaded(items: todoLists)
  }
  
  func insertDB(name: String, dept: String, phone: String) -> Bool {
    var stmt: OpaquePointer?
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    let queryString = "INSERT INTO students (sname,sdept,sphone) VALUES (?,?,?)"
    
    sqlite3_prepare(db, queryString, -1, &stmt, nil)
    
    sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
    sqlite3_bind_text(stmt, 2, dept, -1, SQLITE_TRANSIENT)
    sqlite3_bind_text(stmt, 3, phone, -1, SQLITE_TRANSIENT)
    
    if sqlite3_step(stmt) == SQLITE_DONE {
        return true
    }
    
    return false
  }
  
  func updateDB(name: String, dept: String, phone: String, id: Int32) -> Bool {
    var stmt: OpaquePointer?
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    let queryString = "UPDATE students SET sname=?, sdept=?, sphone=? where sid=?"
    
    sqlite3_prepare(db, queryString, -1, &stmt, nil)
    
    sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
    sqlite3_bind_text(stmt, 2, dept, -1, SQLITE_TRANSIENT)
    sqlite3_bind_text(stmt, 3, phone, -1, SQLITE_TRANSIENT)
    sqlite3_bind_int(stmt, 4, id)
    
    if sqlite3_step(stmt) == SQLITE_DONE {
        return true
    }
    
    return false
  }
  
    func deleteDB(id: Int32) -> Bool {
    var stmt: OpaquePointer?

    let queryString = "DELETE FROM students where sid=?"
    
    sqlite3_prepare(db, queryString, -1, &stmt, nil)
    sqlite3_bind_int(stmt, 1, id)
    
    if sqlite3_step(stmt) == SQLITE_DONE {
        return true
    }
    
    return false
  }
 
}


