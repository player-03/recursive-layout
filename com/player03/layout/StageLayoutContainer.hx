package com.player03.layout;

import flash.events.Event;
import flash.Lib;
import com.player03.layout.area.Area;

using com.player03.layout.LayoutCreator;

/**
 * A layout container that matches the size of the stage, and listens to the
 * stage's resize events. Use this for top-level layouts.
 */
class StageLayoutContainer extends LayoutContainer {
	public function new(?createImmediately:Bool = false) {
		super(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, createImmediately);
	}
	
	@:noCompletion private override function onAddedToStage(e:Event):Void {
		Layout.stageLayout.bounds.addEventListener(Event.CHANGE, onStageResize);
		onStageResize(null);
	}
	
	@:noCompletion private override function onRemovedFromStage(e:Event):Void {
		Layout.stageLayout.bounds.removeEventListener(Event.CHANGE, onStageResize);
	}
	
	private function onStageResize(e:Event):Void {
		if(layout.bounds.width != Layout.stageLayout.bounds.width
				|| layout.bounds.height != Layout.stageLayout.bounds.height) {
			layout.bounds.setTo(0, 0, Layout.stageLayout.bounds.width, Layout.stageLayout.bounds.height);
		}
	}
	
	#if flash @:keep @:setter(width) #end
	public override function set_width(value:Float) {
		#if !flash
			return layout.bounds.width;
		#end
	}
	#if flash @:keep @:setter(height) #end
	public override function set_height(value:Float) {
		#if !flash
			return layout.bounds.height;
		#end
	}
}
