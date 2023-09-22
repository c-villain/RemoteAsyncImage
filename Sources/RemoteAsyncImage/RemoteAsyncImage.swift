import SwiftUI

public struct RemoteAsyncImage: View {
    
    @ObservedObject private var loader: ImageLoader
    public let url: URL?
    
    private var placeholder: AnyView? = AnyView(Color.clear)
    
    private var configurations: [(Image) -> Image] = []

    // MARK: - inits with URL
    public init(url: URL?, cache: ImageCache?) {
        self.url = url
        loader = ImageLoader(url: url, cache: cache)
        loader.load()
    }
    
    public init(url: URL?) {
        self.init(
            url: url,
            cache: TemporaryImageCache()
        )
    }
    
    // MARK: - inits with URL string
    public init(_ urlString: String?, cache: ImageCache?) {
        let urlString = urlString?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
        self.url = URL(string: urlString)
        loader = ImageLoader(url: url, cache: cache)
        loader.load()
    }
    
    public init(_ urlString: String?) {
        self.init(
            urlString,
            cache: TemporaryImageCache()
        )
    }
    
    // MARK: - inits with placeholder
    public init<Content: View>(
        url: URL?,
        cache: ImageCache?,
        @ViewBuilder placeholder: () -> Content
    ) {
        self.url = url
        loader = ImageLoader(url: url, cache: cache)
        loader.load()
        self.placeholder = AnyView(placeholder())
    }
    
    public init<Content: View>(
        url: URL?,
        @ViewBuilder placeholder: () -> Content
    ) {
        self.init(
            url: url,
            cache: TemporaryImageCache(),
            placeholder: placeholder
        )
    }
    
    // MARK: - configures
    public func configure(_ block: @escaping (Image) -> Image) -> RemoteAsyncImage {
        var result = self
        result.configurations.append(block)
        return result
    }
    
    public func resizable() -> RemoteAsyncImage {
        configure { $0.resizable() }
    }
    
    public func renderingMode(_ mode: Image.TemplateRenderingMode) -> RemoteAsyncImage {
        configure { $0.renderingMode(mode) }
    }
    
    public func placeholder<Content: View>(@ViewBuilder _ content: () -> Content) -> RemoteAsyncImage {
        let v = content()
        var result = self
        result.placeholder = AnyView(v)
        return result
    }
    
    public var body: some View {
        Group {
            if loader.image != nil {
                configurations
                    .reduce(Image(uiImage: loader.image ?? UIImage()).renderingMode(.original)) {
                        current, config in config(current)
                    }
            } else {
                placeholder
            }
        }
        .onAppear(perform: loader.load)
        .onDisappear(perform: loader.cancel)
    }
}


struct RemoteAsyncImage_Previews: PreviewProvider {
    @Environment(\.imageCache) static var cache: ImageCache
    
    static var previews: some View {
        
        let url = URL(
            string: "https://experience-ireland.s3.amazonaws.com/thumbs2/d07258d8-4274-11e9-9c68-02b782d69cda.800x600.jpg"
        )
        
        VStack {
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
            
            RemoteAsyncImage(url: url) {
                Text("Loading ...")
            }
            .resizable()
            .scaledToFill()
            .frame(width: 104, height: 144)
            .clipped()
            
        }.previewLayout(.sizeThatFits)
    }
}


