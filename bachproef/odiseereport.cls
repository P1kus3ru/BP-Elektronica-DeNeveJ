\NeedsTeXFormat{LaTeX2e}
\def\@classname{odiseereport}
\ProvidesClass{odiseereport}[2026/03/17 Odisee report/thesis class]

\RequirePackage{xkeyval}
\RequirePackage{iflang}

%% Ensure the variables can be checked with \ifx\@variable\@empty
\let\@author\@empty
\let\@title\@empty
\let\@supervisor\@empty
\let\@cosupervisor\@empty
\let\@institution\@empty
\let\@academicyear\@empty
\let\@examperiod\@empty
\let\@degreesought\@empty

\let\@department\@empty
\let\@department@nr\@empty

%% Extra variables for the new title/info page layout
\let\@opleiding\@empty          %% Short programme name (info page)
\let\@institutionstreet\@empty  %% Company street + number
\let\@institutionpostal\@empty  %% Company postal code + city
\let\@campus\@empty             %% Campus name (footer)
\let\@campusaddress\@empty      %% Campus address (footer)
\let\@campusphone\@empty        %% Campus phone (footer)
\let\@campusemail\@empty        %% Campus email (footer)

\newcommand{\supervisor}[1]{\def\@supervisor{#1}}
\newcommand{\cosupervisor}[1]{\def\@cosupervisor{#1}}
\newcommand{\institution}[1]{\def\@institution{#1}}
\newcommand{\academicyear}[1]{\def\@academicyear{#1}}
\newcommand{\examperiod}[1]{\def\@examperiod{#1}}
\newcommand{\degreesought}[1]{\def\@degreesought{#1}}
\newcommand{\opleiding}[1]{\def\@opleiding{#1}}
\newcommand{\institutionstreet}[1]{\def\@institutionstreet{#1}}
\newcommand{\institutionpostal}[1]{\def\@institutionpostal{#1}}
\newcommand{\campus}[1]{\def\@campus{#1}}
\newcommand{\campusaddress}[1]{\def\@campusaddress{#1}}
\newcommand{\campusphone}[1]{\def\@campusphone{#1}}
\newcommand{\campusemail}[1]{\def\@campusemail{#1}}

\define@choicekey*+{odiseereport}{department}[\@department\@department@nr]
{cbt,cbm,cgz,co,csa,cdt}{}{%
    \ClassError{\@classname}{The cluster parameter is undefined}
    {One of the following options for the cluster must be added to the class%
        options: cbt, cbm, cgz, co, csa, cdt}}

\def\@DeclareDept#1{\DeclareOptionX{#1}{\setkeys{odiseereport}{department=#1}}}
\@DeclareDept{cbt}
\@DeclareDept{cbm}
\@DeclareDept{cgz}
\@DeclareDept{co}
\@DeclareDept{csa}
\@DeclareDept{cdt}

%% Redefine the title command to accept an optional subtitle
\renewcommand*\title[2][]{%
    \def\@title{#2}%
    \def\@subtitle{#1}%
}

%% Thesis or report?
\newif\if@thesis
\newif\if@report
\DeclareOptionX{thesis}{\@thesistrue\@reportfalse}
\DeclareOptionX{report}{\@thesisfalse\@reporttrue}
\ExecuteOptionsX{report} %% Default document type

%% Check the variables that need to be defined for the title page
\newcommand{\@checkvariables}{%
    
    \ifx\@author\@empty{%
        \ClassError{\@classname}{Author is undefined!}%
        {Use the \author command to define it}
    }\fi
    
    \ifx\@title\@empty{%
        \ClassError{\@classname}{Title is undefined!}%
        {Use the \title command to define it}
    }\fi
    \ifx\@academicyear\@empty{%
        \ClassError{\@classname}{Academic year is undefined!}%
        {Use the \academicyear command to define it}
    }\fi  
    
    %% The following variables only need to be defined for a thesis
    \if@thesis
    \ifx\@supervisor\@empty{%
        \ClassError{\@classname}{Student supervisor is undefined!}%
        {Use the \supervisor command to define it}
    }\fi
    \ifx\@examperiod\@empty{%
        \ClassError{\@classname}{Exam period is undefined!}%
        {Use the \examperiod command to define it}
    }\fi
    \ifx\@degreesought\@empty{%
        \ClassError{\@classname}{Degree sought is undefined!}%
        {Use the \degreesought command to define it}
    }\fi
    \fi
    
    %% Since the input is there, set the PDF info
    \hypersetup{%
        pdftitle=\@title,
        pdfauthor=\@author
    }
}

\newif\if@dutch
\newif\if@english
\DeclareOptionX{dutch}{\@dutchtrue\@englishfalse}
\DeclareOptionX{english}{\@dutchfalse\@englishtrue}
\ExecuteOptionsX{english} %% Default language

\newif\if@partial
\define@boolkey+{odiseereport}{partial}[false]{%
    \ifKV@odiseereport@partial
    \@partialtrue
    \else
    \@partialfalse
    \fi
}{%
    \ClassWarning{\@classname}{Input not boolean, ignored}
}
\DeclareOptionX{partial}{\setkeys{\@classname}{partial}}
%% Allows the partial boolean to be set with a command
\newcommand{\partialthesis}[1]{\setkeys{\@classname}{partial=#1}}

\newif\if@nativefonts
\DeclareOptionX{nativefonts}{\@nativefontstrue}

\newif\if@print
\DeclareOptionX{print}{\@printtrue}

\DeclareOption{twocolumn}{
    \OptionNotUsed
    \ClassError{\@classname}{Only single column documents supported!}%
    {Please remove the option 'twocolumn'}
}

%% Pass the unknown options to the class
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{book}}

\ProcessOptionsX\relax
\LoadClass[11pt]{book}

%% English is the default language, but this can be changed to Dutch by
%% specifying the 'dutch' option to the document class
\if@dutch
\RequirePackage[dutch]{babel}
\RequirePackage[style=ieee,backend=biber]{biblatex}
\else
%% We need Dutch for English theses, e.g. on the translated title page
\RequirePackage[main=english,dutch]{babel}
\RequirePackage[style=ieee,backend=biber]{biblatex}
\fi
\RequirePackage{csquotes}

\RequirePackage[small,bf,nooneline,footnotesize]{caption}
\RequirePackage[flushmargin,hang]{footmisc}
\RequirePackage{ifpdf}
\RequirePackage{ifxetex}
\RequirePackage{ifluatex}

\ifxetex
\RequirePackage[xetex]{geometry}
\RequirePackage[xetex]{graphicx}
\RequirePackage[xetex,plainpages=false,breaklinks]{hyperref}
\RequirePackage[no-math]{fontspec}
\RequirePackage[mathrm=sym]{unicode-math}
\unimathsetup{math-style=ISO,bold-style=ISO,sans-style=upright,mathrm=sym}
\RequirePackage{realscripts}
\defaultfontfeatures{Ligatures=TeX}
\else
\ifluatex
\RequirePackage[luatex]{geometry}
\RequirePackage[luatex]{graphicx}
\RequirePackage[luatex,plainpages=false]{hyperref}
\RequirePackage[no-math]{fontspec}

\RequirePackage[mathrm=sym]{unicode-math}
\unimathsetup{math-style=ISO,bold-style=ISO,sans-style=upright,
    mathrm=sym}
\RequirePackage{lualatex-math}
\RequirePackage{realscripts}
\else
\@nativefontstrue %% Force native font rendering
\ifpdf
\RequirePackage[pdftex]{geometry}
\RequirePackage[pdftex]{graphicx}
\RequirePackage[pdftex,plainpages=false,breaklinks]{hyperref}
\else
\RequirePackage[dvips]{geometry}
\RequirePackage[dvips]{graphicx}
\RequirePackage[hypertex,plainpages=false,breaklinks]{hyperref}
\fi
\fi
\fi

\if@print
\RequirePackage[gray]{xcolor}
\else
\RequirePackage[dvipsnames]{xcolor}
\fi

% Graphics related packages
\RequirePackage{tikz}
\usetikzlibrary{backgrounds}
\usetikzlibrary{positioning}
\RequirePackage{standalone}
\RequirePackage{wrapfig}
\graphicspath{{../graphics/}}

% Page layout & document structure
\RequirePackage{appendix}
\RequirePackage{booktabs}
\RequirePackage{enumitem}
%\setlist{noitemsep}
%\setlist[enumerate]{itemsep=1pt}
%\setlist[itemize]{itemsep=1pt}
%\setlist{parsep=\topskip}
%\setlist{topsep=\topskip}
%\setlist{partopsep=\topskip}
\RequirePackage{fancyhdr}
\RequirePackage{makeidx}
\RequirePackage{makecell}
\RequirePackage{pdfpages}
\RequirePackage{rotating}
\RequirePackage{tabularx}
\RequirePackage{tcolorbox}
\RequirePackage[noindentafter]{titlesec}
\RequirePackage{titletoc}
\RequirePackage[nottoc]{tocbibind}
\RequirePackage{url}

% Typography & Symbols
\RequirePackage{eurosym}
\RequirePackage{microtype}
\RequirePackage{textcomp}
\RequirePackage{xspace}
\RequirePackage{csquotes}

%% Accent colors:
\definecolor{odisee-darkgreen}{RGB}{22,176,165}
\definecolor{odisee-navy}{RGB}{31,65,107}%% Odisee logo navy blue
\definecolor{odisee-pink}{RGB}{241,157,160}
\definecolor{odisee-ochre}{RGB}{250,188,50}
\definecolor{odisee-orange}{RGB}{239,135,103}
\definecolor{odisee-purple}{RGB}{187,144,189}
\definecolor{odisee-blue}{RGB}{76,162,213}
\definecolor{odisee-lightgreen}{RGB}{165,202,114}
\definecolor{odisee-brown}{RGB}{216,176,131}
\definecolor{odisee-grey}{RGB}{195,187,175}
\definecolor{odisee-yellow}{RGB}{244,222,0}

\colorlet{links}{odisee-blue} %% The color to be used for urls and references

%% Setting of the cluster text and title color based on the class option
\ifx\@department\@empty{%
    \ClassError{\@classname}{Cluster parameter is undefined!}%
    {One of the following options must be added to the class options:%
        cbo, cgz, cit, clo, cog, csa, csoa}%
}\fi

\ifcase\@department@nr%
\relax
\colorlet{title}{odisee-navy}% cbt
\or
\colorlet{title}{odisee-purple}% cbm
\or
\colorlet{title}{odisee-pink}% cgz
\or
\colorlet{title}{odisee-blue}% co
\or
\colorlet{title}{odisee-grey}% csa
\else
\colorlet{title}{odisee-orange}% cdt
\fi

\newcommand{\@departmentname}{%
    \ifcase\@department@nr%
    \relax %cbt
    \IfLanguageName{dutch}{Cluster (Bio)Technologie}%
    {Cluster (Bio)Technology}%
    \or %cbm
    \IfLanguageName{dutch}{Cluster Bedrijfsmanagement}%
    {Cluster Business Management}%
    \or %cgz
    \IfLanguageName{dutch}{Cluster Gezondheidszorg}%
    {Cluster Healthcare}%
    \or %co
    \IfLanguageName{dutch}{Cluster Onderwijs}%
    {Cluster Education}%
    \or %csa
    \IfLanguageName{dutch}{Cluster Sociaal-Agogisch Werk}%
    {Cluster Social Welfare}%
    \else %cdt
    \IfLanguageName{dutch}{Cluster Design \& Technologie}%
    {Cluster Design \& Technology}%
    \fi
}

%% Cluster name derived automatically from the cluster option
\newcommand{\@clustername}{%
    \ifcase\@department@nr%
    \relax %cbt
    \IfLanguageName{dutch}{Cluster (Bio)Technologie}%
    {Cluster (Bio)Technology}%
    \or %cbm
    \IfLanguageName{dutch}{Cluster Bedrijfsmanagement}%
    {Cluster Business Management}%
    \or %cgz
    \IfLanguageName{dutch}{Cluster Gezondheidszorg}%
    {Cluster Healthcare}%
    \or %co
    \IfLanguageName{dutch}{Cluster Onderwijs}%
    {Cluster Education}%
    \or %csa
    \IfLanguageName{dutch}{Cluster Sociaal-Agogisch Werk}%
    {Cluster Social Welfare}%
    \else %cdt
    \IfLanguageName{dutch}{Cluster Design \& Technologie}%
    {Cluster Design \& Technology}%
    \fi
}

%% No title and link colors in print mode
\if@print
\colorlet{title}{black}
\colorlet{links}{black}
\fi

%% Font setup — Arial (vademecum §6.1)
\if@nativefonts
\ClassInfo{\@classname}{Option 'nativefonts' set or
    not running XeLaTeX/LuaLaTeX: using Helvetica (Arial substitute)}

\RequirePackage[T1]{fontenc}
\RequirePackage[scaled]{helvet}   %% Helvetica ≈ Arial for pdfLaTeX
\renewcommand{\familydefault}{\sfdefault}

\def\titlefont{\fontseries{b}\selectfont}
\def\subtitlefont{\fontseries{b}\selectfont}
\def\tocfont{\selectfont}
\def\titlestyle{\titlefont\bfseries}
\else
%% XeLaTeX / LuaLaTeX: try Arial, fall back to Calibri, then Latin Modern Sans
\IfFontExistsTF{Arial}{%
    \setmainfont{Arial}
    \setsansfont{Arial}
}{%
    \IfFontExistsTF{Calibri}{%
        \setmainfont{Calibri}
        \setsansfont{Calibri}
    }{%
        \setmainfont{Latin Modern Sans}
        \setsansfont{Latin Modern Sans}
    }%
}

\def\titlefont{\bfseries}
\def\subtitlefont{\bfseries}
\def\tocfont{}
\def\titlestyle{\bfseries}
\fi

%% Use the length of the 'HO' part of the logo to set the padding of the logo
\newsavebox{\logopart}
\savebox{\logopart}{\includegraphics[height=2cm]{logopart}}

%% We use A4 paper with slightly smaller margins than the default (scale = 0.7)
\geometry{a4paper, inner=33mm, outer=20mm, top=20mm, bottom=20mm, headheight=14pt}

%% Page layout settings
\setlength{\parindent}{0cm}              %% Don't indent paragraph text
\renewcommand{\baselinestretch}{1.2}     %% Increase line height
\raggedbottom                            %% Don't equalize content on pages

%% Figure & table numbering per chapter in "Fig. X-Y" style (vademecum 6.4)
\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
\renewcommand{\thetable}{\thechapter-\arabic{table}}
\renewcommand{\figurename}{Fig.}


%% Redefine maketitle for the Odisee Word-template title page layout
\if@titlepage%
\renewcommand{\maketitle}{%
    \thispagestyle{empty}%
    \begin{titlepage}%
        \@checkvariables
        \newgeometry{top=1.5cm, bottom=2cm, left=2cm, right=2cm}
        
        %% ── HEADER ROW ──────────────────────────────────────────────────────────
        \noindent%
        \begin{minipage}[c]{0.45\textwidth}
            \includegraphics[height=2cm]{odisee_logo}
        \end{minipage}%
        \hfill%
        \begin{minipage}[c]{0.5\textwidth}
            \raggedleft
            {\titlefont\bfseries\fontsize{26}{30}\selectfont
                \if@thesis
                \IfLanguageName{dutch}{Bachelorproef}{Bachelor's Thesis}%
                \else
                \IfLanguageName{dutch}{Verslag}{Report}%
                \fi}\\[0.3em]
            {\normalsize\@clustername}
        \end{minipage}
        
        \vspace{1em}
        
        %% ── MAIN BOX ────────────────────────────────────────────────────────────
        \setlength{\fboxsep}{1em}%
        \setlength{\fboxrule}{0.5pt}%
        \noindent\fbox{%
            \begin{minipage}[t][\dimexpr\textheight-5.8cm\relax][t]%
                {\dimexpr\textwidth-2\fboxsep-2\fboxrule\relax}
                
                %% Author name (bold)
                {\bfseries\@author}\\[0.6em]
                
                %% Degree + academic year
                \ifx\@degreesought\@empty\else\@degreesought\\\fi
                \IfLanguageName{dutch}{Academiejaar}{Academic year}: \@academicyear
                
                \vspace*{\fill}
                
                %% Title: large, bold, centred
                \begin{center}
                    {\bfseries\LARGE\@title}%
                    \ifx\@subtitle\@empty\else\\[0.4em]{\large\@subtitle}\fi
                \end{center}
                
                \vspace*{\fill}
                
                %% Institution info: right-aligned
                \ifx\@institution\@empty\else
                \begin{flushright}
                    {\bfseries\@institution}\\
                    \ifx\@institutionstreet\@empty\else\@institutionstreet\\\fi
                    \ifx\@institutionpostal\@empty\else\@institutionpostal\fi
                \end{flushright}
                \fi
            \end{minipage}%
        }%
        
        \vspace*{\fill}
        
        %% ── FOOTER (campus info) ─────────────────────────────────────────────
        \ifx\@campus\@empty\else
        \noindent{\small\color{title}%
            \textbf{\@campus}\\
            \ifx\@campusaddress\@empty\else\@campusaddress\\\fi
            \ifx\@campusphone\@empty\else T.~\@campusphone\fi
            \ifx\@campusemail\@empty\else\ |\ E.~\@campusemail\fi
        }%
        \fi
        
    \end{titlepage}%
    \restoregeometry
}
\fi

%% ── INFO PAGE (second page, colophon-style) ───────────────────────────────
\newcommand{\makeinfopage}{%
    \thispagestyle{empty}%
    \noindent\includegraphics[height=1.5cm]{odisee_logo}%
    \par\vspace{1cm}%
    %% Auteur
    \noindent{\bfseries\IfLanguageName{dutch}{Auteur}{Author}}\\
    \@author\par
    %% Opleiding
    \bigskip
    \noindent{\bfseries\IfLanguageName{dutch}{Opleiding}{Programme}}\\
    \ifx\@opleiding\@empty
    \ifx\@degreesought\@empty\else\@degreesought\fi
    \else
    \@opleiding
    \fi\par
    %% Academiejaar
    \bigskip
    \noindent{\bfseries\IfLanguageName{dutch}{Academiejaar}{Academic year}}\\
    \@academicyear\par
    %% Interne promotor / supervisor
    \if@thesis
    \ifx\@supervisor\@empty\else
    \bigskip
    \noindent{\bfseries\IfLanguageName{dutch}{Interne promotor}{Internal supervisor}}\\
    \@supervisor\par
    \fi
    %% In samenwerking met / institution
    \ifx\@institution\@empty\else
    \bigskip
    \noindent{\bfseries\IfLanguageName{dutch}{In samenwerking met}{In cooperation with}}\\
    \@institution\\
    \ifx\@institutionstreet\@empty\else\@institutionstreet\\\fi
    \ifx\@institutionpostal\@empty\else\@institutionpostal\fi\par
    \fi
    %% Externe promotor(en) / co-supervisor
    \ifx\@cosupervisor\@empty\else
    \bigskip
    \noindent{\bfseries\IfLanguageName{dutch}{Externe promotor(en)}{External supervisor(s)}}\\
    \@cosupervisor\par
    \fi
    \fi
    \clearpage
    \thispagestyle{empty}\null\clearpage
}

%% Page style for title pages
\fancypagestyle{plain}{%
    \fancyhf{}
    \renewcommand*\headrulewidth{0pt}
    \renewcommand*\footrulewidth{0pt}
    \fancyfoot[C]{\thepage}
}

%% Fancy style for the main matter
\fancypagestyle{mainmatter}{%
    \fancyhf{}
    %% Page numbers on the top left and top right
    \fancyhead[LE,RO]{\thepage}
    %% Chapter name on the left (even) page
    \fancyhead[RE]{\titlefont\bfseries\nouppercase{\leftmark}}
    %% Section name on the right (odd) page
    \fancyhead[LO]{\titlefont\bfseries\nouppercase{\rightmark}}
}

%% The mainmatter style is default for normal pages
\pagestyle{mainmatter}

%% Print the current chapter and section at the top of the page
\renewcommand*\chaptermark[1]{\markboth{\thechapter.\ \color{title}#1}{}}
\renewcommand*\sectionmark[1]{\markright{\thesection.\ \color{title}#1}}

%% The setheader command can be used to print the title of unnumbered chapters
%% in the page header
\newcommand*\setheader[1]{\markboth{\color{title}#1}{\color{title}#1}}

%% Change the headrule command (from fancyhdr.sty) to draw the line below the
%% header in the title color
\renewcommand*\headrule{%
    \if@fancyplain%
    \let\headrulewidth\plainheadrulewidth%
    \fi%
    {\color{title}\hrule\@height\headrulewidth\@width\headwidth}%
    \vskip-\headrulewidth%
}

%% Change the style of paragraphs, normally text comes directly after the
%% paragraph title
\titleformat{\paragraph}[hang]{\normalfont\normalsize\bfseries}{\theparagraph}
{0pt}{}
\titlespacing\paragraph{0pt}{\baselineskip}{0pt}

%% Draw the line above a footnote in the title color as well
\renewcommand*\footnoterule{%
    \vspace*{-3pt}%
    {\color{title}\hrule width 0.5\textwidth height 0.4pt}%
    \vspace*{2.6pt}%
}

%% A part title starts with a huge (96pt) bold black number, flushed to the
%% right, followed by the part name on the next line in the title color
\titleformat{\part}[display]
{\flushright\titlestyle}
{\fontsize{96pt}{96pt}\selectfont\bfseries\thepart}
{0pt}
{\Huge\color{title}}
%% Separate the title from the text by two empty lines
\titlespacing{\part}{0pt}{0pt}{2\baselineskip}
%% In the table of contents, the part name is preceded by an empty line, printed
%% in bold, and not followed by a line of dots
\dottedcontents{part}[0em]{%
    \vspace{\baselineskip}\subtitlefont\bfseries}{1.5em}{0pc}

%% Chapter titles have the same layout as parts
\titleformat{\chapter}[display]
{\flushright\titlestyle}
{\fontsize{96pt}{96pt}\selectfont\bfseries\thechapter}
{0pt}
{\Huge\color{title}}
\titlespacing{\chapter}{0pt}{0pt}{2\baselineskip}
%% In the table of contents, a chapter is similar to a part, except that it is
%% preceded by half an empty line
\dottedcontents{chapter}[1.5em]{%
    \vspace{0.5\baselineskip}\subtitlefont\bfseries}{1.5em}{0pc}

%% Section titles start with the number in bold, followed by the name printed
%% in the title color
\titleformat{\section}
{\Large\titlestyle}
{\bfseries\thesection.\ }
{0pt}
{\color{title}}
%% Sections are preceded by an empty line.
\titlespacing{\section}{0pt}{\baselineskip}{3pt}
%% In the table of contents, section names are followed by a line of dots 8pt
%% apart
\dottedcontents{section}[3.8em]{\tocfont}{2.3em}{8pt}

%% Subsection titles have the same layout as section titles, except in a smaller
%% font
\titleformat{\subsection}
{\large\titlestyle}
{\bfseries\thesubsection.\ }
{0pt}
{\color{title}}
\titlespacing{\subsection}{0pt}{\baselineskip}{1.5pt}
\dottedcontents{subsection}[7em]{\tocfont}{3.2em}{8pt}

%% Subsubsections have the same font and color as sections and subsections, but
%% are not preceded by a number
\titleformat{\subsubsection}
{\titlestyle}
{}
{0pt}
{\color{title}}
%% Subsubsections are preceded by an empty line and do not appear in the table
%% of contents
\titlespacing{\subsubsection}{0pt}{\bigskipamount}{0pt}

%% Hyperlinks are blue, except in print mode, when they are all black
\hypersetup{%
    colorlinks = true,
    citecolor = links,
    linkcolor = title,
    urlcolor = links
}