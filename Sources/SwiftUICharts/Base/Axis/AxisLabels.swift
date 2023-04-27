import SwiftUI

private class ChartWidthWrapper {
    var width: CGFloat = 0.0
}

public struct AxisLabels<Content: View>: View {
    struct YAxisViewKey: ViewPreferenceKey { }
    struct ChartViewKey: ViewPreferenceKey { }

    var axisLabelsData = AxisLabelsData()
    var axisLabelsStyle = AxisLabelsStyle()

    private var chartWidthWrapper = ChartWidthWrapper()

    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var yAxis: some View {
        VStack(spacing: 0.0) {
            ForEach(Array(axisLabelsData.axisYLabels.enumerated().reversed()), id: \.element) { index, axisYData in
                Text(axisYData)
                    .font(axisLabelsStyle.axisFont)
                    .foregroundColor(axisLabelsStyle.axisFontColor)
                if index != 0 {
                    Spacer()
                }
            }
        }
        .padding([.leading, .trailing], 4.0)
        .background(ViewGeometry<YAxisViewKey>())
    }

    func xAxis() -> some View {
            HStack(spacing: 0.0) {
                ForEach(Array(axisLabelsData.axisXLabels.enumerated()), id: \.element) { index, axisXData in
                    if index != 0 {
                        Spacer()
                    }
                    Text(axisXData)
                        .multilineTextAlignment(.center)
                        .font(axisLabelsStyle.axisFont)
                        .foregroundColor(axisLabelsStyle.axisFontColor)
//                        .frame(width: chartWidthWrapper.width / CGFloat(axisLabelsData.axisXLabels.count * 3))
                }
            }
            .padding(.horizontal, chartWidthWrapper.width / CGFloat(axisLabelsData.axisXLabels.count * 6))
            .frame(height: 24.0)
    }

    func chart(_ width: CGFloat) -> some View {
        self.chartWidthWrapper.width = width
        return self.content()
            .background(ViewGeometry<ChartViewKey>())
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 0.0) {
            if axisLabelsStyle.axisLabelsYPosition == .leading {
                yAxis
                    .padding(.bottom, 28)
                    .padding(.trailing, 4)
            }
            VStack(spacing: 4.0) {
                GeometryReader { proxy in
                    chart(proxy.size.width)
                        .padding(.top, 8)
                }
                xAxis()
            }
            if axisLabelsStyle.axisLabelsYPosition == .trailing {
                yAxis
            }
        }
    }

    private func getYHeight(index: Int, chartHeight: CGFloat, count: Int) -> CGFloat {
        if index == 0 || index == count - 1 {
            return chartHeight / (CGFloat(count - 1) * 2) + 10
        }

        return chartHeight / CGFloat(count - 1)
    }

    private func getYAlignment(index: Int, count: Int) -> Alignment {
        if index == 0 {
            return .top
        }

        if index == count - 1 {
            return .bottom
        }

        return .center
    }
}
