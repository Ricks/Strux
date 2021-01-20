//
//  ContentView.swift
//  StruxMacApp
//
//  Created by Richard Clark on 5/15/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//

import SwiftUI

struct TextView: NSViewRepresentable {
    typealias NSViewType = NSTextView

    @Binding var text: String

    func makeNSView(context: Self.Context) -> Self.NSViewType {
        let view = NSTextView()
        view.isEditable = true
        view.isRulerVisible = true
        return view
    }

    func updateNSView(_ nsView: Self.NSViewType, context: Self.Context) {
        nsView.string = text
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
                    Text("DisjointSet")
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
