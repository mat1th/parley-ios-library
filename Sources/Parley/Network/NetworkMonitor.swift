import Foundation
import Network

protocol NetworkMonitorDelegate: AnyObject {
    func didUpdateConnection(isConnected: Bool)
}

protocol NetworkMonitorProtocol {
    func start()
    func stop()
}

final class NetworkMonitor: NetworkMonitorProtocol {
    private let networkMonitor: NWPathMonitorProtocol
    private let workerQueue = DispatchQueue(label: "nu.parley.NetworkMonitor")

    private weak var delegate: NetworkMonitorDelegate?

    init(
        networkMonitor: NWPathMonitorProtocol = NWPathMonitor(),
        delegate: NetworkMonitorDelegate
    ) {
        self.networkMonitor = NWPathMonitor()
        self.delegate = delegate
    }

    func start() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            delegate?.didUpdateConnection(isConnected: Self.hasConnection(status: path.status))
        }
        networkMonitor.start(queue: workerQueue)
        /// When there is no change, the start monitor will not call the `pathUpdateHandler` on start.
        delegate?.didUpdateConnection(isConnected: Self.hasConnection(status: networkMonitor.currentPath.status))
    }

    func stop() {
        networkMonitor.cancel()
    }

    private static func hasConnection(status: NWPath.Status) -> Bool {
        status == .satisfied
    }
}
