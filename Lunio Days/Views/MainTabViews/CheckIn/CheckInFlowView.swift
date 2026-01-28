//
//  CheckInFlowView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

import SwiftUI

struct CheckInFlowView: View {

    enum Step {
        case step1
        case step2
        case step3
        case step4
    }

    @Environment(\.dismiss) private var dismiss
    
    @State private var step: Step = .step1

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            switch step {
            case .step1:
                CheckIn1View(
                    onBack: {
                        dismiss()
                    },
                    onNext: {
                        step = .step2
                    }
                )

            case .step2:
                CheckIn2View(
                    onBack: {
                        step = .step1
                    },
                    onNext: {
                        step = .step3
                    }
                )
                
            case .step3:
                CheckIn3View(
                    onBack: {
                        step = .step2
                    }, onFinish: {
                        step = .step4
                    })
                
            case .step4:
                CheckInSuccesView(
                    onDone: {
                        dismiss()
                    })
            }
        }
    }
}
