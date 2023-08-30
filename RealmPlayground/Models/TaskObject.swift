//
//  TaskObject.swift
//  RealmPlayground
//
//  Created by Tony Chen on 15/5/2023.
//

import Foundation
import RealmSwift

class ToDoListItem: Object {
    @Persisted var item: String = ""
    @Persisted var date: Date = Date()
    @Persisted var category: String?
}
