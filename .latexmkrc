$pdf_mode = 1;
$pdflatex = 'pdflatex -synctex=1 -file-line-error -interaction=nonstopmode -halt-on-error %O %S';
$bibtex_use = 2;
@generated_exts = (@generated_exts, 'bbl', 'run.xml', 'synctex.gz');
