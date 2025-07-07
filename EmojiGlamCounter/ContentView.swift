//
//  ContentView.swift
//  EmojiGlamCounter
//
//  Created by Brooke Gates on 7/2/25.

import SwiftUI

// MARK: - Model
struct EmojiCounter: Identifiable {
    let id = UUID()
    var emoji: String
    var count: Int
}

// MARK: - ViewModel
class EmojiViewModel: ObservableObject {
    @Published var emojis: [EmojiCounter] = [
        EmojiCounter(emoji: "💅", count: 0),
        EmojiCounter(emoji: "🌸", count: 0),
        EmojiCounter(emoji: "🧠", count: 0),
        EmojiCounter(emoji: "🛍️", count: 0),
        EmojiCounter(emoji: "👑", count: 0)
    ]
    
    func increment(at index: Int) {
        emojis[index].count += 1
    }
    
    func decrement(at index: Int) {
        if emojis[index].count > 0 {
            emojis[index].count -= 1
        }
    }
}

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = EmojiViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background Gradient
                    LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.2), Color.white]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            // Glam Header
                            Text("✨ Emoji Glam Counter ✨")
                                .font(.custom("AvenirNext-Bold", size: 28))
                                .foregroundColor(.pink)
                                .padding(.top, 20)
                            
                            ForEach(Array(viewModel.emojis.enumerated()), id: \.1.id) { index, emojiItem in
                                EmojiRow(emojiItem: emojiItem, index: index, viewModel: viewModel)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                            }
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text("Keep tappin’ for glam ✨")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - Individual Row
struct EmojiRow: View {
    var emojiItem: EmojiCounter
    var index: Int
    @ObservedObject var viewModel: EmojiViewModel
    @State private var animate = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.pink.opacity(0.2), radius: 4, x: 0, y: 2)
            
            HStack {
                Text(emojiItem.emoji)
                    .font(.largeTitle)
                    .frame(width: 50)

                Spacer()
                
                Button(action: {
                    viewModel.decrement(at: index)
                    animateBounce()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.pink)
                        .font(.system(size: 28))
                }

                Text("\(viewModel.emojis[index].count)")
                    .font(.title2)
                    .padding(.horizontal)
                    .scaleEffect(animate ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: animate)

                Button(action: {
                    viewModel.increment(at: index)
                    animateBounce()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.purple)
                        .font(.system(size: 28))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .padding(.vertical, 5)
    }

    private func animateBounce() {
        animate = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animate = false
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
