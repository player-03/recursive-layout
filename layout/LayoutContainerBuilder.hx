package layout;

import haxe.macro.Context;
import haxe.macro.Expr;

@:noCompletion class LayoutContainerBuilder {
	public macro function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		
		for(field in fields) {
			if(field.name == "createLayout") {
				field.name = "createLayout2";
				break;
			}
		}
		
		return fields;
	}
}
