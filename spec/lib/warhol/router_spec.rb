describe Warhol::Router do
  let(:user) { double }
  let(:config) { double }

  subject { described_class.new(user) }

  before do
    allow(Warhol::Config).to receive(:instance).and_return(config)
  end

  context 'role lifecycle' do
    let!(:role_a) { class Foo < Warhol::Ability; end; Foo }
    let!(:role_b) { class Bar < Warhol::Ability; end; Bar }

    let(:permission_proc) { proc { } }

    before do
      allow(config).to receive(:ability_classes).and_return({
        'foo' => Foo,
        'bar' => Bar
      })

      allow(config).to receive(:role_proc).and_return(nil)
      allow(config).to receive(:role_accessor).and_return(:roles)

      allow(user).to receive(:roles).and_return(%w(foo))
      allow(role_a).to receive(:permissions).and_return(permission_proc)
      allow(role_b).to receive(:permissions).and_return(permission_proc)
    end

    it 'should apply the correct roles' do
      subject
      expect(role_a).to have_received(:permissions)
      expect(role_b).to_not have_received(:permissions)
    end
  end

  context 'instance methods' do
    before do
      allow_any_instance_of(described_class).to receive(:apply_permissions)
        .and_return(true)

      allow_any_instance_of(described_class).to receive(:decorate_accessors)
        .and_return(true)
    end

    context '#initialize' do
      it 'performs the correct lifecycle events' do
        expect(subject).to have_received(:apply_permissions)
        expect(subject.object).to eql(user)
      end

      context 'with additional accessors defined' do
        let(:addl_accessors) { %w(foo bar baz) }

        before do 
          allow(config).to receive(:additional_accessors).and_return(
            addl_accessors
          )

          allow_any_instance_of(described_class).to receive(:decorate_accessors)
            .and_call_original
        end

        it 'should respond to the new accessors' do
          addl_accessors.each do |aa|
            expect(subject).to receive(aa.to_sym).and_call_original
            expect(subject.send(aa)).to eql(user)
          end
        end
      end 
    end

    context '#roles_to_apply' do
      before do
        allow(config).to receive(:role_accessor).and_return(role_accessor)
        allow(config).to receive(:role_proc).and_return(role_proc)
      end

      let(:role_accessor) { :foo }

      context 'using a method signature' do
        let(:role_proc) { nil }

        it 'should invoke the accessor on user' do
          expect(user).to receive(role_accessor).and_return(true)
          subject.roles_to_apply
        end
      end

      context 'using a proc' do
        let(:role_proc) { double }

        it 'should invoke the roles proc with user' do
          expect(role_proc).to receive(:call).with(user)
          subject.roles_to_apply
        end
      end
    end
  end
end