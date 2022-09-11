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
            Image("wall").resizable(resizingMode: .stretch).aspectRatio(contentMode: .fill)
            
        case .none:
            Color.clear.fill()
        }
    }
    
    var columns: [GridItem] { Array(repeating: GridItem(.fixed(Constants.size)), count: logic.cells.count) }
    
    func gridTranslation(_ size: CGSize) -> CGSize {
        let x = (size.width / 2) - (Constants.size / 2) - (Constants.size * CGFloat(logic.cameraCoord.x))
        let y = (size.height / 2) - (Constants.size / 2) - (Constants.size * CGFloat(logic.cameraCoord.y))
        return CGSize(width: x, height: y)
    }
    
    var body: some View {
        VStack {
            Button("test") {
                withAnimation(.easeInOut(duration: 2)) {
                    logic.cameraCoord = (2, 2)
                }
            }
        GeometryReader { (geometry) in
            let size = geometry.size
            Image("background")
                .resizable(resizingMode: .tile)
                .overlay(alignment: .topLeading) {
                    LazyVGrid(columns: columns, alignment: .leading) {
                        ForEach(logic.cells.flatMap { $0 }) { cell in
                            cellView(cell)
                        }
                    }.offset(gridTranslation(size))
                }
        }
        }
        .onAppear {
            logic.generateMaze(16)
        }
    }
}

struct ForEachWithIndex<
    Data: RandomAccessCollection,
    Content: View
>: View where Data.Element: Identifiable, Data.Element: Hashable {
    let data: Data
    @ViewBuilder let content: (Data.Index, Data.Element) -> Content

    var body: some View {
        ForEach(Array(zip(data.indices, data)), id: \.1) { index, element in
            content(index, element)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
