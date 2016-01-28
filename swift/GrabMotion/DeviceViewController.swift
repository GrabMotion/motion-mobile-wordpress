//
//  DeviceViewController.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/26/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    var deviceIp = String()
    
    var localaddrip = String()
    
    var payload_holder = [String]()
    
    var remotetcpport:Int = Int(Motion.Message_.SocketType.TcpEchoPort.rawValue)
    var bufferSize:Int    = Int(Motion.Message_.SocketType.SocketBufferNanoSize.rawValue)
    var packagesize       = Int32(Motion.Message_.SocketType.SocketBufferRegularSize.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(deviceIp)
        print(localaddrip)
        
        testtcpclient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testtcpclient(){
        
        let client:TCPClient = TCPClient(addr: deviceIp, port: remotetcpport)
        var (success,errmsg)=client.connect(timeout: 10)
        if success
        {
            
            let message = Motion.Message_.Builder()
            message.setTypes(Motion.Message_.ActionType.Engage)
            message.setServerip(localaddrip)
            message.setPackagesize(packagesize)

            var dataencoded = String()
            
            do
            {
                let m = try message.build()
                
                let data:NSData = m.data()
            
                dataencoded = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                
                print(dataencoded)
            
            } catch
            {
                print(error)
            }
            
            var (success,errmsg)=client.send(str: dataencoded)
            if success
            {
                print("bufferSize \(bufferSize)")
                let data=client.read(bufferSize) //1024*10)
                if let d=data
                {
                    if let str = String(bytes: d, encoding: NSUTF8StringEncoding)
                    {
                        print(str)
                        
                        print(str)
                        
                        print("----------------------")
                        
                        let filtered = splitMessage(str)
                        
                        print(filtered)
                        
                        let decodedData = NSData(base64EncodedString: filtered, options: NSDataBase64DecodingOptions(rawValue: 0))
                        
                        do
                        {
                            let mresponse = try Motion.Message_.parseFromData(decodedData!)
                        
                            let type = mresponse.getBuilder().types
                            
                            print(type)
                        
                        } catch
                        {
                            print(error)
                        }
                        
                    }
                }
            }else{
                print(errmsg)
            }

        
            
        } else {
            print(errmsg)
        }
    }
    
    func splitMessage(proto:String) -> String
    {
        
        let del_1  = "PROSTA"
        let del_2  = "PROSTO"
        
        var total__packages = 0;
        var current_package = 0;
        var current____type = 0;
        var proto_has_files = 0;
        var package____size = 0;
        
        let protorange: Range<String.Index> = proto.rangeOfString(del_2)!
        let del_pos: Int = proto.startIndex.distanceTo(protorange.startIndex)
        
        let from = del_pos+del_2.characters.count
        print(from)
        
        let indexheader = proto.startIndex.advancedBy(from-1)
        let pheader = String(proto.characters.prefixThrough(indexheader))
        
        print(pheader)
        
        var extracted = String()
        if proto.rangeOfString(del_1) != nil
        {
            let remove = pheader.stringByReplacingOccurrencesOfString(del_1, withString: "")
            extracted = remove.stringByReplacingOccurrencesOfString(del_2, withString: "")
        }

        var vpay = extracted.componentsSeparatedByString("::")
        total__packages = Int(vpay[0])!
        print(total__packages)
        current_package = Int(vpay[1])!
        print(current_package)
        current____type = Int(vpay[2])!
        print(current____type)
        proto_has_files = Int(vpay[3])!
        print(proto_has_files)
        package____size = Int(vpay[4])!
        print(package____size)
        
        let resultpayload = String(proto.characters.dropFirst(from))
        
        print(resultpayload)
        
        payload_holder.append(resultpayload)
        
        return resultpayload
        
    }
    
    
    
    
}
