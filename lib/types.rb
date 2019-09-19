# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Types
  include Dry.Types

  Name = Types::String.constrained(filled: true)
end
