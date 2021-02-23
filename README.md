# acAssignment

The file `acAssignment.cls` provides the acAssignment document class for
assignments and exams of the Analytic Computing group.
In detail, the following features are provided:

- Setting of page and text style.
- Convenient assignment of point values for each task with automatic summation per task section.
- Automatic detection and numbering of task sections.
- Automatic cover sheet generation, including hyperlinked course and author metadata, and task lists or grading tables for assignments or exams, respectively.
- Control for printing or suppressing reference solutions.
- Instructions on how to author tasks in LaTeX.

Taking a look at the bundled examples documents is highly recommended.

A **usage guide** and **examples output PDFs** can be found under the [GitHub releases](https://github.com/AnalyticComp/acAssignment/releases/latest).

## Automatic Solution Generation

The Python script `latexmk-solutions.py` can be used to automatically generate the assignment `{filename}.pdf` and the reference solution `{filename}-solution.pdf` with one command.

It does so by creating a `{filename}-solution.tex` file for any `{filename}.tex` files in the directory that use this class.
These `{filename}-solution.tex` files should be treated as generated files (i.e., not changed manually) as they would be overwritten the next time the script is run.
They are therefore listed in the `.gitignore`.
For the script to be able to generate PDFs, [latexmk](https://mg.readthedocs.io/latexmk.html) will need to be installed on your system (included in most TeX distributions).

After running the script you can may want to use `latexmk -c` to clean all auxilliary TeX files.
`latexmk -C` additionally deletes all generated PDF  and `{filename}-solution.tex` files.

## License

© 2021 Lukas Schmelzeisen

This work may be distributed and/or modified under the of the [LaTeX Project Public License](https://www.latex-project.org/lppl/), either version 1.3 of this license or (at your option) any later version.
The latest version of this license is in http://www.latex-project.org/lppl.txt and version 1.3 or later is part of all distributions of LaTeX version 2005/12/01 or later.

This work has the LPPL maintenance status “maintained”.

The current maintainer of this work is Lukas Schmelzeisen.

This work consists of the files acAssignment.cls and acAssignment.tex and bundled example files.

The latest version of this class should always be available at https://github.com/analyticcomp/ac-assignment.
