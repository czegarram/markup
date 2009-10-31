$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'github/markup'
require 'test/unit'
require 'helper'

class MarkupTest < Test::Unit::TestCase
  extend MarkupTestDSL

  def test_graceful_fail
    content = "* One\n* Two"
    text = GitHub::Markup.render('README.imadeitup', content)
    assert_equal content, text
  end

  test 'README.markdown', <<-input, <<-output
* One
* Two
input
<ul>
<li>One</li>
<li>Two</li>
</ul>\n
output

  test 'README.textile', <<-input, <<-output.strip
* One
* Two
input
<ul>
\t<li>One</li>
\t<li>Two</li>
</ul>\n
output

  test 'README.txt', <<-input, <<-output
* One
* Two
input
* One
* Two
output

  test 'README.rdoc', <<-input, <<-output
* One
* Two
input
<ul>
<li>One\n\n</li>
<li>Two\n\n</li>
</ul>
output

  test 'README.asciidoc', <<-input, <<-output
* One
* Two
input
<div class="ulist"><ul>\r
<li>\r
<p>\r
One\r
</p>\r
</li>\r
<li>\r
<p>\r
Two\r
</p>\r
</li>\r
</ul></div>\r\n
output

  test 'README.rst', <<-input, <<-output
1. Blah blah ``code`` blah

2. More ``code``, hooray
input
<div class="document">
<ol class="arabic simple">
<li>Blah blah <tt class="docutils literal">code</tt> blah</li>
<li>More <tt class="docutils literal">code</tt>, hooray</li>
</ol>
</div>\n
output


  test 'README.pod', <<-input, <<-output
=head1 NAME

podsample - A sample pod document

=item * This is a bulleted list.

=item * Here's another item.
input
<div name="index">
<p><a name="__index__"></a></p>

<ul>

\t<li><a href="#name">NAME</a></li>
</ul>

<hr name="index" />
</div>
output

end
