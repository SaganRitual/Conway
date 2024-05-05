// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var scene: CScene
    @ObservedObject var selectioner: Selectioner

    @State private var hoverLocation: CGPoint = .zero
    @State private var isHovering = false
    @State private var sceneSize: CGSize = .zero

    // With eternal gratitude to
    // https://forums.developer.apple.com/forums/profile/billh04
    // Adding a nearly invisible view to make DragGesture() respond
    // https://forums.developer.apple.com/forums/thread/724082
    let glassPaneColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.01)

    init() {
        let scene = CScene()
        let selectioner = Selectioner(scene: scene)

        self.scene = scene
        self.selectioner = selectioner
    }

    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                SpriteView(scene: scene)
                Color(cgColor: glassPaneColor)
                    .background() {
                        GeometryReader { geometry in
                            Path { _ in
                                DispatchQueue.main.async {
                                    if self.sceneSize != geometry.size {
                                        self.sceneSize = geometry.size
                                    }
                                }
                            }
                        }
                    }
            }

            .gesture(
                DragGesture()
                    .onChanged { value in
                        hoverLocation = value.location
                        isHovering = true

                        selectioner.dragging(startVertex: value.startLocation, endVertex: value.location)
                    }
                    .onEnded   { value in
                        hoverLocation = value.location
                        selectioner.notDragging()
                    }
            )

            .gesture(
                TapGesture()
                    .onEnded {
                        scene.tap(at: hoverLocation)
                    }
            )

            // With eternal gratitude to Natalia Panferova
            // Using .onContinuousHover to track mouse position
            // https://nilcoalescing.com/blog/TrackingHoverLocationInSwiftUI/
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    hoverLocation = location
                    isHovering = true
                case .ended:
                    hoverLocation = .zero
                    isHovering = false
                }
            }

            // With eternal gratitude to
            // https://www.hackingwithswift.com/users/Magdi
            // Mouse wheel handling that plays nice with gesture and continuous hover modifiers
            // https://www.hackingwithswift.com/forums/swiftui/how-to-use-mouse-wheel-movement-event-to-call-a-function/21006/26666
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { event in
                    scene.scrollWheel(with: event)
                    return event
                }
            }

            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Grid Library")
                    Spacer()
                }
                .padding(.bottom)

                HStack {
                    Spacer()
                    Text("Size").underline()
                    Spacer()
                }
                .padding(.bottom)

                HStack {
                    Text("Scene/View")
                    Spacer()
                    Text("\(sceneSize)")
                }

                HStack {
                    Text("Grid")
                    Spacer()

                    if let grid = scene.grid {
                        Text("\(grid.size)")
                    } else {
                        Text("N/A")
                    }
                }
                .padding(.bottom)

                Text("Zoom \(String(format: "%.2f", scene.cameraScale).padLeft(targetLength: 6))")
                    .padding(.bottom)

                HStack {
                    Spacer()
                    Text("Mouse").underline()
                    Spacer()
                }
                .padding(.bottom)

                if isHovering {
                    HStack {
                        Text("View")
                        Spacer()
                        Text("\(getMousePositionString(positionInView: hoverLocation))")
                    }

                    HStack {
                        Text("Scene")
                        Spacer()
                        Text("\(getMousePositionString(forScene: scene, positionInView: hoverLocation))")
                    }

                    HStack {
                        Text("Grid")
                        Spacer()
                        Text("\(getMousePositionStringForGrid(scene: scene, positionInView: hoverLocation))")
                    }
                    .padding(.bottom, 10)
                } else {
                    Text("N/A")
                        .padding(.bottom, 10 + 16 + 16)
                }

                Toggle(isOn: $scene.showGridLines) {
                    Text("Show grid lines")
                }
                .toggleStyle(.checkbox)
                .onChange(of: scene.showGridLines) {
                    scene.requireRedraw()
                }
                .padding(.bottom)

                Button("Clear All") {
                    scene.clearAll()
                }

                Button("Sow Random") {
                    scene.sowRandom()
                }

                Spacer()

                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .monospaced()
            .frame(width: 250)
        }
    }
}

#Preview {
    ContentView()
}
