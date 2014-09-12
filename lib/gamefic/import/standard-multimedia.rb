class Entity
  attr_accessor :image
  def has_image?
    (@image.to_s != '')
  end
end

class Character
  attr_accessor :sees_image
  def show_image(filename)
    stream "<img src=\"#{filename}\" />";
    @sees_image = true
  end
  def play_sound(filename, loop = false)
    # TODO: Implement
  end
  def play_ambient(filename, loop = false)
    # TODO: Implement
  end
end

assert_action :clear_last_image do |actor, action|
  actor.sees_image = false
  true
end

respond :look, Query::Visible.new() do |actor, subject|
  passthru
  if subject.has_image?
    actor.show_image subject.image
  end
end

finish_action :check_for_image do |actor|
  if actor.sees_image == false and actor.room.has_image?
    actor.show_image actor.room.image
  end
end
