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


echo ''
echo 'Copying templates directory'
cp -R templates bin/

echo ''
echo 'Copying etlua files'
if [[ "$OSTYPE" == "darwin"*]]; then
	find views/ -name \*.etlua -exec rsync -R {} bin/ \;
elif [[ "$OSTYPE" == "linix-gnu" ]]; then
	find views/ -name \*.etlua -exec cp --parents {} bin/ \;
fi