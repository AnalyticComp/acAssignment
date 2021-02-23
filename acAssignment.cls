%% acAssignment.cls
%% Copyright 2021 Lukas Schmelzeisen
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The current maintainer of this work is Lukas Schmelzeisen.
%
% This work consists of the files acAssignment.cls and acAssignment.tex and
% bundled example files.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{acAssignment}%
    [2021/02/10 Analytic Computing Assignment LaTeX Class]
\LoadClass{article}


% ------------------------------------------------------------------------------
% Packages

\RequirePackage[utf8]{inputenc}

% Fonts (order is important)
\RequirePackage[T1]{fontenc}
\RequirePackage{sansmathfonts}
\RequirePackage[nomath]{lmodern}
\RequirePackage[scaled=0.82]{beramono}
\RequirePackage{microtype}

% Control flow
\RequirePackage{environ}
\RequirePackage{etoolbox}
\RequirePackage{xintfrac,xinttools}
\RequirePackage{xparse}

% Miscellaneous
\RequirePackage{algorithm}
\RequirePackage[noend]{algpseudocode}
\RequirePackage[ngerman, USenglish]{babel}
\RequirePackage{booktabs}
\RequirePackage[bf, format=plain, labelsep=space, skip=0.25cm]{caption}
\RequirePackage[autostyle]{csquotes}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{hyphsubst}
\RequirePackage{lastpage}
\RequirePackage{listings}
\RequirePackage{siunitx}
\RequirePackage{tocloft}
\RequirePackage{url}
\RequirePackage{xcolor}
\RequirePackage[parfill]{parskip} % Load after tocloft.

% Math
\RequirePackage{amssymb}
\RequirePackage{mathtools}

% Hyperref (and packages that need to be loaded after it)
\RequirePackage[naturalnames, colorlinks, allcolors=acBlue, linktoc=all]{hyperref}
\RequirePackage[capitalise, noabbrev, nameinlink]{cleveref}
\RequirePackage[
    a4paper,
    hscale=0.75, % Percentage of total paper width with text.
    vscale=0.75, % Percentage of total paper height with text.
    headheight=18pt, % Size of header.
    headsep=18pt, % Space between header and text body.
]{geometry}

% ------------------------------------------------------------------------------
% Meta data

% Class options
\gdef\@acLanguage{english}
\DeclareOption{german}{\gdef\@acLanguage{german}}
    
\gdef\@acType{assignment}
\DeclareOption{exam}{\gdef\@acType{exam}}

\newtoggle{@acSectionsEven}
\DeclareOption{sectionseven}{\toggletrue{@acSectionsEven}}

\newtoggle{@acSolution}
\DeclareOption{solution}{\toggletrue{@acSolution}}
    
\DeclareOption*{\ClassError{acAssignment}{Unknown option '\CurrentOption'}}
\ProcessOptions\relax

