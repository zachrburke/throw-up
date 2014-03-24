# A sample Guardfile
# More info at https://github.com/guard/guard#readme

filter /bin/

guard 'livereload' do
	watch(%r{bin/views/.+})
	watch(%r{bin/content/.+\.(css|js|html|md)})
	watch(%r{bin/web.lua})
	watch(%r{bin/models/.+})
end

watch(%r{.+}) { `bash build.cmd` }
