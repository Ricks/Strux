//
//  ContentView.swift
//  StruxApp
//
//  Created by Richard Clark on 5/5/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//

import SwiftUI
import UIKit

struct TextView: UIViewRepresentable {
    @Binding var text: String
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.backgroundColor = .lightGray
        view.isEditable = false
        view.isUserInteractionEnabled = false
        view.contentInset = UIEdgeInsets(top: 5,
            left: 10, bottom: 5, right: 5)
        view.delegate = context.coordinator
        view.font = UIFont(name: "System", size: 32)
        return view
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    func makeCoordinator() -> TextView.Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UITextViewDelegate {
        var control: TextView
        init(_ control: TextView) {
            self.control = control
        }
        func textViewDidChange(_ textView: UITextView) {
            print("textViewDidChange")
            if textView.contentSize.height < textView.bounds.size.height { return }
            let bottomOffset = CGPoint(x: 0, y: textView.contentSize.height - textView.bounds.size.height)
            textView.setContentOffset(bottomOffset, animated: true)
        }
    }
}

struct ContentView: View {
    @ObservedObject var treeModel = BSTreeModel()
    @ObservedObject var heapModel = HeapModel()
    @ObservedObject var queueModel = QueueModel()
    @ObservedObject var disjointSetModel = DisjointSetModel()
    var body: some View {
        VStack {
            Group {
                Button(action: { self.queueModel.startProcessing() }) {
                    Text("Queue")
                }
                TextView(text: $queueModel.output)
                    .font(.title)
                    .frame(height: 50)
                Text("Time: \(String(format: "%.2f", queueModel.time))")
            }
            Spacer()
            Group {
                Button(action: { self.heapModel.startProcessing() }) {
                    Text("Heap")
                }
                TextView(text: $heapModel.output)
                    .font(.title)
                    .frame(height: 50)
                Text("Time: \(String(format: "%.2f", heapModel.time))")
            }
            Spacer()
            Group {
                Button(action: { self.treeModel.startProcessing() }) {
                    Text("BSTree")
                }
                TextView(text: $treeModel.output)
                    .font(.title)
                    .frame(height: 50)
                Text("Time: \(String(format: "%.2f", treeModel.time))")
            }
            Spacer()
            Group {
                Button(action: { self.disjointSetModel.startProcessing() }) {
                    Text("DisjointSetTree")
                }
                TextView(text: $disjointSetModel.output)
                    .font(.title)
                    .frame(height: 50)
                Text("Time: \(String(format: "%.2f", disjointSetModel.time))")
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
