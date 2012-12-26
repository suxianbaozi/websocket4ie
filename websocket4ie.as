package {
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Timer;
        import flash.net.Socket;
        import flash.utils.ByteArray;
        import flash.utils.Endian;
	public class websocket4ie extends Sprite {
            // Cause SWFUpload to start as soon as the movie starts
            public static function main():void
            {       
                var websocket4ie:websocket4ie = new websocket4ie();
            }
            private var debugEnabled:Boolean;
            private var movieName:String;

            private var server:String;

            private var port:Number;

            private var socket:Socket; 
            private var socketBuffer:ByteArray = new ByteArray();
            public function websocket4ie() {
                Security.allowDomain("*");	
                var counter:Number = 0;
                root.addEventListener(Event.ENTER_FRAME, function ():void { if (++counter > 100) counter = 0; });

                this.movieName = root.loaderInfo.parameters.movieName;
                this.server = root.loaderInfo.parameters.server;
                this.port = root.loaderInfo.parameters.port;
                this.debug(this.port+''+this.server);
                try {
                    this.debugEnabled = root.loaderInfo.parameters.debugEnabled == "true" ? true : false;
                } catch (ex:Object) {
                    this.debugEnabled = false;
                }
                this.connectServer();
            }
            public function connectServer():void {
                socket = new Socket();
                socket.endian = Endian.BIG_ENDIAN;
                socket.addEventListener(Event.CONNECT, onConnect);       
                socket.addEventListener(Event.CLOSE, onClose);
                socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
                socket.connect(this.server, this.port); 
                this.socket = socket;
            }

            public function onConnect(e:Event):void {
                ExternalInterface.call("connectHandle");
                //握手
                var headers:Array = new Array();
                headers.push("GET /chat HTTP/1.1\r\n");
                headers.push("Upgrade: websocket\r\n");
                headers.push("Connection: Upgrade\r\n");
                headers.push("Host: "+this.server+":"+this.port+"\r\n");
                headers.push("Origin: null\r\n");
                headers.push("Sec-WebSocket-Key: 6z4ezNfATjW5/FEMYpqRuw==\r\n");
                headers.push("Sec-WebSocket-Version: 13\r\n\r\n\r\n");
                this.socket.writeUTFBytes(headers.join('')); 
                this.socket.flush();
            }
            
            public function onClose(e:Event):void {
                ExternalInterface.call("closeHandle",'1');
            }

            public function onIOError(e:IOErrorEvent):void {
                ExternalInterface.call("closeHandle",'2');
            }

            public function onSecurityError(e:SecurityErrorEvent):void {
                ExternalInterface.call("closeHandle",'3');
            }
            
            public var step:String = "head";
            
            
            public function readData():void {
                
            }

            public var position:Number = 0;

            public function debug(str:*):void {
                ExternalInterface.call("console.log",str);
            }
            public function readOnData():void {

                
                
                var tmpPos:Number = this.position;
                this.socketBuffer.position = this.position;

                //read 一个 0x81
                if(this.socketBuffer.bytesAvailable>=1) {
                    var h:Number = this.socketBuffer.readUnsignedByte();
                    this.debug("头:"+h);
                    this.position += 1;
                    if(this.socketBuffer.bytesAvailable>=1) { 
                        var len:Number = this.socketBuffer.readUnsignedByte();
                        this.debug("长度:"+len);
                        this.position += 1;
                        if(len<=125) {
                            if(this.socketBuffer.bytesAvailable>=len) { 
                                this.onText(this.socketBuffer.readUTFBytes(len));
                                this.position += len;
                                this.readOnData();
                            } else {
                                this.position = tmpPos;
                                return;
                            }
                        } else if(len==126) {
                            if(this.socketBuffer.bytesAvailable>=2) {
                                var trueLen:Number = this.socketBuffer.readUnsignedShort();
                                if(this.socketBuffer.bytesAvailable>=trueLen) {
                                    this.onText(this.socketBuffer.readUTFBytes(trueLen));
                                    this.position += trueLen;
                                    this.readOnData();
                                }
                            } else {
                                this.position = tmpPos;
                                return;
                            }
                        }
                    } else {
                        this.position = tmpPos;
                        return;
                    }
                } else {
                    this.position = tmpPos;
                    return;
                }
            }
            public function onText(text:String):void {
                ExternalInterface.call("onText",text);
            }
            
            public function writeBytes(bytes:ByteArray):void {
                
                this.socketBuffer.position = this.socketBuffer.length;
                this.socketBuffer.writeBytes(bytes,0,bytes.length);
                this.debug("buffer数据:"+this.socketBuffer.length);
                this.readOnData();
            }
            public var is_head:Boolean = true;
            public function onSocketData(e:Event):void {
                var bytes:ByteArray = new ByteArray();
                if(this.is_head) {
                    while(this.socket.bytesAvailable) {
                        var x:Number = this.socket.readUnsignedByte();
                        
                        if(x==0x81) {
                            this.is_head = false;
                            bytes.writeByte(0x81);
                            break;
                        } else {
                            continue; 
                        }
                    }
                    if(this.socket.bytesAvailable) { 
                        this.socket.readBytes(bytes,1,this.socket.bytesAvailable);
                    }
                } else {
                    this.socket.readBytes(bytes,0,this.socket.bytesAvailable);
                }
                bytes.position = 0;
                this.writeBytes(bytes);
            }
	}
}
