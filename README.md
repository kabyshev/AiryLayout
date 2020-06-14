# AiryLayout 🍃
A simple Auto Layout wrapper - write readable layouts!

[![Language: Swift 4.2](https://img.shields.io/badge/language-swift%204-f48041.svg?style=flat)](https://developer.apple.com/swift)

### Simple Example:
```swift
label.top(10).left(5).right(20).bottom()
```

### Pins edge to edge and with inset:
```swift
tableView.pin()
scrollView.pin(10)
```

### Different components:
```swift
label.topAnchor ~ customView.bottomAnchor + 7.0
label.leftAnchor ~ customView.leftAnchor + 15.0
label.rightAnchor ~ customView.rightAnchor - 4.0
```
### Equals more compact API:
```swift
label.pin([.top(7): .bottom, .left(15): .left, .right(4): .right], to: customView)
```

### Combinations:
```swift
button
   .left(to: .right(10), of: label)
   .top(to: switcher)
   .right(24).width(22)
   
button2.pin([.top(0): .top, .left(10): .right], to: label2).width(22)
```

### Disabling safe area API
```swift
collectionView.left().right().withoutSafeArea { $0.top().bottom() }
```
