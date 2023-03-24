//
//  TransparentSheet.swift
//  Help App
//
//  Created by Artem Rakhmanov on 24/03/2023.
//

import SwiftUI
import UIKit

extension View {
    func transparentSheet<Content: View>(_ style: AnyShapeStyle = .init(.ultraThinMaterial),
                                         show: Binding<Bool>,
                                         onDismiss: @escaping ()->(),
                                         @ViewBuilder content: @escaping ()->Content)
    -> some View {
        self.sheet(isPresented: show, onDismiss: onDismiss) {
            content()
                .background(RemoveBackgroundColor())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Rectangle()
                        .fill(style)
                        .ignoresSafeArea(.container, edges: .all)
                }
        }
    }
}

struct RemoveBackgroundColor: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
    
}


////https://danielsaidi.com/blog/2022/06/21/undimmed-presentation-detents-in-swiftui
//extension UISheetPresentationController.Detent.Identifier {
//
//    static func fraction(_ value: CGFloat) -> Self {
//        .init("Fraction:\(String(format: "%.1f", value))")
//    }
//
//    static func height(_ value: CGFloat) -> Self {
//        .init("Height:\(value)")
//    }
//}
//
//enum UndimmedPresentationDetent {
//
//    case large
//    case medium
//
//    case fraction(_ value: CGFloat)
//    case height(_ value: CGFloat)
//
//    var swiftUIDetent: PresentationDetent {
//        get {
//            switch self {
//            case .large: return .large
//            case .medium: return .medium
//            case .fraction(let value): return .fraction(value)
//            case .height(let value): return .height(value)
//            }
//        }
////        set {
////            switch newValue {
////                case .medium: self = .medium
////                case .large: self = .large
////                case .fraction(let value): self = .fraction(value)
////                case .height(let height): self = .fraction(height)
////            default: self = .medium
////            }
////        }
//    }
//
//    var uiKitIdentifier: UISheetPresentationController.Detent.Identifier {
//        switch self {
//        case .large: return .large
//        case .medium: return .medium
//        case .fraction(let value): return .fraction(value)
//        case .height(let value): return .height(value)
//        }
//    }
//}
//
//extension Collection where Element == UndimmedPresentationDetent {
//
//    var swiftUISet: Set<PresentationDetent> {
//        Set(map { $0.swiftUIDetent })
//    }
//}
//
//public class UndimmedDetentController: UIViewController {
//
//    var largestUndimmed: UndimmedPresentationDetent?
//
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        avoidDimmingParent()
//        avoidDisablingControls()
//    }
//
//    func avoidDimmingParent() {
//        let id = largestUndimmed?.uiKitIdentifier
//        sheetPresentationController?.largestUndimmedDetentIdentifier = id
//    }
//
//    func avoidDisablingControls() {
//        presentingViewController?.view.tintAdjustmentMode = .normal
//    }
//}
//
//public struct UndimmedDetentView: UIViewControllerRepresentable {
//
//    var largestUndimmed: UndimmedPresentationDetent?
//
//    public func makeUIViewController(context: Context) -> UIViewController {
//        let result = UndimmedDetentController()
//        result.largestUndimmed = largestUndimmed
//        return result
//    }
//
//    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//    }
//}
//
//extension View {
//
//    func presentationDetents(
//        undimmed detents: [UndimmedPresentationDetent],
//        largestUndimmed: UndimmedPresentationDetent? = nil
//    ) -> some View {
//        self.background(UndimmedDetentView(largestUndimmed: largestUndimmed ?? detents.last))
//            .presentationDetents(detents.swiftUISet)
//    }
//
//    func presentationDetents(
//        undimmed detents: [UndimmedPresentationDetent],
//        largestUndimmed: UndimmedPresentationDetent? = nil,
//        selection: Binding<PresentationDetent>
//    ) -> some View {
//        self.background(UndimmedDetentView(largestUndimmed: largestUndimmed ?? detents.last))
//            .presentationDetents(
//                Set(detents.swiftUISet),
//                selection: selection
//            )
//    }
//}
