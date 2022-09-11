//
//  swift
//  mazeGame
//
//  Created by Nickolay Truhin on 11.09.2022.
//

import Foundation

struct Coord {
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    let x: Int
    let y: Int
}

extension Coord {
    func moved(to direction: Direction) -> Self {
        switch direction {
        case .top:
            return .init(x, y - 1)
        case .bottom:
            return .init(x, y + 1)
        case .left:
            return .init(x - 1, y)
        case .right:
            return .init(x + 1, y)
        }
    }
}
