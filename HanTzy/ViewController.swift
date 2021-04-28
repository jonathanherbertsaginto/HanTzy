//
//  ViewController.swift
//  HanTzy
//
//  Created by Jonathan Herbert on 27/04/21.
//

import UIKit
import PencilKit
import CoreML

class ViewController: UIViewController, PKCanvasViewDelegate {
    let model = chineseHWRecognition()
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var predictionLabel: UILabel!
    var drawing = PKDrawing()
    var labels = try? String(contentsOfFile: Bundle.main.path(forResource: "labels", ofType: "txt")!, encoding: String.Encoding.utf8).components(separatedBy: "\n")
    override func viewDidLoad() {
        super.viewDidLoad()
//        let beginImage = CIImage(image: UIImage(named: "test7.png")!)
//        let filter = CIFilter(name: "CIColorInvert")
//        filter!.setValue(beginImage, forKey: kCIInputImageKey)
//        var image = UIImage(ciImage: (filter?.outputImage!)!)
        
        updateCanvas()
        canvasView.delegate = self
        canvasView.drawing = drawing
        canvasView.backgroundColor = .white
        canvasView.tool = PKInkingTool(.marker, color: .black)
        canvasView.drawingPolicy = .anyInput
        // Do any additional setup after loading the view.
    }
    func updateCanvas() {
        canvasView.layer.borderWidth = 1
        canvasView.layer.borderColor = UIColor.black.cgColor
        canvasView.layer.cornerRadius = 10
    }

    @IBAction func getStrokes(_ sender: Any) {
        for i in canvasView.drawing.strokes{
            print(i.maskedPathRanges)
            print(i.path)
            print(i.renderBounds)
            print(i.transform)
            print("___")
        }
    }
    @IBAction func predict(_ sender: Any) {
        print(canvasView.drawing.strokes.count)
        var image = canvasView.drawing.image(from:  self.canvasView.bounds, scale: 1.0)
        if canvasView.drawing.strokes.count > 0{
            image = grayscale(image: image)!
            image = invert(image: image)!

            let newArray = image.preprocess(image: image)
            print("tidak error hiya")
            var output = try? model.prediction(input_1: newArray!)
            if let b = try? UnsafeBufferPointer<Float>(output!.Identity) {
                let c = Array(b)
                var maxVal = c.max()
                var index = c.index(of: maxVal!)
                predictionLabel.text = labels?[index!]
            }
            canvasView.drawing = PKDrawing()
        
        }
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
            
            guard let cgImage = self.cgImage else { return nil }
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
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
            array[index] = NSNumber(value: element)
        }
        let newArray = array
        
        return newArray
    }
}

