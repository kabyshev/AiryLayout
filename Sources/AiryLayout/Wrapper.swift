// AiryLayout
// Created by Maxim Kabyshev. All rights reserved.
//

import UIKit

@propertyWrapper
public struct Layouting<Value: UIView> {
    public var wrappedValue: Value {
        didSet {
            bootstrap()
        }
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        bootstrap()
    }

    func bootstrap() {
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
