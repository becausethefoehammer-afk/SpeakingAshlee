import SwiftUI

struct ContentView: View {
    @StateObject private var translator = TranslatorViewModel()
    @State private var inputText = ""
    @FocusState private var inputFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        inputCard
                        translateButton
                        if !translator.outputText.isEmpty || translator.isLoading {
                            outputCard
                        }
                        examplesSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }

    private var headerView: some View {
        VStack(spacing: 4) {
            Text("Speaking Ashlee")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundColor(.white)
            Text("old head → gen z")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.7))
        }
        .padding(.top, 16)
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("what you're actually saying", systemImage: "bubble.left")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.65))

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.13, green: 0.13, blue: 0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(inputFocused ? Color(red: 0.5, green: 0.4, blue: 1.0) : Color.clear, lineWidth: 1.5)
                    )

                if inputText.isEmpty {
                    Text("e.g. I'm very tired and don't want to go out tonight")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.45))
                        .padding(16)
                }

                TextEditor(text: $inputText)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 100, maxHeight: 200)
                    .padding(12)
                    .focused($inputFocused)
            }

            HStack {
                Spacer()
                Button(action: { inputText = "" }) {
                    Label("clear", systemImage: "xmark.circle.fill")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5))
                }
                .opacity(inputText.isEmpty ? 0 : 1)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.17))
        )
    }

    private var translateButton: some View {
        Button {
            inputFocused = false
            Task { await translator.translate(inputText) }
        } label: {
            HStack(spacing: 10) {
                if translator.isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.9)
                } else {
                    Image(systemName: "bolt.fill")
                }
                Text(translator.isLoading ? "translating fr fr..." : "translate it no cap")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.5, green: 0.3, blue: 1.0), Color(red: 0.3, green: 0.2, blue: 0.85)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(18)
            .shadow(color: Color(red: 0.4, green: 0.2, blue: 0.9).opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || translator.isLoading)
        .opacity(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
    }

    private var outputCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("gen z translation", systemImage: "bubble.right")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.5, green: 0.8, blue: 0.5))

            if translator.isLoading {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        ProgressView()
                            .tint(Color(red: 0.5, green: 0.8, blue: 0.5))
                        Text("cooking up something slay...")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5))
                    }
                    Spacer()
                }
                .padding(.vertical, 20)
            } else {
                Text(translator.outputText)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)

                if let error = translator.errorMessage {
                    Text(error)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.4))
                }

                HStack {
                    Spacer()
                    Button {
                        UIPasteboard.general.string = translator.outputText
                        translator.showCopied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            translator.showCopied = false
                        }
                    } label: {
                        Label(translator.showCopied ? "copied!" : "copy", systemImage: translator.showCopied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(translator.showCopied ? Color(red: 0.5, green: 0.9, blue: 0.5) : Color(red: 0.4, green: 0.4, blue: 0.55))
                            .animation(.easeInOut(duration: 0.2), value: translator.showCopied)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.1, green: 0.15, blue: 0.13))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 0.2, green: 0.4, blue: 0.25), lineWidth: 1)
                )
        )
        .transition(.asymmetric(insertion: .scale(scale: 0.95).combined(with: .opacity), removal: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: translator.outputText)
    }

    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("try these")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.55))
                .padding(.leading, 4)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(SamplePhrases.examples, id: \.self) { phrase in
                    Button {
                        inputText = phrase
                        inputFocused = false
                        Task { await translator.translate(phrase) }
                    } label: {
                        Text(phrase)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.13, green: 0.13, blue: 0.2))
                            )
                    }
                }
            }
        }
    }
}
