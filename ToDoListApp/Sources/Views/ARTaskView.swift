import SwiftUI
import ARKit
import RealityKit

struct ARTaskView: View {
    let task: ToDoTask
    @StateObject private var viewModel: ARTaskViewModel
    
    init(task: ToDoTask) {
        self.task = task
        self._viewModel = StateObject(wrappedValue: ARTaskViewModel(task: task))
    }
    
    var body: some View {
        ARViewContainer(text: viewModel.displayText)
            .ignoresSafeArea()
            .navigationTitle("AR Task")
    }
}

struct ARViewContainer: UIViewRepresentable {
    let text: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        
        let anchor = AnchorEntity(plane: .horizontal)
        let textEntity = ModelEntity(mesh: .generateText(
            text,
            extrusionDepth: 0.02,
            font: .systemFont(ofSize: 0.1),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        ))
        textEntity.generateCollisionShapes(recursive: true)
        anchor.addChild(textEntity)
        arView.scene.addAnchor(anchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ARTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ARTaskView(task: ToDoTask(title: "Sample Task", description: "Description", dueDate: Date(), isCompleted: false))
    }
}
