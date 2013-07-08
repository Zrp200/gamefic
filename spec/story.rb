require_relative "../lib/gamefic"
include Gamefic

describe Story do
	it "finds a character's subplots" do
		story = Story.new
		character = story.make Character
		subplot = Subplot.new story
		story.subplots_featuring(character).length.should eq(0)
		subplot.introduce character
		story.subplots_featuring(character).length.should eq(1)
		story.subplots_featuring(character).include?(subplot).should eq(true)
	end
end

describe Subplot do
	it "includes entities for featured characters" do
		story = Story.new
		character = story.make Character
		story_entity = story.make Entity
		subplot = Subplot.new story
		subplot_entity = subplot.make Entity
		subplot.introduce character
		character.plot.entities.length.should eq(3)
		character.plot.entities.include?(story_entity).should eq(true)
		character.plot.entities.include?(subplot_entity).should eq(true)		
	end
	it "updates entities for featured characters" do
		story = Story.new
		character = story.make Character
		story_entity = story.make Entity
		subplot = Subplot.new story
		subplot_entity = subplot.make Entity
		subplot.introduce character
		character.plot.entities.length.should eq(3)
		story.make Item
		character.plot.entities.length.should eq(4)
		subplot.conclude character
		character.plot.entities.length.should eq(3)
	end
	it "hides subplot entities from external characters" do
		story = Story.new
		character = story.make Character
		subplot = Subplot.new story
		entity = subplot.make Entity
		character.plot.entities.length.should eq(1)
		character.plot.entities.include?(entity).should eq(false)
	end
	it "makes actions available to featured characters" do
		story_counter = 0
		subplot_counter = 0
		story = Story.new
		story.respond :increment do |actor|
			story_counter = story_counter + 1
		end
		subplot = Subplot.new story
		subplot.respond :increment do |actor|
			subplot_counter = subplot_counter + 1
		end
		character = story.make Character
		character.perform "increment"
		story_counter.should eq(1)
		subplot.introduce character
		character.perform "increment"
		subplot_counter.should eq(1)
		subplot.conclude character
    subplot.features?(character).should eq(false)
    StoryWithSubplots.cached_for?(story, character).should eq(false)
		character.perform "increment"
		story_counter.should eq(2)
		subplot_counter.should eq(1)
	end
  it "causes characters to use StoryWithSubplots" do
    story = Story.new
    subplot = Subplot.new story
    character = story.make Character
    subplot.introduce character
    character.plot.kind_of?(StoryWithSubplots).should eq(true)
  end
end

describe StoryWithSubplots do
  it "deletes an entity's story cache when a related plot gets a new entity" do
    story = Story.new
    subplot = Subplot.new story
    character = story.make Character
    subplot.introduce character
    sws = character.plot
    story.make Item
    StoryWithSubplots.cached_for?(story, character).should eq(false)
  end
  it "deletes an entity's story cache when a related plot gets a new action" do
    story = Story.new
    subplot = Subplot.new story
    character = story.make Character
    subplot.introduce character
    sws = character.plot
    story.respond :do do |actor|
      actor.tell "no op"
    end
    StoryWithSubplots.cached_for?(story, character).should eq(false)  
  end
end
