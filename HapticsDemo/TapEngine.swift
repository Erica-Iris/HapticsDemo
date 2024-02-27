//
//  TapEnging.swift
//  hapticsexample
//
//  Created by Iris on 2023-08-15.
//

import Foundation
import SwiftUI
import UIKit
class GlobalModel: ObservableObject {
    @Published var intensity = 0.5
    @Published var sharpness = 0.5
}
