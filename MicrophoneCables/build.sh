basefilename=asyMicrophoneCables

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
