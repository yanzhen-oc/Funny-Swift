//
//  FSQLiteManager.swift
//  Funny
//
//  Created by yanzhen on 2018/5/3.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import SQLite

let FSQLite = FSQLiteManager.manager

class FSQLiteManager {
    
    public static let manager = FSQLiteManager()
    private var db: Connection!
    private var noteTable: Table!
    private var format: DateFormatter!
    private init() {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = path + "/Funny.sqlite3"
        db = try? Connection(path)
        noteTable = Table("note")
        let id = Expression<Int64>("id")
        let time = Expression<Int64>("time")
        let content = Expression<String>("content")
        try? db.run(noteTable.create { t in
            t.column(id, primaryKey: true)
            t.column(time)
            t.column(content)
        })
        
        format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    public func dateString(_ timeInterval: Int64) ->String {
        let date = Date.init(timeIntervalSince1970: TimeInterval(timeInterval))
        return format.string(from: date)
    }
    
    public func insert(_ note: FunnyNote) {
        let timeItem = Expression<Int64>("time")
        let contentItem = Expression<String>("content")
        let insert = noteTable.insert(timeItem <- note.time, contentItem <- note.content)
        try! db.run(insert)
    }
    
    public func update(_ note: FunnyNote) {
        let id = Expression<Int64>("id")
        let contentItem = Expression<String>("content")
        let alice = noteTable.filter(id == note.id)
        try! db.run(alice.update(contentItem <- note.content))
    }
    
    public func delete(_ note: FunnyNote) {
        let id = Expression<Int64>("id")
        let alice = noteTable.filter(id == note.id)
        try! db.run(alice.delete())
    }
    
    public func allNote() -> [FunnyNote] {
        let id = Expression<Int64>("id")
        let time = Expression<Int64>("time")
        let content = Expression<String>("content")
        
        var notes = [FunnyNote]()
        guard let result = try? db.prepare(noteTable) else {
            return notes
        }
        for note in result {
            let fnote = FunnyNote()
            fnote.id = note[id]
            fnote.time = note[time]
            fnote.content = note[content]
            notes.append(fnote)
        }
        return notes
    }
}
