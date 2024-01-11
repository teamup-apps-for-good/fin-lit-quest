# frozen_string_literal: true

json.array! @gameplays, partial: 'gameplays/gameplay', as: :gameplay
