class Portal < Entity
  attr_accessor :destination, :direction
  def find_reverse
    rev = direction.reverse
    if rev != nil
      destination.children.that_are(Portal).each { |c|
        if c.direction == rev
          return c
        end
      }
    end
    nil
  end
  # Portals have distinct direction and name properties so games can display a
  # bare compass direction for exits, e.g., "south" vs. "the southern door."
  def direction
    @direction ||= Direction.new(:name => @name)
  end
  def name
    @name || direction.name
  end
  def synonyms
    "#{super} #{@direction} #{direction.synonyms}"
  end
end
