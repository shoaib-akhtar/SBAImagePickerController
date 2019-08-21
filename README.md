# SBAImagePickerController
An easy multiple image picker controller for photo library.

![CocoaPods](https://cocoapod-badges.herokuapp.com/v/SBAImagePickerController/badge.png)

<p align="center">
<a href="https://imgflip.com/gif/37ft7x"><img src="https://i.imgflip.com/37ft7x.gif" title="made at imgflip.com"/></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://imgflip.com/gif/38fus8"><img src="https://i.imgflip.com/38fus8.gif" title="made at imgflip.com"/></a>
</p>


Installation
------------

Use [CocoaPods](http://cocoapods.org).

```ruby
pod 'SBAImagePickerController'
```
Usage
-----
Show SBAImagePickerController

```swift
    let controller = SBAMultipleImagePickerController.init(rootViewCOntroler: self,maximumImages: 5) {[weak self] (images, cancel) in
        guard let _ = self else{return}
        print(images?.count ?? 0)
     }
     controller.push()
```

Present SBAImagePickerController

```swift
   let coordinator = SBAMultipleImagePickerController.init(rootViewCOntroler: self,maximumImages: 5) {[weak self] (images, cancel) in
       guard let _ = self else{return}
       print(images?.count ?? 0)
    }
    coordinator.present()
```

Translate
```swift
    coordinator.translate {[weak self] (key) -> String in
         guard let _ = self else{return ""}
         return NSLocalizedString(key, comment: "")
    }
```
Congratulations! You're done.

License
-------

SBAImagePickerController is under [MIT](https://opensource.org/licenses/MIT). See [LICENSE](LICENSE) file for more info.
