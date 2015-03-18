import haxe.macro.Expr;
import haxe.macro.Context;

class TemplateLoader
{

	public static inline var templateDir = "templates";

	macro public static function render(name:String, ?v:Expr):Expr
	{
		try
		{
			var p = Context.resolvePath(name);
			if (!sys.FileSystem.exists(p)) throw "does not exist";

			return macro templates.get($v{name}).render(${v});
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

			return { expr: EArrayDecl(a), pos: Context.currentPos() };
		}
		catch(e:Dynamic)
		{
			return Context.error('Failed to load templates directory: $e', Context.currentPos());
		}
	}

	#if macro
	private static function readTemplateDir(p, a)
	{
		for (file in sys.FileSystem.readDirectory(p))
		{
			var path = p + "/" + file;
			if (sys.FileSystem.isDirectory(path))
			{
				readTemplateDir(path, a);
			}
			else
			{
				var content = sys.io.File.getContent(path);
				var name = path.substr(path.indexOf(templateDir));
				a.push(macro templates.set($v{name}, new Template($v{content})));
			}
		}
	}
	#end

}
