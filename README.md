# PinLayoutKit
Simple AutoLayout wrapper - write readable layouts!

[![Language: Swift 4.2](https://img.shields.io/badge/language-swift%204-f48041.svg?style=flat)](https://developer.apple.com/swift)

### Example:
```swift
label.topAnchor ~ customView.bottomAnchor + 7.0
label.leftAnchor ~ customView.leftAnchor + 15.0
label.rightAnchor ~ customView.rightAnchor - 4.0
```
### Equals more compact API:
```swift
label.pin([.top(7): .bottom, .left(15): .left, .right(4): .right], to: customView)
```

### Pins edge to edge and with inset also:
```swift
tableView.pin()
scrollView.pin(10)
```

### Combinations:
```swift
button
   .left(to: .right(10), of: label)
   .top(to: switcher)
   .right(24).width(22)
   
button2.pin([.top(0): .top, .left(10): .right], to: label2).width(22)
```
