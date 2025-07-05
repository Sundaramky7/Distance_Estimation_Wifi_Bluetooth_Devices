import Foundation
import CoreWLAN

// Distance estimation function (log-distance path loss model)
func estimateDistance(rssi: Int, referenceRSSI: Int = -30, pathLossExponent: Double = 2.0) -> Double {
    let referenceDistance = 1.0
    let exponent = Double(referenceRSSI - rssi) / (10 * pathLossExponent)
    return referenceDistance * pow(10.0, exponent)
}


// Main scanning function
func scanWiFiNetworks() {
    let client = CWWiFiClient.shared()
    guard let interface = client.interface() else {
        print("\(red)Failed to get Wi-Fi interface.\(reset)")
        return
    }
    
    do {
        let networks = try interface.scanForNetworks(withSSID: nil)
        
        if networks.isEmpty {
            print("\(red)No Wi-Fi networks found.\(reset)")
            return
        }
        
        print("---------------------------------------------------------------")
        for network in networks {
            let ssid = network.ssid ?? "Unknown SSID"
            let rssi = network.rssiValue
            let distance = estimateDistance(rssi: rssi)
            
            
            print("📡 \(yellow)SSID: \(green)\(ssid), \(yellow)RSSI: \(green)\(rssi) dBm → \(yellow)Estimated Distance: \(green)\(String(format: "%.2f", distance)) m\(reset)")
        }
    } catch {
        print("\(red)Failed to scan Wi-Fi networks: \(error)\(reset)")
    }
}

//defining colours
let reset = "\u{001B}[0;0m"
let red = "\u{001B}[1;31m"
let green = "\u{001B}[0;32m"
let yellow = "\u{001B}[0;33m"

        
// clear the screen
print("\u{001B}[2J\u{001B}[H")
print("\(red)Nearby Wi-Fi Networks:")
// print("---------------------\(reset)")
print("^^^^^^^^^^^^^^^^^^^^^^\(reset)")


// Running the scanner in loop
while true {    
    scanWiFiNetworks()

    // Wait for 5 seconds before next scan (adjust as needed)
    sleep(5)
}
