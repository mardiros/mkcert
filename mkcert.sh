!/bin/bash
echo "*** Create self signed certificate"
echo "*** from http://www.debian-administration.org/articles/284"

rm index.txt* serial* tmp.pem req.*
rm -rf private
rm -rf newcerts

mkdir newcerts private
echo '8888' > serial 
touch index.txt

echo "*** Creating a Root Certificate"
openssl req -new -x509 -extensions v3_ca -keyout private/cakey.pem -out cacert.pem -days 3650 -config ./openssl.01.cnf 

cp private/cacert.pem newcerts/ca-chains.pem


read -p "How many certificates ?  " NBCERTS

for (( i=1; i<=$NBCERTS; i++ ))
do
read -p "Certificat name ?  " CERTNAME

echo "*** Creating a Certificate Signing Request "
openssl req -new -nodes -out req.pem -config ./openssl.02.cnf

echo "*** Signing a Certificate"
openssl ca -out cert.pem -days 3650 -config ./openssl.03.cnf -infiles req.pem

mv cert.pem tmp.pem

openssl x509 -in tmp.pem -out cert.pem

cat key.pem cert.pem > newcerts/key-cert-$CERTNAME.pem
cat cert.pem >> newcerts/ca-chains.pem

mv key.pem newcerts/key-$CERTNAME.pem
mv cert.pem newcerts/cert-$CERTNAME.pem

done


echo "Cleaning"
#mv private/cakey.pem newcerts/ca-key-private.pem
#mv cacert.pem newcerts/cacert.pem

#rm index.txt* serial* tmp.pem req.*
#rm -rf private

echo "done"
