import SwiftUI

struct ProfilePlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.system(size: 48, weight: .medium))
                .foregroundStyle(.secondary)
            Text("我的")
                .font(.title2.weight(.semibold))
            Text("这里保留给个人中心与播放偏好配置。")
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
    ProfilePlaceholderView()
}
