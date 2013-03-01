basefilename=asyObjTest

echo "Running: pdflatex ${basefilename}.tex"
pdflatex ${basefilename}.tex
if [ $? -ne 0 ]; then
  exit 0;
fi

echo "Running: asy ${basefilename}-1.asy"
asy ${basefilename}-1.asy
if [ $? -ne 0 ]; then
  exit 0;
fi

pdflatex ${basefilename}.tex
pdflatex ${basefilename}.tex

echo "Done! Cleaning up..."
# Cleanup some of the millions of asy files?
rm ${basefilename}-1* *.out *.pre

# Cleanup latex stuff?
rm *.log *.aux *.synctex.gz 
