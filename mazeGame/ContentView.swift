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
        static let arrowsSize: CGFloat = 120
    }
    
    @StateObject var logic = GameLogic()
    @State var showingPopover = false
    
    @ViewBuilder
    func cellView(_ cell: Cell) -> some View {
        switch cell.type {
        case .wall:
            Image("wall").resizable().fill()
            
        case .none:
            Image("background").resizable().fill()
        }
    }
    
    var arrowsView: some View {
        let stackSize = Constants.arrowsSize * 3 + 12 * 2
        return ZStack(alignment: .center) {
            VStack {
                Button(
                    action: { logic.move(to: .top, used: .arrows) },
                    label: { Image("top").resizable().height(Constants.arrowsSize) }
                )
                Spacer()
                Button(
                    action: { logic.move(to: .bottom, used: .arrows) },
                    label: { Image("bottom").resizable().height(Constants.arrowsSize) }
                )
            }.width(Constants.arrowsSize)
            HStack {
                Button(
                    action: { logic.move(to: .left, used: .arrows) },
                    label: { Image("left").resizable().width(Constants.arrowsSize) }
                )
                Spacer()
                Button(
                    action: { logic.move(to: .right, used: .arrows) },
                    label: { Image("right").resizable().width(Constants.arrowsSize) }
                )
            }.height(Constants.arrowsSize)
            Button(
                action: { logic.placeFlag() },
                label: { Image("center").resizable()
                    .height(Constants.arrowsSize * 0.7)
                    .width(Constants.arrowsSize * 0.7) }
            )
        }
        .width(stackSize)
        .height(stackSize)
        .padding(32)
    }
    
    var body: some View {
        GeometryReader { (geometry) in
            let size = geometry.size
            Color.clear
                .overlay(alignment: .topLeading) {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                        ForEach(logic.maze.flatMap { $0 }) { cell in
                            cellView(cell).height(Constants.size)
                        }
                    }
                    .onSwipe(
                        up: { logic.move(to: .top, used: .gestures) },
                        left: { logic.move(to: .left, used: .gestures) },
                        down: { logic.move(to: .bottom, used: .gestures) },
                        right: { logic.move(to: .right, used: .gestures) }
                    )
                    .offset(gridTranslation(size))
                }
                .overlay(alignment: .topLeading) {
                    if let flagCoord = logic.flagCoord {
                        Image("flag")
                            .resizable()
                            .width(Constants.size).height(Constants.size)
                            .offset(translation(size, for: flagCoord))
                    }
                }
                .overlay {
                    let (angle, axis) = playerEffect
                    Image("player")
                        .resizable()
                        .width(Constants.size).height(Constants.size)
                        .scaleEffect(CGSize(width: logic.lookDirection == .left ? -1.0 : 1.0, height: 1.0))
                        .rotation3DEffect(angle, axis: axis)
                }
                .overlay(alignment: logic.leftHanded ? .bottomLeading : .bottomTrailing) {
                    if logic.controlStyle == .arrows {
                        arrowsView
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Button("Settings") {
                        showingPopover = true
                    }
                    .padding(32)
                    .popover(isPresented: $showingPopover) {
                        VStack {
                            Picker("Controls", selection: $logic.controlStyle) {
                                Text("Gestures").tag(ControlStyle.gestures)
                                Text("Arrows").tag(ControlStyle.arrows)
                            }
                            .pickerStyle(.segmented)
                            Toggle(isOn: $logic.leftHanded) { Text("Left handed") }
                        }.padding().minWidth(300)
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
    
    func translation(_ size: CGSize, for coord: Coord) -> CGSize {
        let x = (Constants.size * CGFloat(coord.x))
        let y = (Constants.size * CGFloat(coord.y))
        return gridTranslation(size) + CGSize(width: x, height: y)
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
