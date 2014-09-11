echo ''
echo '====| Starting Build |==='

# if [ -d 'bin' ]; then
# 	echo ''
# 	echo 'Cleaning old build'
# 	rm -R bin/*
# fi

echo ''
echo 'Building Moonscript files into lua'
moonc -t bin/ .

echo ''
echo 'Copying nginx.conf'
cp nginx.conf bin/


echo ''
echo 'Copying mime.types'
cp mime.types bin/


echo ''
echo 'Copying content directory'
cp -R content bin/


echo 'Copying etlua files'

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo 'Linux detected, using cp --parents'
	find views/ -name \*.etlua -exec cp --parents {} bin/ \;
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo 'Mac detected, using rsync'
	find views/ -name \*.etlua -exec rsync -R {} bin/ \;
fi

echo ''
echo 'Concatenating css files'
cd bin/content/css; cat typeplate.css styles.css animations.css default.css socialicious.css > all.css
