//
//  ImageLoader.swift
//  Pods-send-kin-module-ios_Example
//
//  Created by Natan Rolnik on 02/07/19.
//

import Foundation

private var AssociatedObjectHandle: UInt8 = 0

private extension UIImageView {
    var remoteURL: URL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? URL
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

class ImageLoader {
    class func loadImage(at url: URL, for imageView: UIImageView, animated: Bool = true, placeholder: UIImage? = nil) {
        if let placeholder = placeholder {
            imageView.image = placeholder
        }

        //TODO: try to load first from cache

        imageView.remoteURL = url
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                imageView.remoteURL == url,
                let data = data,
                let image = UIImage(data: data) else {
                    return
            }

            //TODO: save on cache

            DispatchQueue.main.async {
                UIView.transition(with: imageView,
                                  duration: animated ? 0.3 : 0,
                                  options: .transitionCrossDissolve,
                                  animations: { imageView.image = image },
                                  completion: nil)
            }
            }.resume()
    }
}
