//
//  ViewController.swift
//  ble
//
//  Created by Youngjin Ha on 4/24/25.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    var centralManager: CBCentralManager!
    var discoverdPeripherals: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BLE
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }


}

extension ViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // BLE 상태 확인
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("BLE 켜짐")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("BLE 사용 불가 상태: \(central.state.rawValue)")
        }
    }
    
    // 기기 스캔 결과
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("발견 기기: \(peripheral.name ?? "이름 없음") - RSSI: \(RSSI)")
        
        if !discoverdPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            discoverdPeripherals.append(peripheral)
            peripheral.delegate = self
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    // 연결 성공
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("연결 성공: \(peripheral.name ?? "이름 없음")")
        
        // 서비스 검색 시작
        peripheral.discoverServices(nil)
    }
    
    // 서비스 검색 결과
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard let services = peripheral.services else { return }
        print("발견된 서비스 수: \(services.count)")
        
        for service in services {
            print("서비스 UUID: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    // 특성 검색 결과
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("특성 UUID: \(characteristic.uuid)")
        }
    }
}

