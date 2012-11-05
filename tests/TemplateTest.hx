class TemplateTest extends haxe.unit.TestCase
{

	public function testVariable()
	{
		var t = new Template("Hello {{ world }}!{# This is a comment #}");
		assertEquals('Hello Example!', t.render({ world : 'Example' }));
	}

	public function testDotNotation()
	{
		var t = new Template("{{foo.bar}}");
		assertEquals('true', t.render({ foo : { bar : true } }));
	}

	public function testExtends()
	{
		var t = new Template("{% extends include/extends.html %}{% block main %}Hello{% end %}");
		assertEquals('Hello World!', t.render());
	}

	public function testForLoop()
	{
		var t = new Template("{% for item in items %}{{ item.yep }}{% end %}");
		assertEquals('nullyep', t.render({
			items: [
				{nope: 'hello'},
				{yep: 'yep'}
			]
		}));
		assertEquals('', t.render({ items: [] }));
	}

	public function testForEmpty()
	{
		var t = new Template("{% for item in items %}{{ item }}{% empty %}There are no items{% end %}");
		assertEquals('12', t.render({ items: [1,2] }));
		assertEquals('There are no items', t.render({ items: [] }));
	}

	public function testNullVariable()
	{
		var t = new Template("{{ non existant }}");
		assertEquals('null', t.render());
	}

	public function testBlockOverwrite()
	{
		var t = new Template("{% block foo %}This will be overridden{% end %} World!{% block foo %}Hi{% end %}");
		assertEquals('Hi World!', t.render());
	}

	public function testExpression()
	{
		var t = new Template("{% if ((1 + 1) == two) %}true{% end %}");
		assertEquals('true', t.render({ two : 2 }));
	}

}