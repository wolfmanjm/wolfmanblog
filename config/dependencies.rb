# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.11"
dm_gems_version   = "0.9.11"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version
dependency "merb-cache", merb_gems_version
dependency "merb-helpers", merb_gems_version
dependency "merb-mailer", merb_gems_version
dependency "merb-slices", merb_gems_version
dependency "merb-auth-core", merb_gems_version
dependency "merb-auth-more", merb_gems_version
dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version
dependency "merb-more", merb_gems_version
dependency "merb-parts"
dependency 'merb_sequel'
#
dependency "BlueCloth", :require_as => "bluecloth"
#dependency "merb-pagination"
dependency "will_paginate", "3.0.0"
dependency "syntax"
#dependency 'sequel_timestamped'
dependency 'uuidtools'
