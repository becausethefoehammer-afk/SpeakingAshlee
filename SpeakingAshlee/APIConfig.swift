import Foundation

enum APIConfig {
    // Set PROXY_BASE_URL in your Xcode scheme's Run environment variables for local dev.
    // For release builds, set it in project.yml under settings.Release.SWIFT_ACTIVE_COMPILATION_CONDITIONS
    // or just hardcode your Render URL here before archiving.
    static let proxyBaseURL: String = {
        if let override = ProcessInfo.processInfo.environment["PROXY_BASE_URL"] {
            return override
        }
        #if DEBUG
        return "http://localhost:3000"
        #else
        // Replace with your deployed Render URL after deploying the proxy
        return "https://speaking-ashlee-proxy.onrender.com"
        #endif
    }()
}
