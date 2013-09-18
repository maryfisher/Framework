package maryfisher.framework.command.net {
	import maryfisher.framework.command.AbstractCommand;
	import maryfisher.framework.core.NetController;
	import maryfisher.framework.data.NetData;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author mary_fisher
	 */
	public class NetCommand extends AbstractCommand{
		
		private var _id:String;
		private var _requestSpecs:String;
		private var _netRequest:NetRequest;
		private var _netData:NetData;
		private var _requestFinished:Signal;
		private var _resultData:Object;
		private var _requestData:Object;
		
		public function NetCommand(id:String, requestData:Object, callback:INetRequestCallback = null, requestSpecs:String = "", executeInstantly:Boolean = true) {
			super();
			_requestSpecs = requestSpecs;
			_requestData = requestData;
			_id = id;
			_requestFinished = new Signal(NetCommand);
			callback && _requestFinished.addOnce(callback.onRequestReceived);
			executeInstantly && execute();
		}
		
		override public function execute():void {
			NetController.registerCommand(this);
		}
		
		public function buildRequest(netData:NetData):void {
			_netData = netData;
			if (!_netData) {
				trace("[NetCommand] no NetData was specified for id " + _id + ", no request will be send - is this correct?");
				finishRequest(null);
				return;
			}
			
			
			if (!_netData.requestClass) {
				throw new Error("[NetCommand] No request class specified!");
				return;
			}
				
			_netRequest = new _netData.requestClass();
			_netRequest.requestFinished.addOnce(finishRequest);
		}
		
		public function sendRequest():void {
			_netRequest.execute(_requestData, _netData, _requestSpecs);
		}
		
		protected function finishRequest(data:Object):void {
			_resultData = data;
			_requestFinished.dispatch(this);
			_finishedExecutionSignal.dispatch();
		}
		
		public function get requestFinished():Signal { return _requestFinished; }
		public function get id():String { return _id; }
		public function get resultData():Object { return _resultData; }
		public function get netRequest():NetRequest { return _netRequest; }
		public function get netData():NetData {	return _netData; }
	}

}