% Shorthands
\newcommand*{\@acIfEnglish}[2]{#2}
\newcommand*{\@acIfGerman}[2]{#2}
\ifdefstring{\@acLanguage}{english}{\renewcommand*{\@acIfEnglish}[2]{#1}}{}
\ifdefstring{\@acLanguage}{german}{\renewcommand*{\@acIfGerman}[2]{#1}}{}

\newcommand*{\@acIfAssignment}[2]{#2}
\newcommand*{\@acIfExam}[2]{#2}
\ifdefstring{\@acType}{assignment}{\renewcommand*{\@acIfAssignment}[2]{#1}}{}
\ifdefstring{\@acType}{exam}{\renewcommand*{\@acIfExam}[2]{#1}}{}

\newcommand*{\acIfSolution}[2]{#2}
\iftoggle{@acSolution}{\renewcommand*{\acIfSolution}[2]{#1}}{}

% General
\newcounter{@acNumAuthors}
\newcommand*{\acAuthor}[3][]{
    \stepcounter{@acNumAuthors}
    \csgdef{@acAuthor\the@acNumAuthors name}{#2}
    \csgdef{@acAuthor\the@acNumAuthors email}{#3}
    \csgdef{@acAuthor\the@acNumAuthors url}{#1}}
\newcommand*{\acCourse}[2][]{\gdef\@acCourse{#2}\gdef\@acCourseUrl{#1}}
\newcommand*{\acSemester}[1]{\gdef\@acSemester{#1}}
\newcommand*{\acHeader}[1]{\gdef\@acHeader{#1}}

% Assignment-specific
\newcommand*{\@acAssertAssignment}{
    \@acIfAssignment{}{\ClassError{acAssignment}{
        This command is not available with the 'exam' class option}}}
\newcommand*{\acAssignmentNumber}[1]{
    \@acAssertAssignment\gdef\@acAssignmentNumber{#1}}
\newcommand*{\acAssignmentTitle}[1]{
    \@acAssertAssignment\gdef\@acAssignmentTitle{#1}}
% \newcommand*{\acAssignmentUntil}[1]{
%     \@acAssertAssignment\gdef\@acAssignmentUntil{#1}}

% Exam-specific
\newcommand*{\@acAssertExam}{
    \@acIfExam{}{\ClassError{acAssignment}{
        This command is only available with the 'exam' class option}}}
\newcommand*{\acExamType}[1]{
    \@acAssertExam\gdef\@acExamType{#1}}
\newcommand*{\acExamDate}[1]{
    \@acAssertExam\gdef\@acExamDate{#1}}
% \newcommand*{\acExamDuration}[1]{
%     \@acAssertExam\gdef\@acExamDuration{#1}}

% Processing
\AtBeginDocument{%
    \xdef\@title{%
        \ifdef{\@acCourse}{\@acCourse}{Undefined Course}%
        \ifdef{\@acSemester}{ (\@acSemester)}{}}%
    %
    \gdef\@author{}%
    \xintFor* #1 in {\xintSeq[1]{1}{\the@acNumAuthors}}\do{%
        \xdef\@author{\@author%
            \xintifForFirst{}{, }%
            \csuse{@acAuthor#1name}}}%
    %
    \xdef\@acSubtitle{%
        \@acIfAssignment{%
            \ifdefvoid{\@acAssignmentNumber}{}{%
                \@acLocAssignment~\@acAssignmentNumber%
                \ifdef{\@acAssignmentTitle}{: }{}}%
            \ifdef{\@acAssignmentTitle}{\@acAssignmentTitle}{}}{}%
        \@acIfExam{%
            \ifdef{\@acExamType}{\@acExamType}{\@acLocExam}%
            \ifdef{\@acExamDate}{ (\@acExamDate)}{}}{}}%
    %
    \xdef\@acShortSubtitle{%
        \@acIfAssignment{%
            \ifdefvoid{\@acAssignmentNumber}{}{%
                \@acLocAssignment~\@acAssignmentNumber}}{}%
        \@acIfExam{%
            \ifdef{\@acExamType}{\@acExamType}{\@acLocExam}}{}}%
    %
    \ifdef{\@acHeader}{}{%
        \gdef\@acHeader{%
            \@title%
            \ifdefvoid{\@acShortSubtitle}{}{%
                \ \textperiodcentered~\@acShortSubtitle}}}%
    %
    \acIfSolution{
        \ifdefvoid{\@acSubtitle}%
            {\gdef\@acSubtitle
                {\textcolor{acSolution}{\@acLocSolution}}}%
            {\xdef\@acSubtitle{\@acSubtitle%
                \ \noexpand\textcolor{acSolution}{(\@acLocSolution)}}}%
        \ifdefvoid{\@acHeader}%
            {\gdef\@acHeader
                {\textcolor{acSolution}{\@acLocSolution}}}%
            {\xdef\@acHeader{\expandonce\@acHeader%
                \ \noexpand\textcolor{acSolution}{(\@acLocSolution)}}}}{}%
    %
    \pdfstringdefDisableCommands{%
        \def\unhbox{}\def\voidb@x{}% The ~ symbol expands to these.
    }%
    \hypersetup{pdftitle={\@acHeader}, pdfauthor={\@author}}}

% ------------------------------------------------------------------------------
% Localization

\addto\extrasUSenglish{\sisetup{locale=US}}
\addto\extrasngerman{\sisetup{locale=DE}}
\HyphSubstIfExists{ngerman-x-latest}{\HyphSubstLet{ngerman}{ngerman-x-latest}}

\@acIfEnglish{\AtBeginDocument{\selectlanguage{USenglish}}}{}
\@acIfGerman{\AtBeginDocument{\selectlanguage{ngerman}}}{}

\@acIfEnglish{\hypersetup{pdflang=en-US}}{}
\@acIfGerman{\hypersetup{pdflang=de-DE}}{}

\newcommand*{\@acLocalize}[3]{
    \@acIfEnglish{\gdef#1{#2}}{}
    \@acIfGerman{\gdef#1{#3}}{}}

\@acLocalize\@acLocUniLogo
    {logo-unistuttgart-english}
    {logo-unistuttgart-german}

\@acLocalize\@acLocUniUrl
    {https://www.uni-stuttgart.de/en/}
    {https://www.uni-stuttgart.de/}
    
\@acLocalize\@acLocAcUrl
    {https://www.ipvs.uni-stuttgart.de/departments/ac/}
    {https://www.ipvs.uni-stuttgart.de/de/abteilungen/ac/}

\@acLocalize\@acLocAssignment
    {Assignment}
    {Aufgabenblatt}

\@acLocalize\@acLocExam
    {Exam}
    {Klausur}

\@acLocalize\@acLocSolution
    {Solution}
    {Lösung}

\@acLocalize\@acLocTask
    {Task}
    {Aufgabe}

\@acLocalize\@acLocTasks
    {Tasks}
    {Aufgaben}

\@acLocalize\@acLocSubtask
    {Subtask}
    {Teilaufgabe}

\@acLocalize\@acLocSubtasks
    {Subtasks}
    {Teilaufgaben}

\@acLocalize\@acLocPoint
    {Point}
    {Punkt}

\@acLocalize\@acLocPoints
    {Points}
    {Punkte}

\@acLocalize\@acLocMaximumPoints
    {Maximum points}
    {Maximale Punkte}

\@acLocalize\@acLocAchievedPoints
    {Achieved points}
    {Erreichte Punkte}

\@acLocalize\@acLocSum
    {Sum}
    {Summe}

\@acLocalize\@acLocGrade
    {Grade}
    {Note}

\@acLocalize\@acLocNote
    {Note}
    {Hinweis}

\@acLocalize\@acLocStudent
    {Student}
    {Student}

\@acLocalize\@acLocResult
    {Result}
    {Ergebnis}

\@acLocalize\@acLocName
    {First and last name}
    {Vor- und Nachname}

\@acLocalize\@acLocImmatriculationNumber
    {Immatriculation number}
    {Matrikelnummer}
    
\@acLocalize\@acLocEmail
    {Email}
    {Email}

\@acLocalize\@acLocCourseOfStudy
    {Course of study (including B.\,Sc./M.\,Sc.)}
    {Studiengang (einschließlich B.\,Sc./M.\,Sc.)}

\@acLocalize\@acLocReviewersSignature
    {Reviewer's signature}
    {Unterschrift Prüfer}

\@acLocalize\@acLocTrue
    {True}
    {Wahr}

\@acLocalize\@acLocFalse
    {False}
    {Falsch}

\@acLocalize\@acLocBlankPages
    {Blank page provided for additional solution space.
    Please cross reference from the original problem page.}
    {Leerblatt für zusätzlichen Antwortplatz.
    Bitte vom jeweiligen Aufgabenblatt referenzieren.}


% ------------------------------------------------------------------------------
% Design

% Colors
\definecolor{acGray}{HTML}{3E444C}
\definecolor{acBlue}{HTML}{00519E}
\definecolor{acLightBlue}{HTML}{00BEFF}
\colorlet{acComment}{acGray!75}
\definecolor{acSolution}{HTML}{E74C3C}
\colorlet{ACSOLUTION}{acSolution} % Workaround to use color with \MakeUppercase.

% Text
\renewcommand*{\familydefault}{\sfdefault}
\urlstyle{same}
\frenchspacing
\renewcommand*\arraystretch{1.3}

% Math
\allowdisplaybreaks

% Sections
\setcounter{secnumdepth}{-1} % Disable numbers on \sections.
\renewcommand*{\thepart}{\arabic{part}}
\gdef\@part[#1]#2{%
    \clearpage%
    \refstepcounter{part}%
    \def\@acPartTitle{\partname~\thepart\ifstrempty{#2}{}{: #2}}
    \addcontentsline{toc}{part}{\@acPartTitle}%
    {\normalfont\LARGE\@acPartTitle\par}%
    % Hack to disable next \clearpage command but not following ones.
    \let\oldclearpage\clearpage%
    \renewcommand*{\clearpage}{\let\clearpage\oldclearpage}}
\renewcommand*{\section}{%
    \clearpage%
    \iftoggle{@acSectionsEven}{%
        \ifnumodd{\value{page}}{\hbox{}\newpage}{}}{}%
    \@startsection{section}{1}{\z@}%
        {-3.5ex \@plus -1ex \@minus -.2ex}%
        {2.3ex \@plus.2ex}%
        {\normalfont\Large}}
\renewcommand*{\subsection}{%
    \@startsection{subsection}{2}{\z@}%
        {-3.25ex\@plus -1ex \@minus -.2ex}%
        {1.5ex \@plus .2ex}%
        {\normalfont\large}}

% Foot notes
\renewcommand*{\headrulewidth}{0pt} % Disable rule under header.
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\raisebox{-5.5pt}{%
    \href{\@acLocAcUrl}{\includegraphics[height=18pt]{assets/logo-ac}}}}
\fancyhead[C]{\footnotesize\MakeUppercase{\@acHeader}}
\fancyfoot[R]{\footnotesize \thepage\,/\,\pageref*{LastPage}}
\fancypagestyle{plain}{
    \fancyhf{}
    \fancyfoot[R]{\footnotesize \thepage\,/\,\pageref*{LastPage}}
}
\fancypagestyle{acBlankPage}{ % Use for \blankpages.
    \fancyhf{}
    \fancyhead[L]{\raisebox{-5.5pt}{%
        \href{\@acLocAcUrl}{\includegraphics[height=18pt]{assets/logo-ac}}}}
    \fancyhead[C]{\footnotesize\MakeUppercase{\@acHeader}}
}

% Utility
\newcommand*{\acUrlFootnote}[2]{\href{#1}{#2}\footnote{\url{#1}}}



% ------------------------------------------------------------------------------
% Solutions

\acIfSolution{
    \NewEnviron{acSolution}{\color{acSolution}\BODY}
    \newcommand*{\acInlineSolution}[1]{\textcolor{acSolution}{#1}}
}{
    \NewEnviron{acSolution}{}
    \newcommand*{\acInlineSolution}[1]{}
}


% ------------------------------------------------------------------------------
% Title Page

\renewcommand*{\maketitle}{%
    \thispagestyle{plain}%
    \begin{minipage}{0.33\textwidth}%
        \href{\@acLocUniUrl}{%
            \includegraphics[height=24pt]{assets/\@acLocUniLogo}}%
        \hfill\rule{\lightrulewidth}{24pt}\hfill\hspace*{0pt}%
    \end{minipage}%
    \begin{minipage}{0.33\textwidth}%
        \href{\@acLocAcUrl}{%
            \includegraphics[height=24pt]{assets/logo-ac-wordmark}}%
    \end{minipage}%
    \vspace{0.4cm}

    {\LARGE\ifdefvoid{\@acCourseUrl}%
        {\@title}%
        {\href{\@acCourseUrl}{\textcolor{black}{\@title}}}%
    \par}%
    \vspace{-\parskip}\vspace{0.4cm}
    
    \ifdefvoid{\@acSubtitle}{}%
        {\vspace{-0.2cm}%
        {\large\@acSubtitle\par}%
        \vspace{0.4cm}}

    \xintFor* ##1 in {\xintSeq[1]{1}{\the@acNumAuthors}}\do{%
        \begin{minipage}{0.33\textwidth}%
            {\large%
            \ifcsvoid{@acAuthor##1url}%
                {\csuse{@acAuthor##1name}}%
                {\href{\csuse{@acAuthor##1url}}%
                    {\textcolor{black}{\csuse{@acAuthor##1name}}}}%
            \par}%
            {\footnotesize\href{mailto:\csuse{@acAuthor##1email}}%
                {\csuse{@acAuthor##1email}}\par}%
            \vspace{0.2cm}%
        \end{minipage}
        \ifnumequal{\value{@acNumAuthors}}{4}{\ifstrequal{##1}{2}{\\}{}}{}%
    }%
    \vspace{0.2cm}}


% ------------------------------------------------------------------------------
% Tasks

\gdef\@acNumSections{0}
\newcounter{@acSection}
\newcounter{@acSectionWithTasks}
\crefname{@acSectionWithTasks}{\@acLocTask}{\@acLocTasks}

\newcounter{@acSubsection}
\renewcommand*{\the@acSubsection}{%
    \the@acSection.\arabic{@acSubsection}}
    
\newcounter{@acSubsectionWithTasks}
\renewcommand*{\the@acSubsectionWithTasks}{%
    \the@acSectionWithTasks.\arabic{@acSubsectionWithTasks}}
\crefname{@acSubsectionWithTasks}{\@acLocTask}{\@acLocTasks}

\crefname{enumi}{\@acLocSubtask}{\@acLocSubtasks}

\let\@oldsection\section
\RenewDocumentCommand{\section}{s o m}{%
    \refstepcounter{@acSection}%
    \setcounter{@acSubsection}{0}%
    \setcounter{@acSubsectionWithTasks}{0}%
    %
    \def\@acSectionPreTitle{}%
    \def\@acSectionPostTitle{}%
    \ifcsstring{@acSection\the@acSection Points}{0}{}{%
        \refstepcounter{@acSectionWithTasks}%
        \edef\@acSectionPreTitle{%
            \@acLocTask~\the@acSectionWithTasks: }%
        \ifcsstring{@acSection\the@acSection Points}{1}%
            {\edef\@acSectionPostTitle{%
                \ (\csuse{@acSection\the@acSection Points}~\@acLocPoint)}}%
            {\edef\@acSectionPostTitle{%
                \ (\csuse{@acSection\the@acSection Points}~\@acLocPoints)}}}%
    %
    \edef\@acSectionTitle{\@acSectionPreTitle#3\@acSectionPostTitle}%
    \edef\@acSectionTocTitle{\IfValueTF{#2}%
        {\@acSectionPreTitle#2\@acSectionPostTitle}%
        {\@acSectionTitle}}%
    \expandafter\@oldsection\expandafter[\@acSectionTocTitle]{\@acSectionTitle}%
    \label{@acSection\the@acSection}%
    %
    \immediate\write\@auxout{%
        \gdef\noexpand\@acNumSections{\the@acSection}}%
    \immediate\write\@auxout{%
        \csgdef{@acSection\the@acSection NumSubsections}{0}}%
    \immediate\write\@auxout{%
        \csgdef{@acSection\the@acSection Points}{0}}%
    \immediate\protected@write\@auxout{}{%
        \csgdef{@acSection\the@acSection Title}{#3}}}

\let\@oldsubsection\subsection
\RenewDocumentCommand{\subsection}{s o m}{%
    \refstepcounter{@acSubsection}%
    %
    \def\@acSubsectionPreTitle{}%
    \def\@acSubsectionPostTitle{}%
    \ifcsstring{@acSection\the@acSubsection Points}{0}{}{%
        \refstepcounter{@acSubsectionWithTasks}%
        \edef\@acSubsectionPreTitle{%
            \@acLocTask~\the@acSubsectionWithTasks: }%
        \ifcsstring{@acSection\the@acSubsection Points}{1}%
            {\edef\@acSubsectionPostTitle{%
                \ (\csuse{@acSection\the@acSubsection Points}~\@acLocPoint)}}%
            {\edef\@acSubsectionPostTitle{%
                \ (\csuse{@acSection\the@acSubsection Points}~\@acLocPoints)}}}%
    %
    \edef\@acSubsectionTitle{\@acSubsectionPreTitle#3\@acSubsectionPostTitle}%
    \edef\@acSubsectionTocTitle{\IfValueTF{#2}%
        {\@acSubsectionPreTitle#2\@acSubsectionPostTitle}%
        {\@acSubsectionTitle}}%
    \expandafter\@oldsubsection\expandafter[\@acSubsectionTocTitle]{%
        \@acSubsectionTitle}
    \label{@acSection\the@acSubsection}%
    %
    \immediate\write\@auxout{%
        \csxdef{@acSection\the@acSection NumSubsections}{\arabic{@acSubsection}}}%
    \immediate\write\@auxout{%
        \csxdef{@acSection\the@acSubsection Points}{0}}}

\NewDocumentCommand{\acTask}{s o m}{%
    \IfBooleanTF{#1}{}{\textbf{\@acLocTask\ (\IfValueTF{#2}%
        {#2}%
        {#3~\ifstrequal{#3}{1}{\@acLocPoint}{\@acLocPoints}})}}%
    \ifnumequal{\value{@acSection}}{0}{}{%
        \immediate\write\@auxout{%
            \csxdef{@acSection\the@acSection Points}%
                {\noexpand\xintAdd{#3}%
                    {\noexpand\csuse{@acSection\the@acSection Points}}}}%
        \ifnumequal{\value{@acSubsection}}{0}{}{%
            \immediate\write\@auxout{%
                \csxdef{@acSection\the@acSubsection Points}%
                    {\noexpand\xintAdd{#3}%
                        {\noexpand\csuse{@acSection\the@acSubsection Points}}}}}}}

\newcommand*{\acNote}{\textbf{\@acLocNote}}

\AtBeginDocument{%
    \newcounter{@acNumTasks}%
    \gdef\@acPointsTotal{0}%
    \xintFor* #1 in {\xintSeq[1]{1}{\@acNumSections}}\do{%
        \csxdef{@acSection#1Points}{%
            \xintDecToString{\xintREZ{\csuse{@acSection#1Points}}}}%
        \ifcsstring{@acSection#1Points}{0}{}{%
            \stepcounter{@acNumTasks}}%
        \xdef\@acPointsTotal{%
            \xintAdd{\@acPointsTotal}{\csuse{@acSection#1Points}}}%
        \xintFor* #2 in {\xintSeq[1]{1}{\csuse{@acSection#1NumSubsections}}}\do{%
            \csxdef{@acSection#1.#2Points}{%
                \xintDecToString{\xintREZ{\csuse{@acSection#1.#2Points}}}}}}%
    \xdef\@acPointsTotal{\xintDecToString{\xintREZ{\@acPointsTotal}}}%
    \newcommand*{\acNumTasks}{\the@acNumTasks}%
    \newcommand*{\acNumPages}{\pageref*{LastPage}}}
    
\newcommand*{\acListOfTasks}{%
    \@acAssertAssignment%
    \newcounter{@acCurTask}%
    \xintFor* ##1 in {\xintSeq{1}{\@acNumSections}}\do{%
        \ifcsstring{@acSection##1Points}{0}{}{%
            \stepcounter{@acCurTask}%
            \ifnumequal{\value{@acCurTask}}{1}{\begin{itemize}}{}%
            \item{%
                \hyperref[@acSection##1]{\textcolor{black}{%
                    \@acLocTask~\the@acCurTask: \csuse{@acSection##1Title}%
                    \ (\csuse{@acSection##1Points}%
                    ~\ifcsstring{@acSection##1Points}{1}%
                        {\@acLocPoint}%
                        {\@acLocPoints})}}%
                ~{\scriptsize\pageref{@acSection##1}}%
                \par}}}%
    \ifnumequal{\value{@acCurTask}}{0}{}{\end{itemize}}}%
    
\NewDocumentCommand{\@acEntryField}{O{\textwidth} O{} m}{%
    \begin{minipage}{#1}%
        \vspace{0.25cm}%
        \rule{\lightrulewidth}{2pt}%
        \makebox[0cm][l]{\raisebox{4pt}{%
            \makebox[\textwidth - 2\lightrulewidth]{\vphantom{1}#2}}}%
        \rule{\textwidth - 2\lightrulewidth}{\lightrulewidth}%
        \rule{\lightrulewidth}{2pt}%
        \\%
        {\scriptsize\vphantom{g/(}#3\par}%
    \end{minipage}}

\newcommand*{\acExamForm}{%
    \@acAssertExam%
    \vspace{0.4cm}%
    \textbf{\@acLocStudent}%
    \vspace{-0.1cm}%
    
    {\hfuzz=31pt%
    \@acEntryField[(\textwidth - 0.4cm)*2/3]{\@acLocName}%
    \hspace{0.4cm}%
    \@acEntryField[(\textwidth - 0.4cm)*1/3]{\@acLocImmatriculationNumber}%
    \par}%
    
    {\hfuzz=31pt%
    \@acEntryField[(\textwidth - 0.4cm)*2/3]{\@acLocEmail}%
    \hspace{0.4cm}%
    \@acEntryField[(\textwidth - 0.4cm)*1/3]{\@acLocCourseOfStudy}%
    \par}%
        
    \vspace{0.4cm}%
    \textbf{\@acLocResult}%
    \vspace{-0.1cm}%
    
    \ifnumequal{\acNumTasks}{0}{}{%
        \newlength{\@acPointWidth}%
        \deflength{\@acPointWidth}%
            {(\textwidth - 2.4cm - 0.1cm * (\acNumTasks - 1)) / \acNumTasks}%
        
        {\hfuzz=31pt%
        \xintFor* ##1 in {\xintSeq{1}{\@acNumSections}}\do{%
            \ifcsstring{@acSection##1Points}{0}{}{%
                \@acEntryField[\@acPointWidth][\hyperref[@acSection##1]{%
                    \textcolor{black}{{\csuse{@acSection##1Points}}}}]{}%
                \hspace{0.1cm}}}%
        \hspace{0.3cm}%
        \@acEntryField[2cm][\@acPointsTotal]{\@acLocSum}%
        \par}%
        \vspace{-0.5cm}%
        {\scriptsize\vphantom{g/(}\@acLocMaximumPoints\par}%
        
        {\hfuzz=31pt%
        \xintFor* ##1 in {\xintSeq{1}{\@acNumSections}}\do{%
            \ifcsstring{@acSection##1Points}{0}{}{%
                \@acEntryField[\@acPointWidth]{}%
                \hspace{0.1cm}}}%
        \hspace{0.3cm}%
        \@acEntryField[2cm]{\@acLocSum}%
        \par}%
        \vspace{-0.5cm}%
        {\scriptsize\vphantom{g/(}\@acLocAchievedPoints\par}%
    }%
    
    {\hfuzz=31pt%
    \@acEntryField[\textwidth - 2.4cm]{\@acLocReviewersSignature}%
    \hspace{0.4cm}%
    \@acEntryField[2cm]{\@acLocGrade}%
    \par}%
    
    \vspace{0.4cm}}


% ------------------------------------------------------------------------------
% Table of contents

\setlength{\cftbeforetoctitleskip}{0.2cm}
\setlength{\cftaftertoctitleskip}{0cm}
\renewcommand*{\cfttoctitlefont}{\Large}
\renewcommand*{\cftpartfont}{\hypersetup{linkcolor=black}}
\renewcommand*{\cftsecfont}{\textbullet~\hypersetup{linkcolor=black}}
\renewcommand*{\cftsubsecfont}{\textbullet~\hypersetup{linkcolor=black}}
\renewcommand*{\cftpartpagefont}{}
\renewcommand*{\cftsecpagefont}{}
\renewcommand*{\cftsubsecpagefont}{}
\setlength{\cftsubsecindent}{0.4cm}
\setlength{\cftbeforepartskip}{0.4cm}
\setlength{\cftbeforesecskip}{0.2cm}
\setlength{\cftbeforesubsecskip}{0.05cm}

% ------------------------------------------------------------------------------
% Multiple Choice

\newcommand*{\@acEmptySquare}{\framebox(6,6){}}
\newcommand*{\@acCheckedSquare}{\text{\rlap{$\checkmark$}}\@acEmptySquare}

\NewEnviron{acMultipleChoice}{%
    \par\hfuzz=31pt%
    \setlength{\tabcolsep}{0.1cm}%
    \begin{tabular}{p{1.4cm}p{1.4cm}p{\dimexpr\linewidth-3.4cm}}%
        \toprule%
        \BODY%
        \bottomrule%
    \end{tabular}%
    \par}

\NewDocumentCommand{\acChoice}{s O{\@acLocTrue} O{\@acLocFalse} O{1} m}{%
    \acTask*{#4}%
    \IfBooleanTF{#1}%
        {\@acEmptySquare~\small#2}%
        {\acIfSolution%
            {\textcolor{acSolution}{\@acCheckedSquare~\small{#2}}}%
            {\@acEmptySquare~\small#2}}%
    &%
    \IfBooleanTF{#1}%
        {\acIfSolution%
            {\textcolor{acSolution}{\@acCheckedSquare~\small{#3}}}%
            {\@acEmptySquare~\small#3}}%
        {\@acEmptySquare~\small#3}%
    &%
    #5%
    \tabularnewline}


% ------------------------------------------------------------------------------
% Algorithm

\algrenewcomment[1]{%
    \hspace{0.25cm}\textcolor{acComment}{\itshape\(\triangleright\) #1}}
\algnewcommand{\LineComment}[1]{%
    \State\hspace{-0.25cm}\Comment{#1}}
\algrenewcommand\alglinenumber[1]{\footnotesize\color{acComment}#1}


% ------------------------------------------------------------------------------
% Listings

% In the following we make listings look like algorithms.
% See: https://tex.stackexchange.com/a/73396/75225

\lstset{
    frame=tb,
    basicstyle=\ttfamily,
    mathescape,
    showstringspaces=false,
    commentstyle=\color{acComment},
    numberstyle=\footnotesize\color{acComment},
    aboveskip=0.4cm,
    belowskip=0.2cm}

\lstdefinestyle{numbered}{
    numbers=left,
    numbersep=4pt,
    xleftmargin=16.5pt,
    framexleftmargin=16.5pt}

\DeclareCaptionFormat{lstlisting}{\hrule\vspace{2pt}#1#2#3}
\captionsetup[lstlisting]{format=lstlisting, singlelinecheck=off}


% ------------------------------------------------------------------------------
% Bibliography

\newcommand*{\acBibliographyResource}[1]{%
    % Only load biblatex on demand since it impacts compilation time.
    \RequirePackage[
        style=verbose-ibid,
        backend=biber,
        maxcitenames=2,
        giveninits=true, uniquename=init,
        doi=false, isbn=false, url=false, eprint=false,
    ]{biblatex}%
    % Make titles hpyerlinks if available.
    \newbibmacro{string+doiurlisbn}[1]{%
        \iffieldundef{doi}{%
            \iffieldundef{url}{%
                \iffieldundef{isbn}{%
                    \iffieldundef{issn}%
                        {##1}%
                    {\href{http://www.worldcat.org/search?qt=worldcat_org_all&q=\thefield{issn}}{##1}}}%
                {\href{http://www.worldcat.org/search?qt=worldcat_org_all&q=\thefield{isbn}}{##1}}}%
            {\href{\thefield{url}}{##1}}}%
        {\href{http://dx.doi.org/\thefield{doi}}{##1}}}%
    \DeclareFieldFormat*%
        {title}{\usebibmacro{string+doiurlisbn}{\mkbibemph{##1}}}%
    \DeclareFieldFormat[%
        article, inbook, incollection, inproceedings, patent, thesis, unpublished]%
        {title}{\mkbibquote{\usebibmacro{string+doiurlisbn}{##1}\isdot}}%
    \DeclareFieldFormat[suppbook,suppcollection,suppperiodical]%
        {title}{\usebibmacro{string+doiurlisbn}{##1}}%A
    \addbibresource{#1}}


% ------------------------------------------------------------------------------
% Blank Pages

\acIfSolution%
    {\newcommand*{\acBlankPages}[1]{}}%
    {\newcommand*{\acBlankPages}[1]{%
        \xintFor* ##1 in {\xintSeq[1]{1}{#1}}\do{%
            \clearpage%
            \addtocounter{page}{-1}%
            \thispagestyle{acBlankPage}%
            \textit{\@acLocBlankPages}}}}