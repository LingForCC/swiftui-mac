//
//  DetailView.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 6/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let httpStatus: HttpStatus

    @State private var catImage: NSImage?
    @State private var imageIsFlipped = false
    
    private let flipImageMenuItemSelected = NotificationCenter.default
        .publisher(for: .flipImage)
    
    var body: some View {
        VStack {
            Text("HTTP Status Code: \(httpStatus.code)")
                .font(.headline)
                .padding()
            Text(httpStatus.title)
                .font(.title)
            
            if catImage != nil {
                ZStack {
                    Image(nsImage: catImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotation3DEffect(Angle(degrees: imageIsFlipped ? 180 : 0),
                                          axis: (x: 0, y: 1, z: 0))
                        .animation(.default)
                    }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.getCatImage()
        }
        .onReceive(flipImageMenuItemSelected) { _ in
            DispatchQueue.main.async {
                self.imageIsFlipped.toggle()
            }
        }
    }
    
    func getCatImage() {
        let url = httpStatus.imageUrl
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                DispatchQueue.main.async {
                    self.catImage = NSImage(data: data)
                }
            }
        }
        task.resume()
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(httpStatus: HttpStatus(code: "404", title: "Not Found"))
            .environmentObject(Prefs())
    }
}