//
//  CustomWheelPicker.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct CustomWheelPicker: View {

    let items: [String]
    @Binding var selectedIndex: Int

    var rowHeight: CGFloat = 44
    var visibleRows: Int = 5

    var font: Font = .phetsarath(.regular, size: 22)
    var textColor: Color = .brownText

    var selectedFont: Font? = nil
    var selectedColor: Color? = nil
    var dimmedOpacity: Double = 0.35

    var scrollTrigger: Int = 0

    @State private var isDragging = false
    @State private var internalIndex: Int = 0

    var body: some View {
        let height = rowHeight * CGFloat(visibleRows)
        let topBottomPadding = (height - rowHeight) / 2

        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    Color.clear.frame(height: topBottomPadding)

                    ForEach(items.indices, id: \.self) { i in
                        Text(items[i])
                            .font(i == selectedIndex ? (selectedFont ?? font) : font)
                            .foregroundColor(i == selectedIndex ? (selectedColor ?? textColor) : textColor)
                            .frame(height: rowHeight)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .opacity(i == selectedIndex ? 1 : dimmedOpacity)
                            .background(
                                GeometryReader { geo in
                                    Color.clear.preference(
                                        key: RowMidYPreferenceKey.self,
                                        value: [i: geo.frame(in: .named("WheelSpace")).midY]
                                    )
                                }
                            )
                            .id(i)
                    }

                    Color.clear.frame(height: topBottomPadding)
                }
            }
            .coordinateSpace(name: "WheelSpace")
            .frame(height: height)

            .onPreferenceChange(RowMidYPreferenceKey.self) { mids in
                guard !items.isEmpty else { return }

                let centerY = height / 2
                guard let nearest = mids.min(by: { abs($0.value - centerY) < abs($1.value - centerY) })?.key else { return }

                internalIndex = nearest

                guard isDragging else { return }

                if nearest != selectedIndex {
                    selectedIndex = nearest
                }
            }

            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in isDragging = true }
                    .onEnded { _ in
                        isDragging = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                            withAnimation(.easeOut(duration: 0.18)) {
                                proxy.scrollTo(internalIndex, anchor: .center)
                            }
                        }
                    }
            )

            .onAppear {
                guard !items.isEmpty else { return }
                selectedIndex = clamp(selectedIndex, 0, items.count - 1)
                internalIndex = selectedIndex
                proxy.scrollTo(selectedIndex, anchor: .center)
            }

            .onChange(of: scrollTrigger) { _ in
                guard !items.isEmpty else { return }
                let clamped = clamp(selectedIndex, 0, items.count - 1)
                internalIndex = clamped
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.18)) {
                        proxy.scrollTo(clamped, anchor: .center)
                    }
                }
            }

            .onChange(of: selectedIndex) { newValue in
                guard !items.isEmpty else { return }
                guard !isDragging else { return }

                let clamped = clamp(newValue, 0, items.count - 1)
                if clamped != selectedIndex {
                    selectedIndex = clamped
                    return
                }

                internalIndex = clamped
                withAnimation(.easeOut(duration: 0.18)) {
                    proxy.scrollTo(clamped, anchor: .center)
                }
            }
        }
        .frame(height: rowHeight * CGFloat(visibleRows))
    }

    private func clamp(_ value: Int, _ min: Int, _ max: Int) -> Int {
        Swift.max(min, Swift.min(max, value))
    }
}

private struct RowMidYPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
