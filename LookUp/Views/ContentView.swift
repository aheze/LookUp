//
//  ContentView.swift
//  LookUp
//
//  Created by Andrew Zheng (github.com/aheze) on 4/19/24.
//  Copyright © 2024 Andrew Zheng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ViewModel()
    @StateObject var graphViewModel = GraphViewModel()

    @State var showingPermissions = false

    var body: some View {
        VStack {
            Text("LookUp")
                .bold()

            Text("Find connections between people.")

            Button("Initiate Graph") {
                showingPermissions = true
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)

            Button("Get Graph") {
                Task {
                    do {
                        let graph = try await Networking.getGraph(phoneNumber: "9252149133", targetDepth: 2)

                        print("got graph!")

                        graphViewModel.graph = graph

                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            CanvasView()
        }
        .sheet(isPresented: $showingPermissions) {
            StartupView()
                .presentationBackground {
                    Rectangle()
                        .fill(.regularMaterial)
                }
        }
        .environmentObject(model)
        .environmentObject(graphViewModel)
    }
}

#Preview {
    ContentView()
}

//            VStack {
//                Text("Debug!")
//
//                ScrollView {
//                    GraphDebugView(
//                        graph: DummyData.generateGraph(
//                            phoneNumber: model.ownPhoneNumber,
//                            targetDepth: 3
//                        )
//                    )
//                }
//                .frame(height: 250)
//
//                if let selectedPhoneNumber = graphViewModel.selectedPhoneNumber {
//                    Text("Selected: \(selectedPhoneNumber)")
//                }
//
//                if let tappedPhoneNumber = graphViewModel.tappedPhoneNumber {
//                    Text("Tapped: \(tappedPhoneNumber)")
//                }
//            }
//            .foregroundColor(.white)
//            .font(.caption2)
//            .padding()
//            .background {
//                RoundedRectangle(cornerRadius: 36)
//                    .fill(.regularMaterial)
//                    .environment(\.colorScheme, .dark)
//            }
