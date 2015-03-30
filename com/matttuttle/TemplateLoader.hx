package com.matttuttle;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.ds.StringMap;

class TemplateLoader
{

	public static var templateDir:String = "templates";

	public static function __add(name:String, contents:String):Void
	{
		var template:Template;
		try
		{
			template = new Template(contents);
		}
		catch (e:Dynamic)
		{
			// TODO: come up with a better default template
			template = new Template("");
			trace(name, e);
		}
		_templates.set(name, template);
	}

	public static function __render(name:String, context:Dynamic):String
	{
		return _templates.get(name).render(context);
	}

	macro public static function render(name:String, ?v:Expr):Expr
	{
		try
		{
			var p = Context.resolvePath(templateDir + "/" + name);
			if (!sys.FileSystem.exists(p)) throw "does not exist";

			return macro TemplateLoader.__render($v{name}, ${v});
		}
		catch(e:Dynamic)
		{
			return Context.error('Template does not exist: $name', Context.currentPos());
		}
	}

	macro public static function load():Expr
	{
		try
		{
			var p = Context.resolvePath(templateDir);
			Context.registerModuleDependency(Context.getLocalModule(), p);
			var a = new Array<Expr>();
			readTemplateDir(p, a);

			return { expr: EBlock(a), pos: Context.currentPos() };
		}
		catch(e:Dynamic)
		{
			return Context.error('Failed to load templates directory: $e', Context.currentPos());
		}
	}

	#if macro
	private static function readTemplateDir(p, a, name="")
	{
		for (file in sys.FileSystem.readDirectory(p))
		{
			var n = name + "/" + file;
			var path = p + "/" + file;
			if (sys.FileSystem.isDirectory(path))
			{
				readTemplateDir(path, a, n);
			}
			else
			{
				var content = sys.io.File.getContent(path);
				content = ~/[\r\n\t]+/g.replace(content, " ");
				a.push(macro TemplateLoader.__add($v{n.substr(1)}, $v{content}));
			}
		}
	}
	#end

	private static var _templates = new StringMap<Template>();

}
