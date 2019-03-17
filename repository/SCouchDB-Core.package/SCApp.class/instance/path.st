accessing
path
 ^ self at:'_id' ifAbsentPut:[ Array with:'_design' with: self appName  ]