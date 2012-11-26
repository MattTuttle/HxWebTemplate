class FilterTest extends haxe.unit.TestCase
{

	public function testFilterBlock()
	{
		var t = new Template('{% filter addslashes %}{{ foo|cut:" " }}{% end %}');
		assertEquals('\\"foobar\\"', t.render({ foo: '"foo bar"' }));
	}

	public function testPlainTextFilter()
	{
		var t = new Template('{% filter capfirst %}hi there{% end %}');
		assertEquals('Hi there', t.render());
	}

	public function testMultipleFilters()
	{
		var t = new Template('{{ foo|add:"world!"|capfirst }}');
		assertEquals('Hello world!', t.render({ foo: 'hello ' }));
	}

	public function testAdd()
	{
		var t = new Template('{{ foo|add:"2" }}');
		assertEquals('[1,2]', t.render({ foo: [1] }));
		assertEquals('12', t.render({ foo: '1' }));
		assertEquals('3.5', t.render({ foo: 1.5 }));
	}

	public function testAddSlashes()
	{
		var t = new Template("{{ foo|addslashes }}");
		assertEquals('\\"bar\\"', t.render({ foo: '"bar"' }));
	}

	public function testCapFirst()
	{
		var t = new Template("{{ foo|capfirst }}");
		assertEquals('Bar', t.render({ foo: 'bar' }));
	}

	public function testCut()
	{
		var t = new Template('{{ foo|cut:" " }}');
		assertEquals('bar', t.render({ foo: 'b a r' }));
	}

	public function testFirst()
	{
		var t = new Template('{{ foo|first }}');
		assertEquals('5', t.render({ foo:[5,2,7,3] }));
	}

	public function testJoin()
	{
		var t = new Template('{{ foo|join:" // " }}');
		assertEquals('5 // 2 // 7 // 3', t.render({ foo:[5,2,7,3] }));
	}

	public function testLast()
	{
		var t = new Template('{{ foo|last }}');
		assertEquals('3', t.render({ foo:[5,2,7,3] }));
	}

	public function testLength()
	{
		var t = new Template('{{ foo|length }}');
		assertEquals('4', t.render({ foo:[5,2,7,3] }));
		assertEquals('5', t.render({ foo:'hello' }));
	}

	public function testUpper()
	{
		var t = new Template('{{ foo|upper }}');
		assertEquals('HELLO', t.render({ foo:'HeLlO' }));
	}

	public function testStripTags()
	{
		var t = new Template('{{ foo|striptags }}');
		assertEquals('Joel is a slug', t.render({ foo:"<b>Joel</b> <button>is</button> a <span>slug</span>" }));
	}

	public function testUrlEncode()
	{
		var t = new Template('{{ foo|urlencode }}');
		assertEquals("http%3A%2F%2Fwww.example.org%2F", t.render({ foo:"http://www.example.org/" }));
	}

	public function testLower()
	{
		var t = new Template('{{ foo|lower }}');
		assertEquals('hello', t.render({ foo:'HeLlO' }));
	}

}