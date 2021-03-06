describe "Professor" do
  it "concludes with test me" do
    plot = Plot.new
    plot.load "examples/professor/main.rb"
    plot.load "test.rb"
    character = plot.make Character, :name => 'player'
    plot.introduce character
    character.perform "test me"
    expect(character.state.class).to eq(CharacterState::Concluded)
  end
end
