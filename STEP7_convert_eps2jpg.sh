

EPS=$(ls *.eps);

for e in $EPS ; do

	echo $e
	convert -density 150 ${e} ${e}.jpg
	rm $e

done
