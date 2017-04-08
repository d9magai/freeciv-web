## base settings
default['freeciv']['path'] = '/vagrant/freeciv'

## repository
default['freeciv']['site_url'] = 'https://github.com/d9magai/freeciv/archive'
default['freeciv']['arch_file'] = 'apply_patches.tar.gz'

## for tempolary working
#default['freeciv']['working_dir'] = ::File.join(Chef::Config[:file_cache_path], 'freeciv')
default['freeciv']['working_dir'] = '/vagrant/freeciv'
default['freeciv']['configure_flags'] = 'CFLAGS="-O3" --with-project-definition=../freeciv-web.project --enable-fcweb --enable-json --disable-delta-protocol --disable-nls --disable-fcmp --enable-freeciv-manual=html --disable-ruledit --enable-ai-static=classic,threaded --prefix=${HOME}/freeciv/'

