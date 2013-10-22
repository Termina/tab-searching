
require('calabash').do 'dev',
  'pkill -f doodle'
  'coffee -o lib/ -mwc coffee/'
  'doodle build/ lib/ delay:0 log:yes'