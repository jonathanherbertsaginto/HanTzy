//
//  imagePreprocess.swift
//  HanTzy
//
//  Created by Jonathan Herbert on 03/05/21.
//

import Foundation
import CoreML
import UIKit

class imagePreprocess{
    let model = chineseHWRecognition()
    
    func predict(image: UIImage, index : Int) -> Float {
        let grayimage = grayscale(image: image)!
        let invertimage = invert(image: grayimage)!
        
        let output = try? model.prediction(input_1: invertimage.preprocess(image: invertimage)!)
        if let b = try? UnsafeBufferPointer<Float>(output!.Identity) {
            let c = Array(b)
            return c[index]
        }
        return 0
    }
    
    func grayscale(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectNoir") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
    func invert(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
}

extension UIImage{
    public func resize(to newSize: CGSize) -> UIImage {
                    UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 1.0)
            self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return resizedImage
    }
    public func pixelData() -> [UInt8]? {
            let dataSize = size.width * size.height * 4
            var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: &pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(size.width), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
            
            let cgImage = self.cgImage
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            return pixelData
    }
    func preprocess(image: UIImage) -> MLMultiArray? {
        let size = CGSize(width: 96, height: 96)

        guard let pixels = image.resize(to: size).pixelData()?.map({ (Double($0) / 255.0)}) else {
            return nil
        }

        guard let array = try? MLMultiArray(shape: [1, 96, 96,1], dataType: .float32) else {
            return nil
        }
                
        let r = pixels.enumerated().filter { $0.offset % 4 == 0 }.map { $0.element }
        let g = pixels.enumerated().filter { $0.offset % 4 == 1 }.map { $0.element }
        let b = pixels.enumerated().filter { $0.offset % 4 == 2 }.map { $0.element }
                
        let combination = r + g + b
        for (index, element) in combination.enumerated() {
            if index < array.count {
                array[index] = NSNumber(value: element)
            }
        }
        
        return array
    }
}

