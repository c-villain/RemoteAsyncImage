# RemoteAsyncImage on SwiftUI

RemoteAsyncImage is a view that asynchronously loads and displays an image.

However, AsyncImage is available from iOS 15.

RemoteAsyncImage provides you an image as AsyncImage for iOS > 15 and behavior of AsyncImage for iOS < 15

## Requirements

- iOS 13.0

## Installation

#### Swift Package Manager

To integrate ```RemoteAsyncImage``` into your project using SwiftPM add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/c-villain/RemoteAsyncImage", from: "0.1.0"),
],
```
or via [XcodeGen](https://github.com/yonaskolb/XcodeGen) insert into your `project.yml`:

```yaml
name: YourProjectName
options:
  deploymentTarget:
    iOS: 13.0
packages:
  RemoteAsyncImage:
    url: https://github.com/c-villain/RemoteAsyncImage
    from: 0.1.0
targets:
  YourTarget:
    type: application
    ...
    dependencies:
       - package: RemoteAsyncImage
```

## Usage

```swift
import RemoteAsyncImage

struct YourView: View {
    
    var body: some View {
        let url = URL(
            string: "https://experience-ireland.s3.amazonaws.com/thumbs2/d07258d8-4274-11e9-9c68-02b782d69cda.800x600.jpg"
        )
        
        return VStack {
            RemoteAsyncImage(
                url: url,
                cache: Self.cache
            )
            .placeholder {
                Text("Loading ...")
            }
            .resizable()
            .scaledToFill()
            .frame(width: 104, height: 144)
            .clipped()
            
            RemoteAsyncImage(
                url: url
            )
            .placeholder {
                Text("Loading ...")
            }
            .resizable()
            .scaledToFill()
            .frame(width: 104, height: 144)
            .clipped()
            
            
            RemoteAsyncImage(
                url: url,
                placeholder: {
                    Text("Loading ...")
                }
            )
            .resizable()
            .scaledToFill()
            .frame(width: 104, height: 144)
            .clipped()
            
            RemoteAsyncImage(url: urlPig) {
                Text("Loading ...")
            }
            .resizable()
            .scaledToFill()
            .frame(width: 104, height: 144)
            .clipped()
            
        }
    }
}
```

