//Created by Action Script Viewer - http://www.buraks.com/asv
package proxy {
    import flash.net.*;
    import flash.errors.*;

    public class NetBaseSocket extends Socket {

        public function NetBaseSocket(_arg1:String=null, _arg2:int=0){
            super(_arg1, _arg2);
        }
        public function sendMessage(_arg1:String):Boolean{
            var str:* = _arg1;
            try {
                writeUTFBytes(str);
            } catch(e:IOError) {
                return (false);
            };
            flush();
            return (true);
        }
        public function getMessage(_arg1:int):String{
            var str:* = null;
            var len:* = _arg1;
            try {
                str = readUTFBytes(len);
            } catch(e:Error) {
                return ("");
            };
            return (str);
        }

    }
}//package program.model.net 
