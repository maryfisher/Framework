package maryfisher.framework.command.view {
	/**
	 * ...
	 * @author mary_fisher
	 */
	public class SequenceProgress extends AbstractProgress{
		
		private var _currentStep:int = -1;
		private var _steps:int;
		private var _stepDescriptions:Vector.<String>;
		
		public function SequenceProgress(steps:int, stepDescriptions:Vector.<String> = null) {
			_stepDescriptions = stepDescriptions;
			_steps = steps;
			super();
			next();
		}
		
		public function next():void {
			_currentStep++;
			getProgress();
		}
		
		override protected function getProgress():void {
			
			_progress = Math.min((_currentStep + 0.5) / _steps, 1);
			//trace("SequenceProgress: " + _progress, "_currentStep", _currentStep);
			super.getProgress();
		}
		
		override public function getDescription():String {
			if (_stepDescriptions && _currentStep != -1 && _stepDescriptions.length > _currentStep) {
				return _stepDescriptions[_currentStep];
			}
			trace("Sequence Progress: no description: _currentStep - ", _currentStep);
			return "";
		}
		
		public function addStep(descript:String):void {
			_steps++;
			_stepDescriptions && _stepDescriptions.push(descript);
		}
	}

}