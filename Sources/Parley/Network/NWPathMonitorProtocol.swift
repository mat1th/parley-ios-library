import Network

protocol NWPathMonitorProtocol: AnyObject {
    var pathUpdateHandler: (@Sendable (_ newPath: NWPath) -> Void)? { get set }
    var currentPath: NWPath { get }

    func start(queue: DispatchQueue)
    func cancel()
}

extension NWPathMonitor: NWPathMonitorProtocol {}
