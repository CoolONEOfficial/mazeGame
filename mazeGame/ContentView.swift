//
//  ContentView.swift
//  mazeGame
//
//  Created by Nickolay Truhin on 10.09.2022.
//

import SwiftUI
import SwiftUIX

struct ContentView: View {
    private enum Constants {
        static let size: CGFloat = 80
    }
    
    @StateObject var logic = GameLogic()
    
    @ViewBuilder
    func cellView(_ cell: Cell) -> some View {
        switch cell.type {
        case .wall:
            Image("wall").resizable().fill()
            
        case .none:
            Image("background").resizable().fill()
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("right") {
                    logic.move(to: .right)
                }
                Button("left") {
                    logic.move(to: .left)
                }
                Button("top") {
                    logic.move(to: .top)
                }
                Button("bottom") {
                    logic.move(to: .bottom)
                }
            }.zIndex(999)
            GeometryReader { (geometry) in
                let size = geometry.size
                Color.clear
                    .overlay(alignment: .topLeading) {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                            ForEach(logic.maze.flatMap { $0 }) { cell in
                                cellView(cell).height(Constants.size)
                            }
                        }.offset(gridTranslation(size))
                    }
                    .overlay {
                        let (angle, axis) = playerEffect
                        Image("player")
                            .resizable().width(Constants.size).height(Constants.size)
                            .rotation3DEffect(angle, axis: axis)
                    }
            }
        }
        .onAppear {
            logic.generateMaze(16)
        }
    }
}

private extension ContentView {
    var columns: [GridItem] { Array(repeating: GridItem(.fixed(Constants.size), spacing: 0), count: logic.maze.count) }

    func gridTranslation(_ size: CGSize) -> CGSize {
        let x = (size.width / 2) - (Constants.size / 2) - (Constants.size * CGFloat(logic.playerCoord.x))
        let y = (size.height / 2) - (Constants.size / 2) - (Constants.size * CGFloat(logic.playerCoord.y))
        return CGSize(width: x, height: y)
    }
    
    var playerEffect: (Angle, (x: CGFloat, y: CGFloat, z: CGFloat)) {
        switch logic.lookDirection {
        case .none:
            return (.degrees(0), (x: 0, y: 0, z: 0))
        case .top:
            return (.degrees(45), (x: 1, y: 0, z: 0))
        case .bottom:
            return (.degrees(-45), (x: 1, y: 0, z: 0))
        case .left:
            return (.degrees(-45), (x: 0, y: 1, z: 0))
        case .right:
            return (.degrees(45), (x: 0, y: 1, z: 0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
