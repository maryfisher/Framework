package maryfisher.framework.core {
	
	import flash.utils.describeType;
	
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author mary_fisher
	 */
	public class AbstractProxy {
		
		protected var _updateSignal:Signal;
		private var _models:Vector.<String>;
		
		public function AbstractProxy() {
			_updateSignal = new Signal(String);
			//_updateSignal = new Signal(ModelUpdate);
			ModelController.registerProxy(this);
			
			_models = new Vector.<String>();
			var typeXML:XML = describeType(this);
			var accessors:XMLList = typeXML.accessor;//.(@name.indexOf('Model') > -1);
			for each(var accessor:XML in accessors) {
				var modelname:String = accessor.name;
				if (modelname.indexOf('Model') > -1 ) {
					_models.push('_' + modelname);
				}
			}
		}
		
		public function get updateSignal():Signal { return _updateSignal; }
		
		public function dataFinishedLoading():void { 
			var dataLoaded:Boolean = true;
			
			for each(var modelname:String in _models) {
				if ((this['_' + modelname] as AbstractGlobalModel).status == AbstractGlobalModel.DATA_WAITING) {
					dataLoaded = false;
				}
			}
			
			if (dataLoaded) {
				_updateSignal.dispatch(AbstractGlobalModel.DATA_LOADED);
			}
		}
		
		//public function registerForUpdate(updater:IProxyUpdate, param:Vector.<String> = null):void {
		public function registerForUpdate(callback:Function):void {
			for each(var modelname:String in _models) {
				(this['_' + modelname] as AbstractGlobalModel).registerForUpdate(this);
			}
			_updateSignal.add(callback);
			dataFinishedLoading();
		}
		
		//public function registerForEvent(event:String, callback:Funktion):void {
			//var model:AbstractModel = _events[event];
			//model['registerFor' + event](callback);
		//}
		
		public function updateFromModel(cmd:String):void {
			if (cmd == AbstractGlobalModel.DATA_LOADED) {
				dataFinishedLoading();
			}else {
				/** TODO
				 * statt cmd:String könnte man cmd:ModelUpdate machen
				 * ModelUpdate hat einen cmdType:String und dann alle, die davon ableiten noch zusätzliche Objekte
				 */
				_updateSignal.dispatch(cmd);
			}
		}
		
		public function destroy():void {
			_updateSignal.removeAll();
			for each(var modelname:String in _models) {
				(this['_' + modelname] as AbstractGlobalModel).unregisterForUpdate(this);
			}
		}
	}
}