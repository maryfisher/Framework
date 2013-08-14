package data {
	import maryfisher.framework.model.AbstractModel;
	
	/**
	 * ...
	 * @author mary_fisher
	 */
	public class GameModel extends AbstractModel {
		
		private var _gameData:GameData;
		
		public function GameModel() {
			status = DATA_LOADED;
		}
		
		public function get gameData():GameData {
			return _gameData;
		}
		
	}

}