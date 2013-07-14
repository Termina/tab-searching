
require('calabash').do 'dev',
  'pkill -f doodle'
  'coffee -o lib/ -mwbc coffee/'
  'jade -o build/ -wP layout/select.jade'
  'jade -o build/ -wP layout/options.jade'
  'stylus -o build/ -w layout/'
  'doodle build/ lib/ delay:0 log:yes'