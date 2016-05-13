// Generated by the Protocol Buffers 3.0 compiler.  DO NOT EDIT!
// Source file "source_context.proto"
// Syntax "Proto3"

import Foundation

public extension Google.Protobuf{}

public func == (lhs: Google.Protobuf.SourceContext, rhs: Google.Protobuf.SourceContext) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasFileName == rhs.hasFileName) && (!lhs.hasFileName || lhs.fileName == rhs.fileName)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Google.Protobuf {
  public struct SourceContextRoot {
    public static var sharedInstance : SourceContextRoot {
     struct Static {
         static let instance : SourceContextRoot = SourceContextRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Google.Protobuf.SwiftDescriptorRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  // `SourceContext` represents information about the source of a
  // protobuf element, like the file in which it is defined.
  final public class SourceContext : GeneratedMessage, GeneratedMessageProtocol {
    // The path-qualified name of the .proto file that contained the associated
    // protobuf element.  For example: `"google/protobuf/source.proto"`.
    public private(set) var hasFileName:Bool = false
    public private(set) var fileName:String = ""

    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasFileName {
        try output.writeString(1, value:fileName)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasFileName {
        serialize_size += fileName.computeStringSize(1)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Google.Protobuf.SourceContext> {
      var mergedArray = Array<Google.Protobuf.SourceContext>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Google.Protobuf.SourceContext? {
      return try Google.Protobuf.SourceContext.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Google.Protobuf.SourceContext {
      return try Google.Protobuf.SourceContext.Builder().mergeFromData(data, extensionRegistry:Google.Protobuf.SourceContextRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Google.Protobuf.SourceContext {
      return try Google.Protobuf.SourceContext.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Google.Protobuf.SourceContext {
      return try Google.Protobuf.SourceContext.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Google.Protobuf.SourceContext {
      return try Google.Protobuf.SourceContext.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Google.Protobuf.SourceContext {
      return try Google.Protobuf.SourceContext.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Google.Protobuf.SourceContext {
      return try Google.Protobuf.SourceContext.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Google.Protobuf.SourceContext.Builder {
      return Google.Protobuf.SourceContext.classBuilder() as! Google.Protobuf.SourceContext.Builder
    }
    public func getBuilder() -> Google.Protobuf.SourceContext.Builder {
      return classBuilder() as! Google.Protobuf.SourceContext.Builder
    }
    override public class func classBuilder() -> MessageBuilder {
      return Google.Protobuf.SourceContext.Builder()
    }
    override public func classBuilder() -> MessageBuilder {
      return Google.Protobuf.SourceContext.Builder()
    }
    public func toBuilder() throws -> Google.Protobuf.SourceContext.Builder {
      return try Google.Protobuf.SourceContext.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Google.Protobuf.SourceContext) throws -> Google.Protobuf.SourceContext.Builder {
      return try Google.Protobuf.SourceContext.Builder().mergeFrom(prototype)
    }
    override public func encode() throws -> Dictionary<String,AnyObject> {
      guard isInitialized() else {
        throw ProtocolBuffersError.InvalidProtocolBuffer("Uninitialized Message")
      }

      var jsonMap:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
      if hasFileName {
        jsonMap["fileName"] = fileName
      }
      return jsonMap
    }
    override class public func decode(jsonMap:Dictionary<String,AnyObject>) throws -> Google.Protobuf.SourceContext {
      return try Google.Protobuf.SourceContext.Builder.decodeToBuilder(jsonMap).build()
    }
    override class public func fromJSON(data:NSData) throws -> Google.Protobuf.SourceContext {
      return try Google.Protobuf.SourceContext.Builder.fromJSONToBuilder(data).build()
    }
    override public func getDescription(indent:String) throws -> String {
      var output = ""
      if hasFileName {
        output += "\(indent) fileName: \(fileName) \n"
      }
      output += unknownFields.getDescription(indent)
      return output
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasFileName {
               hashCode = (hashCode &* 31) &+ fileName.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Google.Protobuf.SourceContext"
    }
    override public func className() -> String {
        return "Google.Protobuf.SourceContext"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Google.Protobuf.SourceContext.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Google.Protobuf.SourceContext = Google.Protobuf.SourceContext()
      public func getMessage() -> Google.Protobuf.SourceContext {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var hasFileName:Bool {
           get {
                return builderResult.hasFileName
           }
      }
      public var fileName:String {
           get {
                return builderResult.fileName
           }
           set (value) {
               builderResult.hasFileName = true
               builderResult.fileName = value
           }
      }
      public func setFileName(value:String) -> Google.Protobuf.SourceContext.Builder {
        self.fileName = value
        return self
      }
      public func clearFileName() -> Google.Protobuf.SourceContext.Builder{
           builderResult.hasFileName = false
           builderResult.fileName = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      override public func clear() -> Google.Protobuf.SourceContext.Builder {
        builderResult = Google.Protobuf.SourceContext()
        return self
      }
      override public func clone() throws -> Google.Protobuf.SourceContext.Builder {
        return try Google.Protobuf.SourceContext.builderWithPrototype(builderResult)
      }
      override public func build() throws -> Google.Protobuf.SourceContext {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Google.Protobuf.SourceContext {
        let returnMe:Google.Protobuf.SourceContext = builderResult
        return returnMe
      }
      public func mergeFrom(other:Google.Protobuf.SourceContext) throws -> Google.Protobuf.SourceContext.Builder {
        if other == Google.Protobuf.SourceContext() {
         return self
        }
        if other.hasFileName {
             fileName = other.fileName
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      override public func mergeFromCodedInputStream(input:CodedInputStream) throws -> Google.Protobuf.SourceContext.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      override public func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Google.Protobuf.SourceContext.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let protobufTag = try input.readTag()
          switch protobufTag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            fileName = try input.readString()

          default:
            if (!(try parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:protobufTag))) {
               unknownFields = try unknownFieldsBuilder.build()
               return self
            }
          }
        }
      }
      override class public func decodeToBuilder(jsonMap:Dictionary<String,AnyObject>) throws -> Google.Protobuf.SourceContext.Builder {
        let resultDecodedBuilder = Google.Protobuf.SourceContext.Builder()
        if let jsonValueFileName = jsonMap["fileName"] as? String {
          resultDecodedBuilder.fileName = jsonValueFileName
        }
        return resultDecodedBuilder
      }
      override class public func fromJSONToBuilder(data:NSData) throws -> Google.Protobuf.SourceContext.Builder {
        let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        guard let jsDataCast = jsonData as? Dictionary<String,AnyObject> else {
          throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid JSON data")
        }
        return try Google.Protobuf.SourceContext.Builder.decodeToBuilder(jsDataCast)
      }
    }

  }

}

// @@protoc_insertion_point(global_scope)
