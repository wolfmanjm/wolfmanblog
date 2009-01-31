module Merb
  module GlobalHelpers
    # helpers defined here available to all views.
    def sidebar(name)
      part SidebarPart => name
    end
  end
end