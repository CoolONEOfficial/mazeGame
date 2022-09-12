//
//  CGSize++.swift
//  mazeGame
//
//  Created by Nickolay Truhin on 12.09.2022.
//

import Foundation
import CoreGraphics

func + (left: CGSize, right: CGSize) -> CGSize {
    CGSize(width: left.width + right.width, height: left.height + right.height)
}
