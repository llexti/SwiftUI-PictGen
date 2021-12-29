//
//  ContentView.swift
//  SwiftUI-PictGen
//
//  Created by Laurent Lefevre on 25/12/2021.
// https://www.youtube.com/watch?v=Rt9-5Tm8vk4
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-document-based-app-using-filedocument-and-documentgroup
// https://capps.tech/blog/read-files-with-documentpicker-in-swiftui


import SwiftUI

struct ContentView: View {
    @State private var fileContent = UIImage(named:"icon1024x1024.png")!.pngData()
    @State private var showSelectPicture = false
    @State private var generatedPictures :[String] = []
    @State private var prefixName = "icon"
    @State private var saveInLibrary = false
    @State private var saveInCloud = false
    private var pictsizes = [1024,180,167,152,120,87,80,76,60,58,40,29,20]
    var body: some View {
        NavigationView {
            VStack {
                Image (uiImage: UIImage(data: fileContent!)!)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .background(Color.white)
                Text ("Select a square png min 1024x1024")
                    .foregroundColor(.blue)
                    .font(.footnote)
                Form {
                    TextField("Prefix name", text: $prefixName)
                    //Toggle("Save in photo library", isOn: $saveInLibrary.animation())
                    //Toggle("Save in iCloud", isOn: $saveInCloud.animation())

                    Button ("Generate pictures"){
                        let photolibrary = ImageSaver()
                        for item in pictsizes {
                            if let image = UIImage(data: fileContent!)?.resize(targetSize: CGFloat(item)) {
                                if saveInLibrary {
                                    photolibrary.writeToPhotoAlbum(image: image)
                                }
                                if image.save(tofile: "\(prefixName)\(item)x\(item).png", forCloud: saveInCloud) {
                                    generatedPictures.append("Image \(item) x \(item)")
                                }
                            }
                        }
                    }
               }
            }
            .navigationBarItems(trailing: Button(action: {
                self.showSelectPicture = true
                } ) {
                Image(systemName: "folder.badge.plus")
                    .foregroundColor(.blue)
            } )
            .navigationBarTitle(Text("Pictures generator"), displayMode: .inline)
            .padding()

            
            List {
                ForEach (generatedPictures,id:\.self) { item in
                    Text (item)
                }
            }
            .navigationTitle(Text("Generation result"))

        }
        .sheet(isPresented: $showSelectPicture) {
            PickerDocument (fileContent: $fileContent)
        }

    }
    
    
}


struct PickerDocument: UIViewControllerRepresentable {
    @Binding var fileContent: Data?
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PickerDocument>) ->  UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController (forOpeningContentTypes: [.png], asCopy: true)
        
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }
}

class DocumentPickerCoordinator:NSObject,UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @Binding var fileContent:Data?
    
    init (fileContent:Binding<Data?>) {
        _fileContent = fileContent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let file = urls[0]
        if let data = try? Data (contentsOf: file) {
            fileContent = data //Image (uiImage: UIImage(data: data)!)
        }
 //file.absoluteString //Image (file.path)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
