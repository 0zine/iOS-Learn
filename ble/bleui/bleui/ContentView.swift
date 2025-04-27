//
//  ContentView.swift
//  bleui
//
//  Created by Youngjin Ha on 4/24/25.
//

import SwiftUI
import CoreBluetooth

class BLEManager: NSObject, ObservableObject {
    @Published var peripherals: [CBPeripheral] = []
    @Published var statusMessage: String = "스캔 준비중..."
    
    private var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BLEManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            statusMessage = "스캔 시작"
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }else {
            statusMessage = "BLE 상태: \(central.state.rawValue)"
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        DispatchQueue.main.async {
            if !self.peripherals.contains(where: { $0.identifier == peripheral.identifier }) {
                self.peripherals.append(peripheral)
            }
        }
    }
    
    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        statusMessage = "\(peripheral.name ?? "알 수 없음") 연결중..."
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        statusMessage = "\(peripheral.name ?? "기기") 연결됨"
    }
}

struct ContentView: View {
    
    @ObservedObject var bleManager: BLEManager = BLEManager()
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text(bleManager.statusMessage)
                    .font(.headline)
                    .padding()
                
                List(bleManager.peripherals, id: \.identifier) { peripheral in
                    Button(action: {
                        bleManager.connect(to: peripheral)
                    }) {
                        HStack {
                            Text(peripheral.name ?? "이름 없는 기기")
                            Spacer()
                            Image(systemName: "dot.radiowaves.left.and.right")
                        }
                    }
                }
                
            }
            .navigationTitle("BLE 기기 스캔")
        }
    }
}

#Preview {
    ContentView()
}
