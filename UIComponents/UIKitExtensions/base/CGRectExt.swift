import Foundation
import UIKit

public extension CGRect {
    var topLeft: CGPoint {
        origin
    }

    var topRight: CGPoint {
        CGPoint(x: origin.x + size.width,
                y: origin.y)
    }

    var bottomLeft: CGPoint {
        CGPoint(x: origin.x,
                y: origin.y + size.height)
    }

    var bottomRight: CGPoint {
        CGPoint(x: origin.x + size.width,
                y: origin.y + size.height)
    }
}
