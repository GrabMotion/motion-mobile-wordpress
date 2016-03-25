//
//  Socket.swift
//  GrabMotion
//
//  Created by Macbook Pro DT on 1/28/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

import Foundation
import ProtocolBuffers

protocol SocketProtocolDelegate
{
    func simpleMessageReceived(message: Motion.Message_)
}

class Socket
{
    
    var delegate:SocketProtocolDelegate? = nil
    
    var remotetcpport:Int = Int(Motion.Message_.SocketType.TcpEchoPort.rawValue)
    var bufferSize:Int    = Int(Motion.Message_.SocketType.SocketBufferNanoSize.rawValue)
    var packagesize       = Int32(Motion.Message_.SocketType.SocketBufferNanoSize.rawValue)

    var deviceIp = String()

    func setDeviceIp(ip: String)
    {
        self.deviceIp = ip
    }
    
    func setLocaladdrip(localaddrip: String)
    {
        self.localaddrip = localaddrip
    }
    
    var localaddrip = String()
    
    var payload_holder = [String]()
    
    var finished = Bool()

    var files = [String]()
    
    func sendMessage(message: String) //message: Motion.Message_.Builder)
    {
        
        print("deviceIp: \(deviceIp) remotetcpport: \(remotetcpport)")
        
        let client:TCPClient = TCPClient(addr: deviceIp, port: remotetcpport)
        
        var (success,errmsg) = client.connect(timeout: 10)
        if success
        {
         

            /*message.setPackagesize(packagesize)
            
            var dataencoded = String()
            
            do
            {
                let m = try message.build()
                
                let data:NSData = m.data()
                
                dataencoded = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                
                //print(dataencoded)
                
            } catch
            {
                print(error)
            }*/
            
            var (success,errmsg) = client.send(str: message)
            if success
            {
                print("packagesize \(packagesize)")

                var buffer:Int = Int(packagesize) + 40

                let data=client.read( buffer ) //1024*10)
                if let d=data
                {
                    if let str = String(bytes: d, encoding: NSUTF8StringEncoding)
                    {
                        print("----------------------")

                        print("buffer_________: \(buffer)")
                        print("buffer_recevice: \(str.characters.count)")
                        
                        if str.characters.count < buffer
                        {
                            print("::::::::DATA LOSS OR LAST::::::::")
                        } 

                        let hasfinihed = splitMessage(str)

                        if hasfinihed.0 //finished
                        {

                            var payload = String()
                            for part in self.payload_holder
                            {
                                payload += part
                            }
                            self.payload_holder.removeAll()

                            //print("payload: \(payload)")

                            if hasfinihed.1
                            {
                               let resutlsplit = splitAppendedFiles(payload)
                               payload  = resutlsplit.0
                               self.files    = resutlsplit.1
                            }

                            //print("***************************")

                            let decodedData = NSData(base64EncodedString: payload, options: NSDataBase64DecodingOptions(rawValue: 0))
                            
                            //print("decodedData: \(decodedData)")

                            do
                            {
                                let mresponse = try Motion.Message_.parseFromData(decodedData!)
                                
                                /*if mresponse.types.hashValue == Motion.Message_.ActionType.Engage.hashValue
                                {
                                    let rcameras:[Motion.Message_.MotionCamera] = mresponse.motioncamera
                                    
                                    let count:Int
                                    if rcameras.count > 0
                                    {   
                                        for rcamera:Motion.Message_.MotionCamera in rcameras
                                        {
                                            rcamera.setThumbnail(files[count].dataUsingEncoding(NSUTF8StringEncoding))
                                        }
                                        count++
                                    }
                                }*/  

                                if (delegate != nil)
                                {
                                    delegate?.simpleMessageReceived(mresponse)    
                                }
         
                            } catch
                            {
                                print(error)
                            }
                        }
                    }
                }

            }else{
                print(errmsg)
            }
            
            
        } else 
        {
            print(errmsg)
        }

    }

    func splitAppendedFiles(proto: String) -> (payload:String, files:[String])
    {
        let filedelimiter = "PROFILE"

        print("proto \(proto.characters.count)")

        let arr = proto.componentsSeparatedByString(filedelimiter)

        //let arr = split(proto.characters){$0 == "PROFILE"}.map(String.init)

        let payload = arr[0]
        let imagespayload  = arr[1]

        print(payload.characters.count)
        print(imagespayload.characters.count)

        return (payload, parseAppendedFiles(imagespayload))
    }

   
    func parseAppendedFiles(files:String) -> [String]
    {

        var allfiles = [String]()

        let amount:Int = Int(files.substringWithRange(0, end: 4))!

        let payload:String = files.substringWithRange(4, end: files.characters.count)

        for var i = 0; i < amount; ++i 
        {
            let thumbstart = "THUMBNAILSTART\(i)"
            
            let startrange: Range<String.Index> = payload.rangeOfString(thumbstart)!
            let frompos: Int = payload.startIndex.distanceTo(startrange.startIndex)

            print("payload: \(payload.characters.count)")

            let from = frompos + thumbstart.characters.count

            let thumbend = "THUMBNAILEND\(i)"

            let rangeto: Range<String.Index> = payload.rangeOfString(thumbend)!
            let to: Int = payload.startIndex.distanceTo(rangeto.startIndex)

            //let rangeend        = payload.rangeOfString(thumbend)!
            //let endIndex: Int   = payload.startIndex.distanceTo(rangeend.startIndex)

            //let endrange: Range<String.Index> = payload.rangeOfString(thumbend)!
            //let to: Int = payload.startIndex.

            let thumbnail = payload.substringWithRange(from, end: to)

            print("thumbnail: \(thumbnail.characters.count)")

            allfiles.append(thumbnail)
        }

        return allfiles
    }

    
    func splitMessage(proto:String) -> (finished: Bool, files: Bool)
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

        total__packages = Int(vpay[1])!
        print("total__packages: \(total__packages)")
        
        current_package = Int(vpay[2])!
        print("current_package: \(current_package)")
        
        current____type = Int(vpay[3])!
        print("current____type: \(current____type)")
        
        proto_has_files = Int(vpay[4])!
        print("proto_has_files: \(proto_has_files)")
        
        package____size = Int(vpay[0])!
        print("package____size: \(package____size)")
        
        let resultpayload = String(proto.characters.dropFirst(from))

        let result__payload:Int = resultpayload.characters.count
        
        print("result__payload: \(result__payload)")

        payload_holder.append(resultpayload)

        var hasfiles = Bool()

        if total__packages == (current_package+1)       
        {
            finished = true

            //print(proto)
            //print(".................................")
            //print (extracted)
            //print("...............................")
            //print (resultpayload)
            
            if proto_has_files == 3030
            {
                hasfiles = true
            } 

        } else 
        {
            finished = false

            var message_struct = UserToProto()
            message_struct.type = Motion.Message_.ActionType.ResponseNext.rawValue as Int32
            
            
            
            //var mreply = Motion.Message_.Builder()
            //mreply.setTypes(.ResponseNext)            
            //mreply.setPackagesize(packagesize)
        
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) 
            {
                self.sendMessage(message_struct)
            }
        
        }
        
        return (finished, hasfiles)
        
    }

}

extension String 
{


  func substringWithRange(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(end))
        return self.substringWithRange(range)
    }

}