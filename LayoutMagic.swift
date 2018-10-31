// swiftlint:disable:this file_name
// Layout Magic
// Created by Maxim Kabyshev on 23.07.2017. All rights reserved.
//

import UIKit

enum LayoutPinnedSide: Hashable {
    case top(CGFloat)
    case left(CGFloat)
    case right(CGFloat)
    case bottom(CGFloat)
}

enum LayoutSideDirection: Int {
    case top
    case left
    case right
    case bottom
}

extension UIView {

    func prepareForAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    // MARK: - Pin -

    /*
     All methods reverse inset's sign for .right and .bottom sides and directions.
     Also all methods call prepareForAutoLayout() - you don't need to use this method manually

     - parameter view: nil will be interpreted as the command to use view's superview
     */
    @discardableResult
    func pin(insets: UIEdgeInsets = .zero, to toView: UIView? = nil) -> UIView {

        let view = check(toView)

        safeAreaLayoutGuide.topAnchor ~ view.safeAreaLayoutGuide.topAnchor + insets.top
        safeAreaLayoutGuide.trailingAnchor ~ view.safeAreaLayoutGuide.trailingAnchor - insets.right
        safeAreaLayoutGuide.leadingAnchor ~ view.safeAreaLayoutGuide.leadingAnchor + insets.left
        safeAreaLayoutGuide.bottomAnchor ~ view.safeAreaLayoutGuide.bottomAnchor - insets.bottom

        return self
    }

