import UIKit

extension UIButton {
    open func sizeToMinimum44x44() {
        sizeToFit()
        var frame = self.frame
        if frame.size.width < 44 { frame.size.width = 44 }
        if frame.size.height < 44 { frame.size.height = 44 }
        self.frame = frame
    }
}

extension UIButton {
    /**
     *  Sets the background color to use as a background image for the specified state .
     *
     *  @param color The color to use for the specified state.
     *  @param state The state that uses the specified title. The values are described in ASControlState.
     */
    open func setAdjustableBackgroundColor(_ color: UIColor) {
        setBackgroundColor(color, forState: .normal)
        setBackgroundColor(color.dimmedColor(), forState: .highlighted)
    }

    open func setAdjustableBackgroundColorForAllStates(_ color: UIColor) {
        setAdjustableBackgroundColor(color)
        setBackgroundColor(color.withBrightnessMax(0.25), forState: .disabled)
        setBackgroundColor(color.dimmedColor(), forState: .selected)
    }

    open func setBackgroundColor(_ color: UIColor, forState state: UIControl.State) {
        setBackgroundImage(UIImage(color: color), for: state)
    }
}
