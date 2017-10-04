//
//  SLCryptography.swift
//  SLCommunicator
//
//  Created by Shial on 24/8/17.
//
//

import Foundation
import Cryptor

extension CryptoUtils {
    public static func byteArray(from key: String, algorithm: Cryptor.Algorithm) -> [UInt8] {
        var keyBytes = CryptoUtils.byteArray(from: key)
        if keyBytes.count < algorithm.defaultKeySize {
            keyBytes = CryptoUtils.zeroPad(byteArray: keyBytes, blockSize: algorithm.defaultKeySize)
        } else if keyBytes.count > algorithm.defaultKeySize {
            keyBytes.removeLast(abs(algorithm.defaultKeySize - keyBytes.count))
        }
        return keyBytes
    }
}

public class SLCryptography {
    public static func encode (_ decoded: String, key: String, algorithm: Cryptor.Algorithm) -> String? {
        var data = CryptoUtils.byteArray(from: decoded)
        guard let vector: [UInt8] = try? Random.generate(byteCount: data.count) else {
            return nil
        }
        let count = data.count
        if data.count % algorithm.blockSize != 0 {
            data = CryptoUtils.zeroPad(byteArray: data, blockSize: algorithm.blockSize)
        }
        let keyArray = CryptoUtils.byteArray(from: key, algorithm: algorithm)
        guard let encoded = Cryptor(operation: .encrypt, algorithm: algorithm, options: .none,
                                    key: keyArray, iv: vector).update(byteArray: data)?.final() else {
            return nil
        }
        return "\(count)SL\(CryptoUtils.hexString(from: vector))SL\(CryptoUtils.hexString(from: encoded))"
    }
    
    public static func decode (_ encoded: String, key: String, algorithm: Cryptor.Algorithm) -> String? {
        let chiper = encoded.components(separatedBy: "SL")
        guard chiper.count == 3,
        let count: Int = Int(chiper[0]) else { return nil }
        let vector: String = chiper[1]
        let data: String = chiper[2]
        let keyArray = CryptoUtils.byteArray(from: key, algorithm: algorithm)
        guard let decoded = Cryptor(operation: .decrypt, algorithm: algorithm, options: .none,
                                    key: keyArray,
                                    iv: CryptoUtils.byteArray(fromHex: vector))
            .update(byteArray: CryptoUtils.byteArray(fromHex: data))?.final(),
        decoded.count >= count else {
            return nil
        }
        return String(data: Data(bytes: decoded.dropLast(decoded.count - count)), encoding: .utf8)
    }
}