    @discardableResult
    func pin(_ inset: CGFloat = 0.0) -> UIView {
        return pin(insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    @discardableResult
    func pin(excluding side: LayoutSideDirection, insets: UIEdgeInsets = .zero, to toView: UIView? = nil) -> UIView {
        switch side {
        case .top:
            pin([.left(insets.left), .right(insets.right), .bottom(insets.bottom)], to: toView)
        case .left:
            pin([.top(insets.top), .right(insets.right), .bottom(insets.bottom)], to: toView)
        case .right:
            pin([.top(insets.top), .left(insets.left), .bottom(insets.bottom)], to: toView)
        case .bottom:
            pin([.top(insets.top), .left(insets.left), .right(insets.right)], to: toView)
        }
        return self
    }

    @discardableResult
    func pin(_ direction: LayoutSideDirection, inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        return pin([side(for: direction, inset: inset)], to: toView)
    }

    @discardableResult
    func pin(_ directions: [LayoutSideDirection], inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        return pin(directions.map { side(for: $0, inset: inset) }, to: toView)
    }

    @discardableResult
    func pin(_ sides: [LayoutPinnedSide], to toView: UIView? = nil) -> UIView {

        let view = check(toView)

        sides.forEach { side in
            switch side {
            case let .top(inset):
                safeAreaLayoutGuide.topAnchor ~ view.safeAreaLayoutGuide.topAnchor + inset
            case let .right(inset):
                safeAreaLayoutGuide.trailingAnchor ~ view.safeAreaLayoutGuide.trailingAnchor - inset
            case let .left(inset):
                safeAreaLayoutGuide.leadingAnchor ~ view.safeAreaLayoutGuide.leadingAnchor + inset
            case let .bottom(inset):
                safeAreaLayoutGuide.bottomAnchor ~ view.safeAreaLayoutGuide.bottomAnchor - inset
            }
        }
        return self
    }

    @discardableResult
    func pin(_ side: LayoutPinnedSide, to toView: UIView? = nil) -> UIView {
        return pin([side], to: toView)
    }

    /*
     Example usage:

     label.pin([.top(7): .top, .left(15): .left, .right(4): .right], to: customView)

     * equally *

     label.topAnchor ~ customView.bottomAnchor + 7.0
     label.leftAnchor ~ customView.leftAnchor + 15.0
     label.rightAnchor ~ customView.rightAnchor - 4.0

     */

    @discardableResult
    func pin(_ data: [LayoutPinnedSide: LayoutSideDirection], to toView: UIView? = nil) -> UIView {

        let view = check(toView)
        let sides = Array(data.keys)
        let directions = Array(data.values)

        for (index, element) in sides.enumerated() {
            let fromSide = sides[index]
            let toSide = side(for: directions[index])
            switch element {
            case let .top(inset):
                anchorY(for: fromSide) ~ view.anchorY(for: toSide) + inset
            case let .bottom(inset):
                anchorY(for: fromSide) ~ view.anchorY(for: toSide) - inset
            case let .left(inset):
                anchorX(for: fromSide) ~ view.anchorX(for: toSide) + inset
            case let .right(inset):
                anchorX(for: fromSide) ~ view.anchorX(for: toSide) - inset
            }
        }
        return self
    }

    // MARK: - Sides, Sizes and Centering -

    /*
     Example usage:

     view.top().bottom(12).right(to: view2).left(to: .right(15), of: view3)

     * equally *

     view.topAnchor ~ superview.topAnchor
     view.bottomAnchor ~ superview.bottomAnchor - 12
     view.rightAnchor ~ view2.rightAnchor
     view.leftAnchor ~ view3.rightAnchor - 15
     */

    @discardableResult
    func centerY(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeAreaLayoutGuide.centerYAnchor ~ view.safeAreaLayoutGuide.centerYAnchor + inset
        return self
    }

    @discardableResult
    func centerX(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeAreaLayoutGuide.centerXAnchor ~ view.safeAreaLayoutGuide.centerXAnchor + inset
        return self
    }

    @discardableResult
    func height(_ inset: CGFloat = 0.0) -> UIView {
        heightAnchor ~ inset
        return self
    }

    @discardableResult
    func width(_ inset: CGFloat = 0.0) -> UIView {
        widthAnchor ~ inset
        return self
    }

    @discardableResult
    func left(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeAreaLayoutGuide.leadingAnchor ~ view.safeAreaLayoutGuide.leadingAnchor + inset
        return self
    }

    @discardableResult
    func left(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeAreaLayoutGuide.leadingAnchor ~ view.anchorX(for: side) + inset
        return self
    }

    @discardableResult
    func right(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeAreaLayoutGuide.trailingAnchor ~ view.safeAreaLayoutGuide.trailingAnchor - inset
        return self
    }

    @discardableResult
    func right(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeAreaLayoutGuide.trailingAnchor ~ view.anchorX(for: side) - inset
        return self
    }

    @discardableResult
    func top(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeAreaLayoutGuide.topAnchor ~ view.safeAreaLayoutGuide.topAnchor + inset
        return self
    }

    @discardableResult
    func top(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeAreaLayoutGuide.topAnchor ~ view.anchorY(for: side) + inset
        return self
    }

    @discardableResult
    func bottom(_ inset: CGFloat = 0.0, to toView: UIView? = nil) -> UIView {
        let view = check(toView)
        safeAreaLayoutGuide.bottomAnchor ~ view.safeAreaLayoutGuide.bottomAnchor - inset
        return self
    }

    @discardableResult
    func bottom(to side: LayoutPinnedSide, of toView: UIView? = nil) -> UIView {
        let view = check(toView)
        let (_, inset) = direction(from: side)
        safeAreaLayoutGuide.bottomAnchor ~ view.anchorY(for: side) - inset
        return self
    }
}

// MARK: - Private Methods

private extension UIView {

    @inline(__always)
    private func check(_ view: UIView?) -> UIView {
        guard view == nil else {
            translatesAutoresizingMaskIntoConstraints = false
            return view! // swiftlint:disable:this force_unwrapping
        }
        guard let superview = superview else {
            fatalError("No superview for your view and also parameter `view` is nil")
        }
        translatesAutoresizingMaskIntoConstraints = false
        return superview
    }

    @inline(__always)
    private func side(for direction: LayoutSideDirection, inset: CGFloat = 0.0) -> LayoutPinnedSide {
        switch direction {
        case .top:
            return LayoutPinnedSide.top(inset)
        case .left:
            return LayoutPinnedSide.left(inset)
        case .right:
            return LayoutPinnedSide.right(inset)
        case .bottom:
            return LayoutPinnedSide.bottom(inset)
        }
    }

    @inline(__always)
    private func direction(from side: LayoutPinnedSide) -> (LayoutSideDirection, CGFloat) {
        switch side {
        case let .top(inset):
            return (.top, inset)
        case let .left(inset):
            return (.left, inset)
        case let .right(inset):
            return (.right, inset)
        case let .bottom(inset):
            return (.bottom, inset)
        }
    }

    @inline(__always)
    private func anchorX(for side: LayoutPinnedSide) -> NSLayoutXAxisAnchor {
        switch side {
        case .right:
            return safeAreaLayoutGuide.trailingAnchor
        case .left:
            return safeAreaLayoutGuide.leadingAnchor
        default:
            fatalError("Something went wrong")
        }
    }

    @inline(__always)
    private func anchorY(for side: LayoutPinnedSide) -> NSLayoutYAxisAnchor {
        switch side {
        case .top:
            return safeAreaLayoutGuide.topAnchor
        case .bottom:
            return safeAreaLayoutGuide.bottomAnchor
        default:
            fatalError("Something went wrong")
        }
    }
}

extension NSLayoutDimension {

    func aspectFit(to: NSLayoutDimension, as aspectCoefficient: CGFloat) {
        constraint(equalTo: to, multiplier: aspectCoefficient).isActive = true
    }
}

// MARK: - Public Structures

struct ConstraintAttribute<T: AnyObject> {
    let anchor: NSLayoutAnchor<T>
    let const: CGFloat
}

struct LayoutGuideAttribute {
    let guide: UILayoutSupport
    let const: CGFloat
}

func + <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: rhs)
}

func + (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: rhs)
}

func + <T>(lhs: ConstraintAttribute<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs.anchor, const: lhs.const + rhs)
}

func - <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: -rhs)
}

func - (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: -rhs)
}

func - <T>(lhs: ConstraintAttribute<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs.anchor, const: lhs.const - rhs)
}

precedencegroup LayoutMagicEquivalence {
    higherThan: ComparisonPrecedence
    lowerThan: AdditionPrecedence
}

infix operator ~: LayoutMagicEquivalence
infix operator <~: LayoutMagicEquivalence
infix operator ~>: LayoutMagicEquivalence

@discardableResult
func ~ (lhs: NSLayoutYAxisAnchor, rhs: UILayoutSupport) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.bottomAnchor)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~ <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~ <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~ (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~ (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~ (lhs: NSLayoutYAxisAnchor, rhs: LayoutGuideAttribute) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.guide.bottomAnchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~ (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
func <~ <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
func <~ (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
func <~ (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~> <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~> (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~> (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ~> (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
} // swiftlint:disable:this file_length
