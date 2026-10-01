import PhotosUI
import SwiftUI
import StoreKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var viewModel = ContentViewModel()
    @State private var showingFilters = false

    @Environment(\.requestReview) private var requestReview

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                    if let processedImage = viewModel.processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                Spacer()

                VStack {
                    HStack(spacing: 30) {
                        Button {
                            viewModel.rotateCounterClockwise()
                        } label: {
                            Image(systemName: "rotate.left")
                        }
                        Button {
                            viewModel.rotateClockwise()
                        } label: {
                            Image(systemName: "rotate.right")
                        }
                    }
                    .font(.title)
                    .padding(.bottom)


                    HStack {
                        Text("Intensity")
                        Slider(value: $viewModel.filterIntensity)
                    }
                    HStack {
                        Button("Change filter") {
                            showingFilters = true
                        }
                        .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                            ForEach(viewModel.availableFilters, id: \.id) { option in
                                Button(option.name) {
                                    viewModel.selectFilter(option)
                                    if viewModel.shouldRequestReview {
                                        requestReview()
                                    }
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                        Spacer()
                        if let processedImage = viewModel.processedImage {
                            ShareLink(item: processedImage, preview: SharePreview("PhotoLab image", image: processedImage))
                        }
                    }
                }
                .disabled(viewModel.processedImage == nil)

            }
            .padding([.horizontal, .bottom])
            .navigationTitle("PhotoLab")

        }
    }
}
#Preview {
    ContentView()
}
