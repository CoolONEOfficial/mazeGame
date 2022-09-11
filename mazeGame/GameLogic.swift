//
//  GameLogic.swift
//  mazeGame
//
//  Created by Nickolay Truhin on 10.09.2022.
//

import Foundation
import SwiftUI

enum CellType {
    case wall
    case none
}

struct Cell: Identifiable {
    let type: CellType
    
    var id: UUID = UUID()
}

class GameLogic: ObservableObject {
    @Published var cells: [[Cell]] = []
    @Published var cameraCoord: (x: Int, y: Int) = (1, 1)
    
    private func generateCells(of type: CellType, count: Int) -> [Cell] {
        (0..<count).map { _ in Cell(type: type) }
    }
    
    private func generateFilledLine(_ size: Int) -> [Cell] {
        generateCells(of: .wall, count: size)
    }
    
    private func generateBordersLine(_ size: Int) -> [Cell] {
        [Cell(type: .wall)] + generateCells(of: .none, count: size - 2) + [Cell(type: .wall)]
    }
    
    func generateMaze(_ size: Int) {
        let size = max(3, size)
        
        cells = [generateFilledLine(size)] + (0..<size - 2).map { _ in generateBordersLine(size) } + [generateFilledLine(size)]
    }
}
