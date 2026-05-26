import SwiftUI

struct DiscoverPlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles.rectangle.stack")
                .font(.system(size: 48, weight: .medium))
                .foregroundStyle(.secondary)
            Text("发现")
                .font(.title2.weight(.semibold))
            Text("后续可以在这里扩展推荐节目与专题内容。")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    DiscoverPlaceholderView()
}
