package data {
	import maryfisher.framework.data.BaseData;
	
	/**
	 * ...
	 * @author mary_fisher
	 */
	public class GameData extends BaseData {
		
		public var playerName:String;
		
		public function GameData(data:*) {
			super(data);
			
		}
		
		override protected function parseObject(d:Object):void {
			super.parseObject(d);
			
			playerName = d.playerName;
			
		}
	}

}