//Created by Action Script Viewer - http://www.buraks.com/asv
package proxy{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
   

    public class ServerProxy extends EventDispatcher {

        private static var S:ServerProxy;

        private var _socket:NetBaseSocket;
        private var _isContent:Boolean = false;
        private var SOCKET_END:String = "~~code~~";

        public static function getIns():ServerProxy{
            return (((S == null)) ? S = new (ServerProxy)() : S);
        }

        public function get isContent():Boolean{
            return (this._isContent);
        }
        public function set isContent(_arg1:Boolean):void{
            this._isContent = _arg1;
        }
        public function initSocket():ServerProxy{
            this._socket = new NetBaseSocket("192.168.1.166",8999);
            this._socket.addEventListener(Event.CLOSE, this.closeHandler);
            this._socket.addEventListener(Event.CONNECT, this.connectHandler);
            this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.socketDataHandler);
            return (this);
        }
        public function closeSocket(){
            if (this._socket.connected == true){
                this._socket.close();
            };
        }
        public function sendMessage(_arg1:String, _arg2:Object){
            var _local3:Object = {
                a:_arg1,
                p:_arg2
            };
            var _local4:String = (JSON.stringify(_local3) + this.SOCKET_END);
            var _local5:Boolean = this._socket.sendMessage(_local4);
        }
        private function closeHandler(_arg1:Event):void{
            var _local2 = "连接已被断开";
            this.isContent = false;
        }
        private function connectHandler(_arg1:Event):void{
            var _local2 = "已经接入服务器";
        }
        private function ioErrorHandler(_arg1:IOErrorEvent):void{
            var _local2 = "Socket发生错误！";
        }
        private function securityErrorHandler(_arg1:SecurityErrorEvent):void{
            var _local2 = "发生安全沙箱错误，请确认swf文件符合安全机制！";
        }
        private function socketDataHandler(_arg1:ProgressEvent){
            var _local5:Object;
            var _local2:String = this._socket.getMessage(_arg1.bytesLoaded);
            var _local3:Array = _local2.split(this.SOCKET_END);
            _local3.pop();
            var _local4:int;
            while (_local4 < _local3.length) {
                _local5 = JSON.parse(_local3[_local4]);
                if (_local5.api){
                   trace(_local5);
                } else {
//                    this.sendNotification(_local5.cmd, _local5);
                };
                _local4++;
            };
        }

    }
}//package program.proxy 
