class Runner
{
	public static function main()
	{
		var r = new haxe.unit.TestRunner();
		r.add(new TemplateTest());
		r.add(new FilterTest());
		r.run();
	}
}