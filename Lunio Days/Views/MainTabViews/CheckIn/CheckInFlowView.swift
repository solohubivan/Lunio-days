//
//  CheckInFlowView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

//import SwiftUI
//
//struct CheckInFlowView: View {
//
//    enum Step {
//        case step1
//        case step2
//        case step3
//        case step4
//    }
//
//    @Environment(\.dismiss) private var dismiss
//    
//    @State private var step: Step = .step1
//
//    var body: some View {
//        ZStack {
//            Color.white.ignoresSafeArea()
//
//            switch step {
//            case .step1:
//                CheckIn1View(
//                    onBack: {
//                        dismiss()
//                    },
//                    onNext: {
//                        step = .step2
//                    }
//                )
//
//            case .step2:
//                CheckIn2View(
//                    onBack: {
//                        step = .step1
//                    },
//                    onNext: {
//                        step = .step3
//                    }
//                )
//                
//            case .step3:
//                CheckIn3View(
//                    onBack: {
//                        step = .step2
//                    }, onFinish: {
//                        step = .step4
//                    })
//                
//            case .step4:
//                CheckInSuccesView(
//                    onDone: {
//                        dismiss()
//                    })
//            }
//        }
//    }
//}



//import SwiftUI
//import CoreData
//
//struct CheckInFlowView: View {
//
//    @Environment(\.managedObjectContext) private var context
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var step: Int = 0
//
//    @State private var mood: Mood? = nil
//    @State private var pain: PainLevel? = nil
//    @State private var energy: EnergyLevel? = nil
//
//    var body: some View {
//        ZStack {
//            switch step {
//            case 0:
//                CheckIn1View(
//                    selectedMood: $mood,
//                    onBack: { dismiss() },
//                    onNext: { step = 1 }
//                )
//
//            case 1:
//                CheckIn2View(
//                    selectedPain: $pain,
//                    onBack: { step = 0 },
//                    onNext: { step = 2 }
//                )
//
//            case 2:
//                CheckIn3View(
//                    selectedEnergy: $energy,
//                    onBack: { step = 1 },
//                    onFinish: saveAndClose
//                )
//
//            default:
//                EmptyView()
//            }
//        }
//        .animation(.easeInOut(duration: 0.25), value: step)
//    }
//
//    private func saveAndClose() {
//        guard let mood, let pain, let energy else { return }
//
//        do {
//            let manager = DayRecordsManager(context: context)
//            try manager.saveCheckInForToday(mood: mood, pain: pain, energy: energy)
////            dismiss()
//        } catch {
//            print("❌ check-in save error:", error)
//        }
//    }
//}





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
