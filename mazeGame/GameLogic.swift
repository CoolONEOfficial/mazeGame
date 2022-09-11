//
//  GameLogic.swift
//  mazeGame
//
//  Created by Nickolay Truhin on 10.09.2022.
//

import Foundation
import SwiftUI

class GameLogic: ObservableObject {
    @Published var maze: [[Cell]] = []
    @Published var playerCoord: Coord = .init(1, 1)
    @Published var lookDirection: Direction?
    
    private func generatemaze(of type: CellType, count: Int) -> [Cell] {
        (0..<count).map { _ in Cell(type: type) }
    }
    
    private func generateFilledLine(_ size: Int) -> [Cell] {
        generatemaze(of: .wall, count: size)
    }
    
    private func generateBordersLine(_ size: Int) -> [Cell] {
        [Cell(type: .wall)] + generatemaze(of: .none, count: size - 2) + [Cell(type: .wall)]
    }
    
    func generateMaze(_ size: Int) {
        let size = max(3, size)
        
        maze = [generateFilledLine(size)] + (0..<size - 2).map { _ in generateBordersLine(size) } + [generateFilledLine(size)]
    }
    
    enum Direction {
        case top
        case bottom
        case left
        case right
    }
    
    func move(to direction: Direction) {
        var coord = playerCoord
        withAnimation(.linear(duration: 0.2)) {
            lookDirection = direction
        }
        
        var steps = 0
        while(true) {
            let nextCoord: Coord
            switch direction {
            case .top:
                nextCoord = .init(coord.x, coord.y - 1)
            case .bottom:
                nextCoord = .init(coord.x, coord.y + 1)
            case .left:
                nextCoord = .init(coord.x - 1, coord.y)
            case .right:
                nextCoord = .init(coord.x + 1, coord.y)
            }
            
            if maze[nextCoord].type == .wall {
                break
            } else {
                coord = nextCoord
                steps += 1
            }
        }

        withAnimation(.easeOut(duration: 0.2 * Double(steps))) {
            playerCoord = coord
        }
    }
}
