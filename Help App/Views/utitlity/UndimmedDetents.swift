//
//  UndimmedPresentationDetentsViewModifier.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2022-06-21.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import UIKit

@available(iOS 16.0, *)
public extension UISheetPresentationController.Detent.Identifier {

    /// A fraction-specific detent identifier.
    static func fraction(_ value: CGFloat) -> Self {
        .init("Fraction:\(String(format: "%.1f", value))")
    }

    /// A height-specific detent identifier.
    static func height(_ value: CGFloat) -> Self {
        .init("Height:\(value)")
    }
}
#endif

#if os(iOS)
import SwiftUI

/**
 This is used to bridge the SwiftUI `PresentationDetent`with
 the UIKit `UISheetPresentationController.Detent.Identifier`.
 */
@available(iOS 16.0, *)
public enum UndimmedPresentationDetent {

    /// The system detent for a sheet at full height.
    case large

    /// The system detent for a sheet that's approximately half the available screen height.
    case medium

    /// A custom detent with the specified fractional height.
    case fraction(_ value: CGFloat)

    ///  A custom detent with the specified height.
    case height(_ value: CGFloat)

    var swiftUIDetent: PresentationDetent {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case .fraction(let value): return .fraction(value)
        case .height(let value): return .height(value)
        }
    }

    var uiKitIdentifier: UISheetPresentationController.Detent.Identifier {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case .fraction(let value): return .fraction(value)
        case .height(let value): return .height(value)
        }
    }
}

@available(iOS 16.0, *)
extension Collection where Element == UndimmedPresentationDetent {

    var swiftUISet: Set<PresentationDetent> {
        Set(map { $0.swiftUIDetent })
    }
}
#endif


#if os(iOS) && compiler(>=5.7)
import SwiftUI

/**
 This view modifier applies swipe gestures to any views that
 can trigger actions when they are swiped left/right/up/down.
 The modifier is used by the `View+onSwipeGesture` extension.
 */
@available(iOS 16.0, *)
public struct UndimmedPresentationDetentsViewModifier: ViewModifier {

    init(
        undimmedDetents: [UndimmedPresentationDetent],
        largestUndimmed: UndimmedPresentationDetent? = nil
    ) {
        self.undimmedDetents = undimmedDetents
        self.largestUndimmed = largestUndimmed
        self.selection = nil
    }

    init(
        undimmedDetents: [UndimmedPresentationDetent],
        largestUndimmed: UndimmedPresentationDetent? = nil,
        selection: Binding<PresentationDetent>
    ) {
        self.undimmedDetents = undimmedDetents
        self.largestUndimmed = largestUndimmed
        self.selection = selection
    }

    private let undimmedDetents: [UndimmedPresentationDetent]
    private let largestUndimmed: UndimmedPresentationDetent?
    private let selection: Binding<PresentationDetent>?

    public func body(content: Content) -> some View {
        if let selection = selection {
            content
                .background(background)
                .presentationDetents(
                    Set(undimmedDetents.swiftUISet),
                    selection: selection)
        } else {
            content
                .background(background)
                .presentationDetents(undimmedDetents.swiftUISet)
        }
    }
}

@available(iOS 16.0, *)
private extension UndimmedPresentationDetentsViewModifier {

    var background: some View {
        UndimmedDetentView(
            largestUndimmed: largestUndimmed ?? undimmedDetents.last
        )
    }
}

@available(iOS 16.0, *)
public extension View {

    /**
     Define a set of presentation detents that don't dim any
     underlying views when this view is presented as a sheet.
     - Parameters:
       - detents: The undimmed detents to enable for the view.
       - largestUndimmed: The largest undimmed detent, by default the last detents in the provided `detents` collection.
     */
    func presentationDetents(
        undimmed detents: [UndimmedPresentationDetent],
        largestUndimmed: UndimmedPresentationDetent? = nil
    ) -> some View {
        self.modifier(
            UndimmedPresentationDetentsViewModifier(
                undimmedDetents: detents,
                largestUndimmed: largestUndimmed
            )
        )
    }

    /**
     Define a set of presentation detents that don't dim any
     underlying views when this view is presented as a sheet.
     - Parameters:
       - detents: The undimmed detents to enable for the view.
       - largestUndimmed: The largest undimmed detent, by default the last detents in the provided `detents` collection.
       - selection: An external seleciton binding.
     */
    func presentationDetents(
        undimmed detents: [UndimmedPresentationDetent],
        largestUndimmed: UndimmedPresentationDetent? = nil,
        selection: Binding<PresentationDetent>
    ) -> some View {
        self.modifier(
            UndimmedPresentationDetentsViewModifier(
                undimmedDetents: detents,
                largestUndimmed: largestUndimmed,
                selection: selection
            )
        )
    }
}

@available(iOS 16.0, *)
private struct UndimmedDetentView: UIViewControllerRepresentable {

    var largestUndimmed: UndimmedPresentationDetent?

    func makeUIViewController(context: Context) -> UIViewController {
        let result = UndimmedDetentController()
        result.largestUndimmedDetent = largestUndimmed
        return result
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

@available(iOS 16.0, *)
private class UndimmedDetentController: UIViewController {

    var largestUndimmedDetent: UndimmedPresentationDetent?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avoidDimmingParent()
        avoidDisablingControls()
    }

    func avoidDimmingParent() {
        let id = largestUndimmedDetent?.uiKitIdentifier
        sheetPresentationController?.largestUndimmedDetentIdentifier = id
    }

    func avoidDisablingControls() {
        presentingViewController?.view.tintAdjustmentMode = .normal
    }
}

@available(iOS 16.0, *)
struct View_PresentationDetents_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var isPresented = false

        var body: some View {
            Color.green.ignoresSafeArea()
                .overlay(button)
                .sheet(isPresented: $isPresented) {
                    Color.red.ignoresSafeArea()
                        .presentationDetents(
                            undimmed: [
                                .fraction(0.3),
                                .fraction(0.5),
                                .height(500)
                            ],
                            largestUndimmed: .fraction(0.5)
                        )
                }
        }

        var button: some View {
            Button("Toggle sheet") {
                isPresented.toggle()
            }.buttonStyle(.borderedProminent)
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
