echo "*** Create self signed certificate"
echo "*** from http://www.debian-administration.org/articles/284"

mkdir newcerts private
echo '8888' > serial 
touch index.txt

echo "*** Creating a Root Certificate"
openssl req -new -x509 -extensions v3_ca -keyout private/cakey.pem -out cacert.pem -days 3650 -config ./openssl.01.cnf 

echo "*** Creating a Certificate Signing Request "
openssl req -new -nodes -out req.pem -config ./openssl.02.cnf

echo "*** Signing a Certificate"
openssl ca -out cert.pem -days 3650 -config ./openssl.03.cnf -infiles req.pem

mv cert.pem tmp.pem

openssl x509 -in tmp.pem -out cert.pem

cat key.pem cert.pem > key-cert.pem

rm index.txt* serial*
echo "done"
