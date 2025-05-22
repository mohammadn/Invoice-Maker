

struct ButtonWithPopover: View {
    @State var show: Bool = false

    let text: String
    let action: () -> Void

    var body: some View {
        Button {
            show.toggle()
        } label: {
            Image(systemName: "exclamationmark.circle")
        }
        .popover(isPresented: $show, arrowEdge: .bottom) {
            Group {
                Text(text)
                    .fixedSize(horizontal: false, vertical: true)

                Button("بروزرسانی") {
                    print(1)

                    action()
                }
            }
            .padding(20)
            .presentationCompactAdaptation(.popover)
        }
    }
}