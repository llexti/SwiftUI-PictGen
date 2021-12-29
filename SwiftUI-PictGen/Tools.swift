//
//  Tools.swift
//  SwiftUI-PictGen
//
//  Created by Laurent Lefevre on 25/12/2021.
//

import Foundation
import UIKit

extension UIImage {
    //
    // Save Image
    //
    func save (tofile: String, forCloud:Bool) -> Bool {
        guard let data = self.pngData() else {
            return false
        }
        if (forCloud) {
            if let directory = FileManager.default.url(forUbiquityContainerIdentifier: nil)  {
                do {
                    try data.write(to: directory.appendingPathComponent(tofile))
                    return true
                } catch {
                    print(error.localizedDescription)
                    return false
                }
            } else {
                return false
            }

        } else { // Else of if (forCloud) {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let filePath = paths[0].appendingPathComponent(tofile)
            do  {
                try data.write(to: filePath,options: .atomic)
                return true
            } catch let err {
                print("Saving file resulted in error: ", err)
                return false
            }
        } // End of if (forCloud) {
    }
    
    
    func resize(targetSize: CGFloat) -> UIImage {
        let newSize = CGSize(width: targetSize, height: targetSize)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        UIColor.white.set()

        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}


class ImageSaver: NSObject {
    // use:
    // let imageSaver = ImageSaver()
    // imageSaver.writeToPhotoAlbum(image: inputImage)
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
}
