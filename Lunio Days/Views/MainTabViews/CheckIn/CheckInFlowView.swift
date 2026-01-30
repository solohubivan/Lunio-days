//
//  CheckInFlowView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

import SwiftUI
import CoreData

struct CheckInFlowView: View {

    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    enum Step: Int {
        case mood = 0
        case pain = 1
        case energy = 2
        case success = 3
    }

    @State private var step: Step = .mood

    @State private var mood: Mood? = nil
    @State private var pain: PainLevel? = nil
    @State private var energy: EnergyLevel? = nil

    var body: some View {
        ZStack {
            switch step {
            case .mood:
                CheckIn1View(
                    selectedMood: $mood,
                    onBack: { dismiss() },
                    onNext: { step = .pain }
                )

            case .pain:
                CheckIn2View(
                    selectedPain: $pain,
                    onBack: { step = .mood },
                    onNext: { step = .energy }
                )

            case .energy:
                CheckIn3View(
                    selectedEnergy: $energy,
                    onBack: { step = .pain },
                    onFinish: saveAndShowSuccess
                )

            case .success:
                CheckInSuccesView(
                    onDone: { dismiss() }
                )
            }
        }
        .animation(.easeInOut(duration: 0.25), value: step)
    }

    private func saveAndShowSuccess() {
        guard let mood, let pain, let energy else { return }

        do {
            let manager = DayRecordsManager(context: context)
            try manager.saveCheckInForToday(mood: mood, pain: pain, energy: energy)

            step = .success
        } catch {
            
        }
    }
}
