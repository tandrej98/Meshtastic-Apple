//
//  SerialConfig.swift
//  Meshtastic Apple
//
//  Copyright (c) Garth Vander Houwen 6/22/22.
//
import SwiftUI

struct SerialConfig: View {

	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var bleManager: BLEManager
	@Environment(\.dismiss) private var goBack

	var node: NodeInfoEntity?

	@State private var isPresentingSaveConfirm: Bool = false
	@State var hasChanges = false

	@State var enabled = false
	@State var echo = false
	@State var rxd = 0
	@State var txd = 0
	@State var baudRate = 0
	@State var timeout = 0
	@State var overrideConsoleSerialPort = false
	@State var mode = 0
	


	var body: some View {
		VStack {
			Form {
				if node != nil && node?.metadata == nil && node?.num ?? 0 != bleManager.connectedPeripheral?.num ?? 0 {
					Text("There has been no response to a request for device metadata over the admin channel for this node.")
						.font(.callout)
						.foregroundColor(.orange)

				} else if node != nil && node?.num ?? 0 != bleManager.connectedPeripheral?.num ?? 0 {
					// Let users know what is going on if they are using remote admin and don't have the config yet
					if node?.serialConfig == nil {
						Text("Serial config data was requested over the admin channel but no response has been returned from the remote node. You can check the status of admin message requests in the admin message log.")
							.font(.callout)
							.foregroundColor(.orange)
					} else {
						Text("Remote administration for: \(node?.user?.longName ?? "Unknown")")
							.font(.title3)
							.onAppear {
								setSerialValues()
							}
					}
				} else if node != nil && node?.num ?? 0 == bleManager.connectedPeripheral?.num ?? 0 {
					Text("Configuration for: \(node?.user?.longName ?? "Unknown")")
						.font(.title3)
				} else {
					Text("Please connect to a radio to configure settings.")
						.font(.callout)
						.foregroundColor(.orange)
				}
				Section(header: Text("options")) {

					Toggle(isOn: $enabled) {

						Label("enabled", systemImage: "terminal")
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))

					Toggle(isOn: $echo) {

						Label("echo", systemImage: "repeat")
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))
					Text("If set, any packets you send will be echoed back to your device.")
						.font(.caption)

					Picker("Baud", selection: $baudRate ) {
						ForEach(SerialBaudRates.allCases) { sbr in
							Text(sbr.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())

					Picker("timeout", selection: $timeout ) {
						ForEach(SerialTimeoutIntervals.allCases) { sti in
							Text(sti.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
					Text("The amount of time to wait before we consider your packet as done.")
						.font(.caption)

					Picker("mode", selection: $mode ) {
						ForEach(SerialModeTypes.allCases) { smt in
							Text(smt.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
				}
				Section(header: Text("GPIO")) {

					Picker("Receive data (rxd) GPIO pin", selection: $rxd) {
						ForEach(0..<49) {
							if $0 == 0 {
								Text("unset")
							} else {
								Text("Pin \($0)")
							}
						}
					}
					.pickerStyle(DefaultPickerStyle())

					Picker("Transmit data (txd) GPIO pin", selection: $txd) {
						ForEach(0..<49) {
							if $0 == 0 {
								Text("unset")
							} else {
								Text("Pin \($0)")
							}
						}
					}
					.pickerStyle(DefaultPickerStyle())
					Text("Set the GPIO pins for RXD and TXD.")
						.font(.caption)
				}
			}
			.disabled(self.bleManager.connectedPeripheral == nil || node?.serialConfig == nil)

			Button {

				isPresentingSaveConfirm = true

			} label: {

				Label("save", systemImage: "square.and.arrow.down")
			}
			.disabled(bleManager.connectedPeripheral == nil || !hasChanges)
			.buttonStyle(.bordered)
			.buttonBorderShape(.capsule)
			.controlSize(.large)
			.padding()
			.confirmationDialog(

				"are.you.sure",
				isPresented: $isPresentingSaveConfirm,
				titleVisibility: .visible
			) {
				let nodeName = node?.user?.longName ?? "unknown".localized
				let buttonText = String.localizedStringWithFormat("save.config %@".localized, nodeName)
				Button(buttonText) {
					let connectedNode = getNodeInfo(id: bleManager.connectedPeripheral.num, context: context)
					if connectedNode != nil {
						var sc = ModuleConfig.SerialConfig()
						sc.enabled = enabled
						sc.echo = echo
						sc.rxd = UInt32(rxd)
						sc.txd = UInt32(txd)
						sc.baud = SerialBaudRates(rawValue: baudRate)!.protoEnumValue()
						sc.timeout = UInt32(timeout)
						sc.overrideConsoleSerialPort = overrideConsoleSerialPort
						sc.mode	= SerialModeTypes(rawValue: mode)!.protoEnumValue()

						let adminMessageId =  bleManager.saveSerialModuleConfig(config: sc, fromUser: connectedNode!.user!, toUser: node!.user!, adminIndex: connectedNode?.myInfo?.adminIndex ?? 0)

						if adminMessageId > 0 {
							// Should show a saved successfully alert once I know that to be true
							// for now just disable the button after a successful save
							hasChanges = false
							goBack()
						}
					}
				}
			}
			message: {
				Text("config.save.confirm")
			}
			.navigationTitle("serial.config")
			.navigationBarItems(trailing:

				ZStack {
					ConnectedDevice(bluetoothOn: bleManager.isSwitchedOn, deviceConnected: bleManager.connectedPeripheral != nil, name: (bleManager.connectedPeripheral != nil) ? bleManager.connectedPeripheral.shortName : "?")
			})
			.onAppear {
				if self.bleManager.context == nil {
					self.bleManager.context = context
				}
				setSerialValues()
				// Need to request a SerialModuleConfig from the remote node before allowing changes
				if bleManager.connectedPeripheral != nil && node?.serialConfig == nil {
					print("empty serial module config")
					let connectedNode = getNodeInfo(id: bleManager.connectedPeripheral.num, context: context)
					if node != nil && connectedNode != nil {
						_ = bleManager.requestSerialModuleConfig(fromUser: connectedNode!.user!, toUser: node!.user!, adminIndex: connectedNode?.myInfo?.adminIndex ?? 0)
					}
				}

			}
			.onChange(of: enabled) { newEnabled in

				if node != nil && node!.serialConfig != nil {

					if newEnabled != node!.serialConfig!.enabled { hasChanges = true	}
				}
			}
			.onChange(of: echo) { newEcho in

				if node != nil && node!.serialConfig != nil {

					if newEcho != node!.serialConfig!.echo { hasChanges = true	}
				}
			}
			.onChange(of: rxd) { newRxd in

				if node != nil && node!.serialConfig != nil {

					if newRxd != node!.serialConfig!.rxd { hasChanges = true	}
				}
			}
			.onChange(of: txd) { newTxd in

				if node != nil && node!.serialConfig != nil {

					if newTxd != node!.serialConfig!.txd { hasChanges = true	}
				}
			}
			.onChange(of: baudRate) { newBaud in

				if node != nil && node!.serialConfig != nil {

					if newBaud != node!.serialConfig!.baudRate { hasChanges = true	}
				}
			}
			.onChange(of: timeout) { newTimeout in

				if node != nil && node!.serialConfig != nil {

					if newTimeout != node!.serialConfig!.timeout { hasChanges = true	}
				}
			}
			.onChange(of: overrideConsoleSerialPort) { newOverrideConsoleSerialPort in

				if node != nil && node!.serialConfig != nil {

					if newOverrideConsoleSerialPort != node!.serialConfig!.overrideConsoleSerialPort { hasChanges = true	}
				}
			}
			.onChange(of: mode) { newMode in

				if node != nil && node!.serialConfig != nil {

					if newMode != node!.serialConfig!.mode { hasChanges = true	}
				}
			}
		}
	}
	func setSerialValues() {
		self.enabled = node?.serialConfig?.enabled ?? false
		self.echo = node?.serialConfig?.echo ?? false
		self.rxd = Int(node?.serialConfig?.rxd ?? 0)
		self.txd = Int(node?.serialConfig?.txd ?? 0)
		self.baudRate = Int(node?.serialConfig?.baudRate ?? 0)
		self.timeout = Int(node?.serialConfig?.timeout ?? 0)
		self.mode = Int(node?.serialConfig?.mode ?? 0)
		self.overrideConsoleSerialPort = false // node?.serialConfig?.overrideConsoleSerialPort ?? false
		self.hasChanges = false
	}
}
