import SwiftUI
struct TapArea: View {
    @State var x_position=0.5
    @State var y_position=0.5
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
            .fill(.red)
            .frame(width: 350, height: 350)
            .onTapGesture { location in
                print("Tapped at \(location)")
                x_position=location.x
                y_position=location.y
            }
    }
}
