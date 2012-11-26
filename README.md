Template Parser
=======================

This is a template parsing class written in haxe. The intent is to use this in a web framework for parsing html documents although it can be used for plain text as well. The syntax is very similar to Django's template parser.

The parser is very simple to use and could be plugged into any framework. Here is a quick example.

```haxe
class Main
{
	public static function runTemplate(path:String, ?context:Dynamic):String
	{
		var html = sys.io.File.getContent(path); // get template from a file
		var tpl = new Template(html); // parses the template
		return tpl.render(context); // renders the output with any data passed
	}

	public static function main()
	{
		runTemplate('index.html', {title: 'Home Page'});
	}

}
```

```html
<!DOCTYPE html>
<html>
	<head>
		<title>{{ title }}</title>
	</head>
	<body>{% block content %}This is the home page{% end %}</body>
</html>
```

You'll notice that the title information was passed to the template through an object. There is also a block defined as "content". This helps when you want to extend another template. Blocks can be overridden to allow for new content to be placed in them. By doing so you can easily create base templates and extend them for child pages.

Beyond that there are also flow statements and filters that can be applied to your templates. Here is a brief example below to demonstrate what I mean.

```html
{% extends "base.html" %}

{% block content %}
<p>I am overriding the base content block here</p>
<div class="post">
{% filter addslashes %}
	{% for post in posts %}
		<h2>{{ post.title|striptags }}</h2>
		<p>{{ post.body }}</p>
		{% if (post.comments != null) %}
		<span>{{ post.comments }}</span>
		{% end %}
	{% end %}
{% end %}
</div>
{% end %}
```

Here we are replacing the "content" block with a different value. This example shows how we could start to lay out a blog by looping through all of the posts. This would require the posts variable to be set when we call the runTemplate function defined above. You might have seen the filter striptags after post.title. This will strip any html tags from the title field.

There are a bunch of different filters available to use. These can be used for individual variables or for whole blocks. For now check out the addFilter function for a list of filters you can use. Also, you can easily add your own filters (markdown, textile, etc...).

Hopefully this gives you enough to get started. Happy coding!
