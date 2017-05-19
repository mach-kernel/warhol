describe Warhol::Support::Inflector do
  let(:klass) { Class.new { include Warhol::Support::Inflector } }
  subject { klass.new }

  context '#demodulize' do
    it 'produces the correct string' do
      expect(subject.demodulize('foo')).to eql('foo')
      expect(subject.demodulize('Foo::Bar::Baz')).to eql('Baz')
    end
  end

  context '#underscore' do
    it 'produces the correct string' do
      expect(subject.underscore('Foo::Bar')).to eql('foo/bar')
      expect(subject.underscore('FooBar::Baz')).to eql('foo_bar/baz')
      expect(subject.underscore('Foobar::Baz')).to eql('foobar/baz')
    end
  end
end