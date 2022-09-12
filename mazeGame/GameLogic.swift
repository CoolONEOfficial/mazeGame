//
//  GameLogic.swift
//  mazeGame
//
//  Created by Nickolay Truhin on 10.09.2022.
//

import Foundation
import SwiftUI

enum ControlStyle: Hashable {
    case gestures
    case arrows
}

class GameLogic: ObservableObject {
    @Published var maze: [[Cell]] = []
    @Published var playerCoord: Coord = .init(1, 1)
    @Published var flagCoord: Coord?
    @Published var lookDirection: Direction?
    
    @Published var controlStyle: ControlStyle = .arrows
    @Published var leftHanded = false
    
    private var moveLock: Bool = false
    
    private func generateCells(of type: CellType, count: Int) -> [Cell] {
        (0..<count).map { _ in Cell(type: type) }
    }
    
    private func generateFilledCells(_ size: Int) -> [Cell] {
        generateCells(of: .wall, count: size)
    }
    
    private func generateFilledCellsWithHole(_ size: Int) -> [Cell] {
        let holeIndex = (1..<size - 1).randomElement()!
        var cells = generateFilledCells(size)
        cells[holeIndex] = .init(type: .none)
        return cells
    }
    
    private func generateBordersCells(_ size: Int) -> [Cell] {
        [Cell(type: .wall)] + generateCells(of: .none, count: size - 2) + [Cell(type: .wall)]
    }
    
    func generateMaze(_ size: Int) {
        let size = max(3, size)
        
        maze = [generateFilledCells(size)] + (0..<size - 2).map { num in num % 2 == 0 ? generateBordersCells(size) : generateFilledCellsWithHole(size) } + [generateFilledCells(size)]
    }
    
    func move(to direction: Direction, used controlStyle: ControlStyle) {
        guard !moveLock, self.controlStyle == controlStyle else { return }
        moveLock = true
        var coord = playerCoord
        withAnimation(.linear(duration: 0.2)) {
            lookDirection = direction
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [maze, weak self] in
            guard let self = self else { return }
            var steps = 0
            while(true) {
                let nextCoord: Coord
                nextCoord = coord.moved(to: direction)
                
                let neightborCoords: [Coord]
                
                if steps > 0 {
                    switch direction {
                    case .top, .bottom:
                        neightborCoords = [ coord.moved(to: .left), coord.moved(to: .right) ]
                        
                    case .left, .right:
                        neightborCoords = [ coord.moved(to: .top), coord.moved(to: .bottom) ]
                    }
                } else {
                    neightborCoords = []
                }
                
                if maze[nextCoord].type == .wall || neightborCoords.contains(where: { neightborCoord in maze[neightborCoord].type == .none }) {
                    break
                } else {
                    coord = nextCoord
                    steps += 1
                }
            }

            let duration = 0.2 * Double(steps)
            withAnimation(.easeOut(duration: duration)) {
                self.playerCoord = coord
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.moveLock = false
            }
        }
    }
    
    func placeFlag() {
        if let flagCoord = flagCoord, flagCoord == playerCoord {
            self.flagCoord = nil
        } else {
            flagCoord = playerCoord
        }
    }
}
