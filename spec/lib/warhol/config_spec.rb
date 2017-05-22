describe Warhol::Config do
  context '.new' do
    it 'yields' do
      expect { |b| described_class.new(&b) }.to yield_control.once
    end

    it 'yields with an instance of itself' do
      described_class.new do |foo|
        expect(foo).to be_a(Warhol::Config)
      end
    end
  end

  subject { described_class.new { |_x| } }

  context '#ability_classes' do
    it 'is the correct type' do
      expect(subject.ability_classes).to be_a(Hash)
    end
  end

  context '#ability_parent' do
    it 'has the correct default' do
      expect(subject.ability_parent).to eql(Object)
    end

    context '=' do
      let(:new_value) { String }

      before { subject.ability_parent = new_value }

      it 'is assignable' do
        expect(subject.ability_parent).to eql(new_value)
      end
    end
  end

  context '#additional_accessors' do
    it 'has the correct default' do
      expect(subject.additional_accessors).to be_an(Array)
    end

    context '=' do
      let(:new_value) { %w(foo bar) }

      before { subject.additional_accessors = new_value }

      it 'is assignable' do
        expect(subject.additional_accessors).to eql(new_value)
      end
    end
  end

  context '#role_accessor' do
    it 'has the correct default' do
      expect(subject.role_accessor).to eql(nil)
    end

    context '=' do
      let(:new_value) { :foobs }

      before { subject.role_accessor = new_value }

      it 'is assignable' do
        expect(subject.role_accessor).to eql(new_value)
      end
    end
  end

  context '#role_proc' do
    it 'has the correct default' do
      expect(subject.role_proc).to eql(nil)
    end

    context '=' do
      let(:new_value) { proc { %w(foobar) } }

      before { subject.role_proc = new_value }

      it 'is assignable' do
        expect(subject.role_proc).to eql(new_value)
      end
    end
  end
end