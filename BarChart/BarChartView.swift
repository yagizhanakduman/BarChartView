//
//  BarChartView.swift
//  BarChart
//
//  Created by YAGIZHAN AKDUMAN
//

import UIKit

// MARK: Bar Chart View
///
/// A custom horizontal bar chart view that visualizes usage with animated colored segments.
///
/// This view animates its segments sequentially when first laid out on screen. Each segment corresponds
/// to a category of usage and is represented with a specific color and size proportional to its value.
///
/// - Example:
/// ```swift
/// let data = [
///     BarChartView.UsageData(color: .red, value: 2),
///     BarChartView.UsageData(color: .blue, value: 3)
/// ]
/// let barChart = BarChartView(usageData: data, totalValue: 8)
/// ```
///
/// - Important:
/// `totalValue` should be the sum or maximum value representing 100% of the chart.
///
/// - Note:
/// This view performs a one-time animation using `layoutSubviews()` and will not re-animate on layout changes.
final class BarChartView: UIView {
    
    /// Model representing a single segment of the usage bar.
    struct UsageData {
        /// Color used to represent this segment.
        let color: UIColor
        /// Numeric value used to calculate this segment's width.
        let value: CGFloat
    }
    
    /// Bar chart view's custom background color
    private let backgroundViewColor = UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1.0)
    
    /// The total value used to determine proportional widths.
    private let totalValue: CGFloat
    
    /// Array of usage segments to be displayed in the chart.
    private let usageData: [UsageData]
    
    /// Array of segment views displayed inside the bar.
    private var barViews: [UIView] = []
    
    /// Array of precomputed segment widths based on their values.
    private var barWidths: [CGFloat] = []
    
    /// Flag to prevent re-running the animation multiple times.
    private var hasAnimated = false
    
    /// Previous size to check changes
    private var previousSize: CGSize = .zero
    
    /// Initializes a new bar chart view with the given usage value and total value.
    ///
    /// - Parameters:
    ///   - frame: The frame of the view.
    ///   - usageData: An array of `UsageData` defining the segments.
    ///   - totalValue: The total value used to calculate proportional widths.
    init(frame: CGRect = .zero, usageData: [UsageData], totalValue: CGFloat) {
        self.usageData = usageData
        self.totalValue = totalValue
        super.init(frame: frame)
        setupBar()
    }
    
    /// This view is not intended to be used with Interface Builder.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Triggers the sequential bar animation once when the layout is first calculated.
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != previousSize {
            layer.cornerRadius = layer.frame.height / 2.2
        }
        if !hasAnimated {
            hasAnimated = true
            animateBars()
        }
    }
    
    /// Sets up the base appearance of the bar and prepares individual colored segment views.
    ///
    /// - Note:
    /// All segment views are initialized with zero width and positioned horizontally.
    private func setupBar() {
        backgroundColor = backgroundViewColor
        layer.cornerRadius = layer.frame.height / 2.5
        clipsToBounds = true
        /// Set bar views
        for data in usageData {
            let barSegment = UIView()
            barSegment.backgroundColor = data.color
            barSegment.clipsToBounds = true
            barSegment.frame = CGRect(x: 0, y: 0, width: 0, height: bounds.height)
            addSubview(barSegment)
            barViews.append(barSegment)
        }
    }
    
    /// Starts the animation sequence after calculating layout and bar widths.
    private func animateBars() {
        layoutInitialFrames()
        startSequentialAnimation(index: 0)
    }
    
    /// Precomputes the target width for each segment based on usage and positions them in order.
    private func layoutInitialFrames() {
        guard bounds.width > 0 else {
            debugPrint("BarChartView - layoutInitialFrames() -> Skipping animation due to zero width")
            return
        }
        /// Set bar widths
        barWidths = usageData.map { ($0.value / totalValue) * bounds.width }
        /// Set current X
        var currentX: CGFloat = 0.0
        for (index, bar) in barViews.enumerated() {
            let targetWidth = barWidths[index]
            bar.frame = CGRect(x: currentX, y: 0, width: 0, height: bounds.height)
            currentX += targetWidth
        }
    }
    
    /// Recursively animates each segment in sequence using UIView animations.
    ///
    /// - Parameter index: The index of the current segment to animate.
    private func startSequentialAnimation(index: Int) {
        guard
            index < barViews.count,
            let bar = barViews[safe: index],
            let width = barWidths[safe: index]
        else {
            if barViews.count != index {
                debugPrint("BarChartView - startSequentialAnimation(index: Int) -> Failed to animate bar at index \(index)")
            }
            return
        }
        /// Start X
        let startX = bar.frame.origin.x
        /// Set duration according to bar width (min: 0.4, max: 1.0)
        let ratio = width / bounds.width
        let duration = 0.4 + (0.6 * Double(ratio))
        /// Animate item
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            bar.frame = CGRect(x: startX, y: 0, width: width, height: self.bounds.height)
        }, completion: { _ in
            self.startSequentialAnimation(index: index + 1)
        })
    }
    
}

/// Collection - safe
extension Collection {

    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
