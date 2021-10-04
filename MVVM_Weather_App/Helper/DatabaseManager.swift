//
//  DatabaseManager.swift
//  MVVM_Weather_App
//
//  Created by Ilya Buzyrev on 20.09.2021.
//

import Foundation
import SQLite3

class DatabaseManager {
    
    var db: OpaquePointer?
    var path: String = "weatherApp.sqlite"
    
    init() {
        self.db = createDB()
        createCitiesTable()
    }
    
    private func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
        
        var db: OpaquePointer? = nil
        print(sqlite3_open(filePath.path, &db))
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Error in creating db")
            return nil
        } else {
            print("DB has been created with path \(path)")
            return db
        }
    }
    
    private func createCitiesTable() {
        let query = "CREATE TABLE IF NOT EXISTS CITY(Id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, region TEXT, CONSTRAINT region_and_title UNIQUE (title, region));"
        
        var createTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &createTable, nil) == SQLITE_OK {
            if sqlite3_step(createTable) == SQLITE_DONE {
                print("City table created")
            } else {
                print("Failed city table creation")
            }
        } else {
            print("Preparation city failed")
        }
    }
    
    public func insertCityInDatabase(city: CityWeather) {
        let query = "INSERT INTO CITY (id, title, region) VALUES (?, ?, ?);"
        
    }

}
