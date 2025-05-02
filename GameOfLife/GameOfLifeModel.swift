//
//  GameOfLifeModel.swift
//  GameOfLife
//
//  Created by Laurent Jeanjean on 30/04/2025.
//


import Foundation

class GameOfLifeModel: ObservableObject {
    let rows: Int
    let cols: Int
    @Published var grid: [[Bool]]
    
    init(rows: Int = 20, cols: Int = 20) {
        self.rows = rows
        self.cols = cols
        self.grid = Array(repeating: Array(repeating: false, count: cols), count: rows)
    }
}
