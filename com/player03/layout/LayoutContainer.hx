package com.player03.layout;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import com.player03.layout.area.Area;
import openfl.display.DisplayObject;

#if !macro
@:build(com.player03.layout.LayoutContainerBuilder.build())
@:autoBuild(com.player03.layout.LayoutContainerBuilder.build())
#end
class LayoutContainer extends Sprite {
	public var layout(default, null):Layout;
	public var parentLayout(default, set):Layout;
	
	private var pendingWidth:Float;
	private var pendingHeight:Float;
	
	private var layoutCreated:Bool = false;
	
	public function new(?initialWidth:Float = 0, ?initialHeight:Float = 0,
			?parentLayout:Layout, ?createImmediately:Bool = false, ?customScale:Scale) {
		super();
		
		pendingWidth = initialWidth;
		pendingHeight = initialHeight;
		this.parentLayout = parentLayout;
		
		var scale:Scale;
		if(customScale != null) {
			scale = customScale;
		} else if(parentLayout != null) {
			scale = parentLayout.scale;
		} else {
			scale = Layout.currentLayout.scale;
		}
		
		layout = new Layout(scale, new Area(0, 0, initialWidth, initialHeight));
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.ADDED_TO_STAGE, onFirstAddedToStage, false, 1);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		
		if(stage != null) {
			dispatchEvent(new Event(Event.ADDED_TO_STAGE));
		} else if(createImmediately) {
			createLayoutNow();
		}
	}
	
	/**
	 * Changes this LayoutContainer's width and height so that the given
	 * children fit inside the layout's bounds, with the given amount of padding
	 * in each direction. However, since only the width and height are adjusted,
	 * this doesn't account for children with negative x or y coordinates.
	 */
	public function resizeToContents(?rightObject:Resizable, ?bottomObject:Resizable, ?xPadding:Float = 0, ?yPadding:Float):Void {
		if(yPadding == null) {
			yPadding = xPadding;
		}
		
		if(rightObject != null) {
			layout.addCallback(setWidthToContain.bind(rightObject, xPadding), true);
		}
		if(bottomObject != null) {
			layout.addCallback(setHeightToContain.bind(bottomObject, yPadding), true);
		}
	}
	
	private function setWidthToContain(child:Resizable, xPadding:Float):Void {
		layout.bounds.setTo(0, 0, child.right + xPadding * layout.scale.x, height, true);
	}
	
	private function setHeightToContain(child:Resizable, yPadding:Float):Void {
		layout.bounds.setTo(0, 0, width, child.bottom + yPadding * layout.scale.y, true);
	}
	
	/**
	 * During this method, this LayoutContainer's Layout object will be used by
	 * default. Override this method to set up your layout.
	 * 
	 * Do not call this yourself! If you have to run it early, call
	 * createLayoutNow().
	 */
	private function createLayout():Void {
	}
	
	/**
	 * Sets up this LayoutContainer's layout, without waiting for the container
	 * to be added to the stage.
	 */
	public inline function createLayoutNow():Void {
		if(!layoutCreated) {
			onFirstAddedToStage(null);
		}
	}
	
	@:noCompletion @:final private function onFirstAddedToStage(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, onFirstAddedToStage);
		layoutCreated = true;
		
		//Temporarily set Layout.currentLayout.
		var oldLayout:Layout = Layout.currentLayout;
		Layout.currentLayout = layout;
		
		createLayout2();
		
		Layout.currentLayout = oldLayout;
	}
	
	@:noCompletion private function onAddedToStage(e:Event):Void {
		if(parentLayout != null) {
			parentLayout.addCallback(layout.apply, false);
		}
		
		if(pendingWidth != layout.bounds.width || pendingHeight != layout.bounds.height) {
			layout.bounds.setTo(layout.bounds.x, layout.bounds.y,
								pendingWidth, pendingHeight);
		}
	}
	
	@:noCompletion private function onRemovedFromStage(e:Event):Void {
		if(parentLayout != null) {
			parentLayout.removeCallback(layout.apply);
		}
		
		pendingWidth = layout.bounds.width;
		pendingHeight = layout.bounds.height;
	}
	
	private function set_parentLayout(value:Layout):Layout {
		if(parentLayout != null && stage != null) {
			parentLayout.removeCallback(layout.apply);
		}
		if(value != null && stage != null) {
			value.addCallback(layout.apply, false);
		}
		
		return parentLayout = value;
	}
	
	#if flash @:keep @:getter(width) #else override #end
	public function get_width():Float {
		if(stage != null) {
			return layout.bounds.width;
		} else {
			return pendingWidth;
		}
	}
	#if flash @:keep @:getter(height) #else override #end
	public function get_height():Float {
		if(stage != null) {
			return layout.bounds.height;
		} else {
			return pendingHeight;
		}
	}
	#if flash @:keep @:setter(width) #else override #end
	public function set_width(value:Float) {
		if(stage != null) {
			layout.bounds.width = value;
		} else {
			pendingWidth = value;
		}
		
		//In Flash, setters need to return Void.
		#if !flash
			return value;
		#end
	}
	#if flash @:keep @:setter(height) #else override #end
	public function set_height(value:Float) {
		if(stage != null) {
			layout.bounds.height = value;
		} else {
			pendingHeight = value;
		}
		
		#if !flash
			return value;
		#end
	}
}
