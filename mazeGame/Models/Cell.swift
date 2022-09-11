//
//  Cell.swift
//  mazeGame
//
//  Created by Nickolay Truhin on 11.09.2022.
//

import Foundation

enum CellType: CaseIterable {
    case wall
    case none
}

struct Cell: Identifiable {
    let type: CellType
    
    var id: UUID = UUID()
}

extension Array where Element == Array<Cell> {
    subscript(coord: Coord) -> Cell {
        self[coord.y][coord.x]
    }
}
