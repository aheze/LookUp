//
//  Utilities.swift
//  LookUp
//  
//  Created by Andrew Zheng (github.com/aheze) on 4/19/24.
//  Copyright © 2024 Andrew Zheng. All rights reserved.
//

import SwiftUI

enum Utilities {}

extension Utilities {
    static func interpolate(a: Double, b: Double, percent: Double) -> Double {
        let track = b - a
        let value = a + (track * percent)
        return value
    }
    
    static func interpolate(a: CGFloat, b: CGFloat, percent: CGFloat) -> CGFloat {
        let track = b - a
        let value = a + (track * percent)
        return value
    }
    
    static func percentage(trackStart: Double, trackEnd: Double, value: Double, cap: Bool) -> Double {
        let value = (value - trackStart) / (trackEnd - trackStart)
        
        if cap {
            return min(max(0, value), 1)
        } else {
            return value
        }
    }
    
    static func percentage(trackStart: CGFloat, trackEnd: CGFloat, value: CGFloat, cap: Bool) -> CGFloat {
        let value = (value - trackStart) / (trackEnd - trackStart)
        
        if cap {
            return min(max(0, value), 1)
        } else {
            return value
        }
    }
}

extension UIView {
    func pinEdgesToSuperview() {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor)
        ])
    }
}

extension UIViewController {
    func addChildViewController(_ childViewController: UIViewController, in view: UIView) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        
        /// Configure child view
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        /// Notify child view controller
        childViewController.didMove(toParent: self)
    }
    
    /// Add a child view controller inside a view with constraints.
    func embed(_ childViewController: UIViewController, in view: UIView) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        
        childViewController.view.pinEdgesToSuperview()
        
        /// Notify the child view controller.
        childViewController.didMove(toParent: self)
    }
    
    func removeChildViewController(_ childViewController: UIViewController) {
        /// Notify child view controller
        childViewController.willMove(toParent: nil)
        
        /// Remove child view from superview
        childViewController.view.removeFromSuperview()
        
        /// Notify child view controller again
        childViewController.removeFromParent()
    }
}

extension UIView {
    /// add a border to a view
    func addDebugBorders(_ color: UIColor, width: CGFloat = 0.75) {
        backgroundColor = color.withAlphaComponent(0.2)
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}

extension Color {
    init(hex: Int, opacity: CGFloat = 1) {
        self.init(hex: UInt(hex), opacity: opacity)
    }
    
    init(hex: UInt, opacity: CGFloat = 1) {
        self.init(
            .displayP3,
            red: Double((hex & 0xFF0000) >> 16) / 255,
            green: Double((hex & 0x00FF00) >> 8) / 255,
            blue: Double(hex & 0x0000FF) / 255,
            opacity: opacity
        )
    }
}

extension UIColor {
    convenience init(hex: Int, opacity: CGFloat = 1) {
        self.init(hex: UInt(hex), opacity: opacity)
    }
    
    convenience init(hex: UInt, opacity: CGFloat = 1) {
        self.init(
            red: Double((hex & 0xFF0000) >> 16) / 255,
            green: Double((hex & 0x00FF00) >> 8) / 255,
            blue: Double(hex & 0x0000FF) / 255,
            alpha: opacity
        )
    }
}

/// from https://stackoverflow.com/a/68555127/14351818
extension View {
    func overlay<Target: View>(align originAlignment: Alignment, to targetAlignment: Alignment, @ViewBuilder of target: () -> Target) -> some View {
        let hGuide = HorizontalAlignment(Alignment.TwoSided.self)
        let vGuide = VerticalAlignment(Alignment.TwoSided.self)
        
        return alignmentGuide(hGuide) { $0[originAlignment.horizontal] }
            .alignmentGuide(vGuide) { $0[originAlignment.vertical] }
            .overlay(alignment: Alignment(horizontal: hGuide, vertical: vGuide)) {
                target()
                    .alignmentGuide(hGuide) { $0[targetAlignment.horizontal] }
                    .alignmentGuide(vGuide) { $0[targetAlignment.vertical] }
            }
    }
}

extension Alignment {
    enum TwoSided: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat { 0 }
    }
}


public extension View {
    @inlinable
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        padding: CGFloat = 0, /// extra negative padding for shadows
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .padding(-padding)
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}

func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    return sqrt(CGPointDistanceSquared(from: from, to: to))
}
