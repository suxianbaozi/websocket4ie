package {

	import flash.display.Stage;
	import flash.display.Sprite;

	
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Timer;
        import flash.net.Socket;
        
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

            public function websocket4ie() {
                Security.allowDomain("*");	// Allow uploading to any domain
                // Keep Flash Player busy so it doesn't show the "flash script is running slowly" error
                var counter:Number = 0;
                root.addEventListener(Event.ENTER_FRAME, function ():void { if (++counter > 100) counter = 0; });
                // Get the movie name
                this.movieName = root.loaderInfo.parameters.movieName;
                this.server = root.loaderInfo.parameters.server;
                this.port = root.loaderInfo.parameters.port;

                try {
                    this.debugEnabled = root.loaderInfo.parameters.debugEnabled == "true" ? true : false;
                } catch (ex:Object) {
                    this.debugEnabled = false;
                }

                this.connectServer();
            }
            public function connectServer():void {
                socket = new Socket();
                socket.addEventListener(Event.CONNECT, onConnect);       
                socket.addEventListener(Event.CLOSE, onClose);
                socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
                socket.connect(this.server, this.port); 
            }

            public function onConnect(e:Event):void {
                
            }
            
            public function onClose(e:Event):void {
                
            }

            public function onIOError(e:IOErrorEvent):void {
                
            }
            public function onSecurityError(e:SecurityErrorEvent):void {
                
            }
            public function onSocketData(e:ProgressEvent):void {
                
            }
            
	}
}
