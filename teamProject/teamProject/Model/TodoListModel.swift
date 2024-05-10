//
//  TodoListModel.swift
//  teamProject
//
//  Created by lcy on 5/10/24.
//

import Foundation

struct TodoListModel {
    var id: Int
    var item: String
    // 완료가 1 미완료 0
    // 불러올때 항상 orderby 통해서 오름차순으로 가져올것
    var status: Int
}
