module Gamefic

	class Character < Entity
		attr_reader :scene, :queue, :user, :last_command
    attr_accessor :object_of_pronoun
		def initialize(plot, args = {})
			@queue = Array.new
      super
      # TODO: Don't handle the state in the Character class. Try letting the Plot define a default initial scene.
      #self.state = :active
		end
		def connect(user)
			@user = user
		end
		def disconnect
			# TODO: We might need some cleanup here. Like, move the character out of the game, or set a timeout to allow dropped users to reconnect... figure it out.
			@user = nil
		end
		def perform(*command)
      @last_command = command
			Director.dispatch(self, *command)
		end
		def tell(message)
			if user != nil and message.to_s != ''
        message = "<p>#{message}</p>"
        # This method uses String#gsub instead of String#gsub! for
        # compatibility with Opal.
        message = message.gsub(/\n\n/, '</p><p>')
        message = message.gsub(/\n/, '<br/>')
				user.stream.send message
      end
		end
    def stream(message)
      if user != nil and message.to_s != ''
        user.stream.send message
      end
    end
		def destroy
			if @user != nil
				@user.quit
			end
			super
		end
    def cue key
      if key.nil?
        key = plot.default_scene
      end
      manager = plot.scene_managers[key]
      if manager.nil?
        @scene = nil
      else
        @scene = manager.prepare key
        @scene.start self
      end
      @scene
    end
    # This is functionally identical to Character#cue, but it also raises an
    # exception if the selected scene is not a Concluded state.
    def conclude key
      key = :concluded if key.nil?
      manager = plot.scene_managers[key]
      if manager.state != "Concluded"
        raise "Selected scene '#{key}' is not a conclusion"
      end
      cue key
    end
		def update
			super
      if (line = queue.shift)
        @scene.finish self, line
      end
		end
	end

end
