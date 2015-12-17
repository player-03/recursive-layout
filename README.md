# Recursive Layout

One way to structure your code when using [Advanced Layout](https://github.com/player-03/advanced-layout). It helps create nested layouts, and cleans up when you remove the layout from the stage, thereby avoiding memory leaks.

It's a little restrictive and very unintuitive, so I honestly can't recommend it. Not yet, anyway.

Installation
============

	haxelib install recursive-layout

Usage
=====

For top-level layouts, use StageLayoutContainer. Use LayoutUtils, and override the createLayout() function.

	using layout.LayoutUtils;
	
	class MyTopLevelLayout extends StageLayoutContainer {
		public function new() {
			super();
		}
		
		private override function createLayout():Void {
			//Use a bitmap for the background.
			var background:Bitmap = new Bitmap(Assets.getBitmapData("assets/img/Background.png"));
			
			//Stretch it to fill the stage.
			background.fillWidth();
			background.fillHeight();
			
			//You still control when and where it's added as a child.
			addChild(background);
			
			//Add a child layout on top of the background.
			addChild(new MyChildLayout(layout));
		}
	}


Use LayoutContainer to creat a layout within another layout.

    using layout.LayoutUtils;
	
	class MyChildLayout extends LayoutContainer {
		public function new(parentLayout:Layout) {
			super(parentLayout);
		}
		
		private override function createLayout():Void {
			//LayoutContainer comes with a few functions to control its dimensions.
			//This sets it to half the height of its parent layout.
			fillPercentHeight(0.5);
			
			//You can also use LayoutUtils, but remember to refer to parentLayout.bounds.
			//This makes it match the parent layout's width, minus a 10-pixel margin.
			this.matchWidth(parentLayout.bounds, 10);
			
			//Center this within the parent layout.
			this.centerXOn(parentLayout.bounds);
			this.centerYOn(parentLayout.bounds);
			
			//Now that we've defined a specific area of the stage, we can place objects
			//relative to that area.
			
			//Put a button in the top left (which is actually about a quarter of the way
			//down, and ten pixels in from the right).
			var button:MyButton = new MyButton();
			button.alignTopLeft();
			addChild(button);
			
			//Put a text field across the bottom (which is actually about a quarter of
			//the way up).
			var footer:TextField = new TextField();
			footer.fillWidth();
			footer.alignBottom();
			for(i in 0...10) {
				footer.appendText("THE END IS NEVER ");
			}
			addChild(footer);
		}
	}
