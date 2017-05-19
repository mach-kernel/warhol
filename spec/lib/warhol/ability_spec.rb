describe Warhol::Ability do
  let(:config) { double }

  before do
    allow(Warhol::Config).to receive(:instance).and_return(config)
    allow(config).to receive(:ability_classes).and_return({})
  end

  subject { class Foo < described_class; end; Foo; }

  context '.define_permissions' do
    it 'caches the block' do
      expect(subject.permissions).to eql(nil)

      expect { |b| reference = b; subject.define_permissions(&b) }
        .to_not yield_control

      expect(subject.permissions).to be_a(Proc)
    end

    context 'with an anonymous class without a name' do
      subject { Class.new(described_class) }

      it 'should raise an error' do
        expect { |b| subject.define_permissions(&b) }.to raise_error
      end
    end
  end
end