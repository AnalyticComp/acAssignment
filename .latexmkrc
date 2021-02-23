$pdf_mode = 1;
$pdflatex = "${pdflatex} -synctex=1 -file-line-error -ineraction=nonstopmode -halt-on-error";
$bibtex_use = 2;
@generated_exts = (@generated_exts, "bbl", "run.xml", "synctex.gz");
$clean_full_ext = "${clean_full_ext} %R-solution.tex";
