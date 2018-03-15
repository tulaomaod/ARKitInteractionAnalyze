/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains `ThresholdPanGesture` - a custom `UIPanGestureRecognizer` to track a translation threshold for panning.
 一个自定义的`UIPanGestureRecognizer`来跟踪平移的平移阈值。
*/

import UIKit.UIGestureRecognizerSubclass

/**
 A custom `UIPanGestureRecognizer` to track when a translation threshold has been exceeded
 and panning should begin.
 自定义的“UIPanGestureRecognizer”用于跟踪何时超过翻译阈值并开始平移。
 - Tag: ThresholdPanGesture
 */
class ThresholdPanGesture: UIPanGestureRecognizer {
    
    /// Indicates whether the currently active gesture has exceeeded the threshold.
    /// 指示当前活动的手势是否超出阈值。
    private(set) var isThresholdExceeded = false
    
    /// Observe when the gesture's `state` changes to reset the threshold.
    /// 观察手势的“状态”变化以重置阈值。
    override var state: UIGestureRecognizerState {
        didSet {
            switch state {
            case .began, .changed:
                break
                
            default:
                // Reset threshold check.
                isThresholdExceeded = false
            }
        }
    }
    
    /// Returns the threshold value that should be used dependent on the number of touches.
    /// 根据触摸手指个数返回应使用的阈值。
    private static func threshold(forTouchCount count: Int) -> CGFloat {
        switch count {
        case 1: return 30
            
        // Use a higher threshold for gestures using more than 1 finger. This gives other gestures priority.
        // 多于一个手指的手势使用较高的阈值。 这使其他手势优先。
        default: return 60
        }
    }
    
    /// - Tag: touchesMoved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        let translationMagnitude = translation(in: view).length
        
        // Adjust the threshold based on the number of touches being used.
        // 根据触摸手指个数调整阈值
        let threshold = ThresholdPanGesture.threshold(forTouchCount: touches.count)
        
        if !isThresholdExceeded && translationMagnitude > threshold {
            isThresholdExceeded = true
            
            // Set the overall translation to zero as the gesture should now begin.
            // translation 在指定视图的坐标系中进行翻译
            // 手势现在开始时，将整体翻译设置为零
            setTranslation(.zero, in: view)
        }
    }
}
