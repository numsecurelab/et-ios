public extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    init?(hex: String) {
        let hex = hex.stripHexPrefix()

        let len = hex.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hex.index(hex.startIndex, offsetBy: i * 2)
            let k = hex.index(j, offsetBy: 2)
            let bytes = hex[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }

        self = data
    }

    func toHexString() -> String {
        "0x" + self.toRawHexString()
    }

    func toRawHexString() -> String {
        reduce("") { $0 + String(format: "%02x", $1) }
    }

    func toEIP55Address() -> String {
        EIP55.format(address: self.toRawHexString())
    }

    var bytes: Array<UInt8> {
        Array(self)
    }

    func to<T>(type: T.Type) -> T {
        self.withUnsafeBytes { $0.load(as: T.self) }
    }

}

extension Int {

    var flowControlLog: String {
        "\(Double(self) / 1_000_000)"
    }

}

extension String {

    func removeLeadingZeros() -> String {
        self.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
    }

    func stripHexPrefix() -> String {
        let prefix = "0x"

        if self.hasPrefix(prefix) {
            return String(self.dropFirst(prefix.count))
        }

        return self
    }

    func addHexPrefix() -> String {
        let prefix = "0x"

        if self.hasPrefix(prefix) {
            return self
        }

        return prefix.appending(self)
    }

}

extension Decimal {

    public func roundedString(decimal: Int) -> String {
        let poweredDecimal = self * pow(10, decimal)
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let roundedDecimal = NSDecimalNumber(decimal: poweredDecimal).rounding(accordingToBehavior: handler).decimalValue

        return String(describing: roundedDecimal)
    }

}
