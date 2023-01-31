# NetworkFlows

A simple SwiftPM package reporting network traffic to you.

## Introduction

<img src="assets/screenshot.png" width=300 />

NetworkFlows provides you with all the information you need to display network traffic.

Include:

- Upload / Download Total: wifi, cellular, total
- Upload / Download per Second: wifi, cellular, total

Value and unit are in separate properties, so you can display them as you like.

## Usage

### With ObservedObject (SwiftUI)

1. Add the ObservedObject.

```
@ObservedObject var traffic = ObservableTrafficMonitor.observableShared
```
2. Show everything you want.
```
Text(traffic.newTrafficInfo?.downTrafficTotal.humanReadableNumber ?? "--")
+
Text(" ")
+
Text(traffic.newTrafficInfo?.downTrafficTotal.humanReadableNumberUnit ?? "--")
```
It should look like: ``` 100 KB/s ```.

### With Delegate

1. Conform to TrafficMonitorDelegate.
```
func trafficMonitor(updatedInfo: TrafficInfo) {
    let number = updatedInfo.totalTrafficInfo.downTotal.humanReadableNumber
    let unit = updatedInfo.totalTrafficInfo.downTotal.humanReadableNumberUnit
    print(number + " " + unit)
}
```
2. Set the delegate to self.

```
TrafficMonitor.shared.delegate = self
```

That's it! Check out the demo app for more information.

### Result Struct
```
TrafficInfo
├── totalTrafficInfo: TotalTrafficInfo
│   ├── cellularDown
│   ├── cellularTotal
│   ├── wifiUp
│   ├── wifiDown
│   ├── wifiTotal
│   ├── upTotal
│   └── downTotal
├── cellularTrafficUp
├── cellularTrafficDown
├── cellularTrafficTotal
├── wifiTrafficUp
├── wifiTrafficDown
├── wifiTrafficTotal
├── upTrafficTotal
└── downTrafficTotal

TrafficInfoItem
├── byteCount: Int
├── humanReadableNumber: String
└── humanReadableNumberUnit: String
```
