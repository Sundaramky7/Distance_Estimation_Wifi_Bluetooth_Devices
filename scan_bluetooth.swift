import Foundation
import CoreBluetooth
// Distance estimation using path loss model
func estimateDistance(rssi: Double, referenceRSSI: Double = -30, pathLossExponent: Double = 2.0) -> Double {
    let referenceDistance = 1.0 // meters
    let exponent = (referenceRSSI - rssi) / (10 * pathLossExponent)
    return referenceDistance * pow(10.0, exponent)
}

// Bluetooth Scanner class
class BLEScanner: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("✅ Bluetooth is ON. Scanning...\n")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff:
            print("❌ Bluetooth is OFF.")
        case .unauthorized:
            print("❌ Bluetooth access unauthorized.")
        default:
            print("⚠️ Bluetooth not ready (state: \(central.state.rawValue)).")
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        let name = peripheral.name ?? "Unknown"
        let rssiValue = RSSI.doubleValue

        guard rssiValue != 127 else { return } // Ignore invalid RSSI
        let distance = estimateDistance(rssi: rssiValue)


        print("📡 \(yellow)Device: \(green)\(name), \(yellow) RSSI: \(green)\(rssiValue) \(yellow)dBm → \(yellow) Estimated Distance: \(green)\(String(format: "%.2f", distance)) \(yellow)m\n")
    }
}

// defining colours
let red = "\u{001B}[1;31m"
let green = "\u{001B}[0;32m"
let yellow = "\u{001B}[0;33m"
let reset = "\u{001B}[0;0m"

// clear the screen
print("\u{001B}[2J\u{001B}[H")

// Start scanning
let scanner = BLEScanner()
RunLoop.main.run()
