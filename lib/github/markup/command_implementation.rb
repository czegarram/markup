require "posix-spawn"
require "github/markup/implementation"

module GitHub
  module Markup
    class CommandImplementation < Implementation
      attr_reader :command, :block

      def initialize(regexp, command, &block)
        super regexp
        @command = command.to_s
        @block = block
      end

      def render(content)
        rendered = execute(command, content)
        rendered = rendered.to_s.empty? ? content : rendered
        call_block(rendered, content)
      end

    private
      def call_block(rendered, content)
        if block && block.arity == 2
          block.call(rendered, content)
        elsif block
          block.call(rendered)
        else
          rendered
        end
      end

      def execute(command, target)
        spawn = POSIX::Spawn::Child.new(*command, :input => target)
        spawn.out.gsub("\r", '')
      rescue Errno::EPIPE
        ""
      rescue Errno::ENOENT
        ""
      end
    end
  end
end
