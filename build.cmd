echo ''
echo '====| Starting Build |==='

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