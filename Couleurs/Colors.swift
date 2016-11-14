//
//  Colors.swift
//  Couleurs
//
//  Created by Kamel Makhloufi on 23/09/2015.
//  Copyright © 2015 Kamel Makhloufi. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func getPixelColor(_ pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo:Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        let c = UIColor(red: r, green: g, blue: b, alpha: a)
        print(pos)
        print(c)
        return c
    }
    
    fileprivate func createARGBBitmapContext(_ inImage: CGImage) -> CGContext {
        
        //Get image width, height
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        //let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData: UnsafeMutablePointer<UInt8> = nil
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        return context!
    }
    
    func sanitizePoint(_ point:CGPoint) {
        let inImage:CGImage = self.cgImage!
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        precondition(rect.contains(point), "CGPoint passed is not inside the rect of image.It will give wrong pixel and may crash.")
    }
    
    func getPixelColorAtLocation(_ point:CGPoint)->UIColor? {
        var point = point
        let inImage:CGImage = self.cgImage!
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        point.y = CGFloat(pixelsHigh - Int(point.y))
        
        self.sanitizePoint(point)
        // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
        let context = self.createARGBBitmapContext(inImage)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        //Clear the context
        context.clear(rect)
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        context.draw(inImage, in: rect)
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        let data = context.data
        let dataType = UnsafePointer<UInt8>(data)
        
        let offset = 4*((Int(pixelsWide) * Int(point.y)) + Int(point.x))
        let alphaValue = dataType[offset]
        let redColor = dataType[offset+1]
        let greenColor = dataType[offset+2]
        let blueColor = dataType[offset+3]
        
        let redFloat = CGFloat(redColor)/255.0
        let greenFloat = CGFloat(greenColor)/255.0
        let blueFloat = CGFloat(blueColor)/255.0
        let alphaFloat = CGFloat(alphaValue)/255.0
        
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
        
        // When finished, release the context
        // Free image data memory for the context
    }
}


class Colors {
    let color1 = UIColor(red: 146.0/255.0, green: 204.0/255.0, blue: 221.0/255.0, alpha: 1.0).cgColor
    let color2 = UIColor(red: 199.0/255.0, green: 239.0/255.0, blue: 172.0/255.0, alpha: 1.0).cgColor
    let color3 = UIColor(red: 253.0/255.0, green: 196.0/255.0, blue: 236.0/255.0, alpha: 1.0).cgColor
    let color4 = UIColor(red: 115.0/255.0, green: 187.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor
    let color5 = UIColor(red: 250.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
    let color6 = UIColor(red: 255.0/255.0, green: 225.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor
    
    let gl: CAGradientLayer
    let img: UIImage
    
    init() {
        let rectSize = CGSize(width: 10,height: 1800)
        UIGraphicsBeginImageContext(rectSize)
        gl = CAGradientLayer()
        gl.frame.size = rectSize
        /*gl.colors = [color1, color2, color3, color4, color5, color6]
        gl.locations = [0.25, 0.53, 0.76, 0.85, 0.89, 0.92]*/
        gl.colors = [color6, color6, color5, color3, color2, color1]
        gl.locations = [0.08, 0.11, 0.15, 0.24, 0.47, 0.75]
        gl.render(in: UIGraphicsGetCurrentContext()!)
        img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
}
