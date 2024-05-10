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
    }
    
    @IBAction func btnInsert(_ sender: UIBarButtonItem) {
    }
    @IBAction func btnSearch(_ sender: UIButton) {
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
    
}



