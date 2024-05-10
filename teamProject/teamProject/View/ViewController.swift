//
//  ViewController.swift
//  teamProject
//
//  Created by 김소리 on 5/10/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var todoList: [TodoListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        readValues()
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            // 롱 프레스가 시작될 때의 작업을 수행합니다.
            
            // 터치된 포인트에서 테이블 뷰 셀의 인덱스 판별
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                updateStatusAlert(selectRow: indexPath.row)
            }
        }
    }
    
    func readValues(){
        let queryModel = QueryModel() // 생성자를 불러왔기 떄문에 StudentsDB init까지는 실행함.
        todoList.removeAll() // 초기화
        queryModel.delegate = self
        queryModel.queryDB()
        tableView.reloadData()
    }
    
    
    
    @IBAction func btnInsert(_ sender: UIBarButtonItem) {
        let addAlert = UIAlertController(title: "todo list", message: "추가할 내용을 입력하세요", preferredStyle: .alert)
        addAlert.addTextField()
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let okAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
            guard let item = addAlert.textFields![0].text else {return}
            let insertModel = InsertModel()
            let result = insertModel.insertDB(item: item)
            
            if result{
                let resultAlert = UIAlertController(title: "완료", message: "리스트가 추가되었습니다.", preferredStyle: .alert)
                let resultAction = UIAlertAction(title: "OK", style: .default)
                
                resultAlert.addAction(resultAction)
                self.present(resultAlert,animated: true)
                
                self.readValues()
                
            }else{
                let resultAlert = UIAlertController(title: "실패", message: "에러가 발생하였습니다.", preferredStyle: .alert)
                let resultAction = UIAlertAction(title: "OK", style: .default)
                resultAlert.addAction(resultAction)
                self.present(resultAlert,animated: true)
            }
        })
        addAlert.addAction(cancelAction)
        addAlert.addAction(okAction)
        self.present(addAlert,animated: true)
    }
    @IBAction func btnSearch(_ sender: UIButton) {
    }
    
    func updateAlert(selectRow: Int) {
        // 이 func는 SingleTap Alert.
        // 셀을 눌렀을 때, updateAlert 실행하여 Alert를 보여줌.
        // indexPath.row를 통해 누른 cell의 정보를 알고있다.
        
        let alertController = UIAlertController(title: "TodoList", message: "수정 할 내용을 입력하세요!", preferredStyle: .alert)
        alertController.addTextField { alert in
            alert.placeholder = "텍스트 입력"
            alert.text = self.todoList[selectRow].item
        }
        alertController.addAction(UIAlertAction(title: "취소", style: .default))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { ACTION in
            let updateQuery = QueryUpdate()
            
            guard let item =  alertController.textFields?.first?.text else {return}
            
            let response: Bool = updateQuery.updateItem(item: item, status: Int32(self.todoList[selectRow].status), id: Int32(self.todoList[selectRow].id))
            
            if response {
                let resultAlert = UIAlertController(title: "결과", message: "수정이 완료되었습니다.", preferredStyle: .alert)
                resultAlert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(resultAlert, animated: true)
                self.readValues()
            }
            else {
                let resultAlert = UIAlertController(title: "결과", message: "에러가 발생하였습니다.", preferredStyle: .alert)
                resultAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { ACTION in
                }))
                self.present(resultAlert, animated: true)
            }
            
        }))
        
        present(alertController, animated: true)
    }
    
    func updateStatusAlert(selectRow: Int) {
        let alertController = UIAlertController(title: "TodoList", message: "해당 항목을 작업완료로 설정하시겠습니까?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "취소", style: .default))
        alertController.addAction(UIAlertAction(title: "미완료", style: .default, handler: { ACTION in
            let update = QueryUpdate()
            if update.updateStatus(status: 0, id: Int32(self.todoList[selectRow].id)) {
                let confirmAlert = UIAlertController(title: "결과", message: "미완료로 변경되었습니다.", preferredStyle: .alert)
                confirmAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { ACTION in
                    self.readValues()
                }))
                
                self.present(confirmAlert, animated: true)
            }
        }))
        alertController.addAction(UIAlertAction(title: "완료", style: .default, handler: { ACTION in
            let update = QueryUpdate()
            if update.updateStatus(status: 1, id: Int32(self.todoList[selectRow].id)) {
                let confirmAlert = UIAlertController(title: "결과", message: "완료로 변경되었습니다.", preferredStyle: .alert)
                confirmAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { ACTION in
                    self.readValues()
                }))
                
                self.present(confirmAlert, animated: true)
            }
        }))
        
        present(alertController, animated: true)
    }
    
}

extension ViewController: QueryModelProtocol{
    func itemDownloaded(items: [TodoListModel]) {
        todoList = items
        tableView.reloadData()
    }
    
    
}


extension ViewController: UITableViewDelegate{
    // Section 갯수 보통은 1
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    // Section당 row 갯수(dataArray의 갯수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.updateAlert(selectRow: indexPath.row)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        // Configure the cell...
        // 콘텐츠 구성
        var content = cell.defaultContentConfiguration()
        // 셀 텍스트 설정
        content.text = todoList[indexPath.row].item
        // 셀 이미지 설정
        content.image = UIImage(systemName: "square.and.arrow.up.circle.fill")
        // 셀 콘텐츠 구성
        cell.contentConfiguration = content
        
        return cell
    }
}


    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Table 셀 삭제
    // Override to support editing the table view.
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            
//            let todoListDB = TodoListDB()
//            
//            let id = Int32(todoList[indexPath.row].id)
//            
//            // 입력을 안하면 ""로 대치
//            let result = todoListDB.deleteDB(id: id)
//            todoList.remove(at: indexPath.row)
//            
//            // Alert
//            if result{
//                let resultAlert = UIAlertController(title: "결과", message: "삭제 되었습니다.", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "네, 알겠습니다.", style: .default, handler: {ACTION in
//                    self.navigationController?.popViewController(animated: true)
//                })
//                
//                resultAlert.addAction(okAction)
//                present(resultAlert, animated: true)
//                
//            } else{
//                let resultAlert = UIAlertController(title: "에러", message: "수정 시 문제가 발생 되었습니다.", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "네, 알겠습니다.", style: .default, handler: {ACTION in
//                    self.navigationController?.popViewController(animated: true)
//                })
//                
//                resultAlert.addAction(okAction)
//                present(resultAlert, animated: true)
//                
//            }
//            
//            
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    // 삭제 한국어 변환
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "삭제"
//    }
    

    // 목록 순서 바꾸기
    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        // 이동할 item의 복사
//        let itemToMove = todoList[fromIndexPath.row]
//        // 이동할 item의 삭제
//        todoList.remove(at: fromIndexPath.row)
//        // 이동할 위치에 insert한다.
//        todoList.insert(itemToMove, at: to.row)

//    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    




