\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{baier}[11/29/2020 first try at a unified class]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%|--------------------------------|%
%| Options 				          |%
%|--------------------------------|%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{ifthen}
\RequirePackage{etoolbox} % for AtEndPreamble
\RequirePackage{xstring} % for string comparison stuff
\RequirePackage{xparse}

\def\myclasstype{article}			%% sets default class to article
\newcommand{\whatclass}{oops}		%% sets up a thing to say what class you're using
\newcommand{\testexpex}{Expex off!}	%% sets up a thing to say what class you're using

%%% Declare some important options %%% 

\newboolean{proofing}
\setboolean{proofing}{false}

\newboolean{twoup}
\setboolean{twoup}{false}

\newboolean{wbullets}
\setboolean{wbullets}{false}

\DeclareOption{twoup}{
	\setboolean{twoup}{true}
}

\DeclareOption{proofing}{
	\setboolean{proofing}{true}
%	\PassOptionsToPackage{proofing}{baier-test}
}

\DeclareOption{wbullets}{%
	\setboolean{wbullets}{true}
}

%%% Document types %%% 

%% Paper option %%

\DeclareOption{paper}{%
    \gdef\myclasstype{memoir}
	\PassOptionsToClass{11pt}{\myclasstype}
	\PassOptionsToClass{article}{\myclasstype}
	\PassOptionsToClass{oneside}{\myclasstype}
%	\PassOptionsToPackage{paper}{baier-test}
	\renewcommand{\whatclass}{your class is memoir}

	\AtEndOfClass{% set up the format 

	% Text area dimensions for [paper]
	\settypeblocksize{7.75in}{32pc}{*}
	\setlrmargins{*}{*}{1}
	\setulmargins{*}{*}{1}
	\checkandfixthelayout

	% Header spacing for [paper]
	\setlength{\headheight}{15pt}
	\setlength{\headsep}{2.25\onelineskip}

	% Custom page headers for [paper]
	\makepagestyle{myruled}
	\makeevenhead{myruled} {{\small\leftmark}} {}  {\small\thepage}
	\makeoddhead{myruled}  {{\small\leftmark}} {}  {\small\thepage}
	\makepsmarks{myruled} {\createmark{chapter}{left}{nonumber}{}{}}
	\makeheadrule{myruled}{\textwidth}{0.5pt}
	\nouppercaseheads
	\pagestyle{myruled}

	\makepagestyle{firstpage}
	\makeoddhead{firstpage} {{\small\thetitle}} {}  {\small\thepage}
	\makeheadrule{firstpage}{\textwidth}{0.5pt}
	
	% \maketitle for [paper]
	\renewcommand{\maketitle}{%
	%	\vspace*{-\headsep}
	    \vspace*{-\headheight}
		\begin{center}
		{\LARGE\bfseries \thetitle}
		\vskip1.25\baselineskip
		{\normalsize \theauthor} 
		\vskip.25ex
		{\normalsize \thedate}
		\end{center}
	    \vskip\baselineskip
		\thispagestyle{firstpage}
		}

	% section formatting for [paper]

	\setsecnumdepth{subsubsection}	

	\renewcommand{\chapnumfont}{\Large\bfseries}
	\renewcommand{\chaptitlefont}{\chapnumfont}
	\setsecheadstyle{\large\bfseries}
	\setlength{\beforechapskip}{2\baselineskip plus 1ex minus .2ex}
	
	} % end of formatting stuff  
} % end of declare option paper

%% Handout option %%

\DeclareOption{handout}{%
    \gdef\myclasstype{extarticle}
%	\PassOptionsToPackage{handout}{baier-test}
	\renewcommand{\whatclass}{your class is extarticle}

	% Choose font size based on whether this will 2up/1up	
	\ifthenelse{\boolean{twoup}}{%
		\PassOptionsToClass{14pt}{\myclasstype}}
		{\PassOptionsToClass{11pt}{\myclasstype}}

	\AtEndOfClass{% set up the format

	%% margins, page size dependent on 2up/1up
	\ifthenelse{\boolean{twoup}}{%
		% use a4paper with really small margins to be set into letterpaper
		\RequirePackage[
			a4paper,
			twoside,
			includehead,
			includefoot,
			top=0.0in,
			bottom=0.07in,
			inner=.45in,
			outer=.25in]{geometry}
		}{% use letterpaper with more or less standard margins
		\RequirePackage[
			letterpaper,
			includehead,
			includefoot,
			margin=.5in]{geometry}
		}

	%% \maketitle for [handout]
	\RequirePackage{titling}
	\setlength{\droptitle}{-4em}    % Eliminate the default vertical space
	\addtolength{\droptitle}{0pt}   % Use this for adjustment

	\makeatletter
		\def\@maketitle{% modified from titling.sty
		\newpage
		\null
		\vskip 2em%
		\vspace*{\droptitle}
		\maketitlehooka
		{\@bspretitle \@title \@bsposttitle}
		\maketitlehookb
		{\@bspreauthor \@author{} \@bspostauthor}
		\maketitlehookc
		{\@bspredate \@date{} \@bspostdate}
		\par
		\vskip 2.0em}
	\makeatother

	\pretitle{\begin{center}\Large\bfseries} %% \Large for 14 \LARGE for 12
	\posttitle{\par\end{center}}
	\preauthor{\begin{center}\large}
	\postauthor{\end{center}\par}
	\predate{\begin{center}\normalsize}
	\postdate{\par\end{center}}

	\renewcommand{\maketitlehookc}{%
	\begin{center}\email{}\end{center}}
	\renewcommand{\maketitlehookd}{%
	\begin{center}\normalsize\ttfamily\email{}\end{center}}

	\makeatletter
	\let\theauthor\@author
	\makeatother

	% page headers for [handout
	\RequirePackage{fancyhdr}
	\fancypagestyle{handoutstyle}{%
	\fancyhf{} % clear all header and footer fields
	\fancyhead[L]{\venue{}}
	\fancyhead[R]{\thedate}
	\fancyfoot[C]{\thepage}
	\renewcommand{\headrulewidth}{0.5pt}}

	\fancypagestyle{plain}{%
	\fancyhf{} % clear all header and footer fields
	\fancyhead[L]{\venue{}}
	\fancyhead[R]{\thedate}
	\fancyfoot[C]{\thepage}
	\renewcommand{\headrulewidth}{0.5pt}}

	\pagestyle{handoutstyle}


	% section styles for [handout]

	\RequirePackage{titlesec}

	\titleformat{\section}{\sffamily\Large\bfseries}{\thesection}{1em}{}
	\titlespacing*{\section}{0pt}{3.25ex plus 1ex minus .2ex}{2.75ex plus .2ex}

	\titleformat{\subsection}{\sffamily\large\bfseries}{\thesubsection}{1em}{}
	\titlespacing*{\subsection}{0pt}{3.0ex plus 1ex minus .2ex}{2.75ex plus .2ex}

	\titleformat{\subsubsection}{\sffamily\normalsize\bfseries}{\thesubsubsection}{1em}{}
	\titlespacing*{\subsubsection}{0pt}{3.0ex plus 1ex minus .2ex}{2.75ex plus .2ex}


	% list styles for [handout]	
	\RequirePackage{enumitem}
	\RequirePackage{tikz}

	\newcommand{\bulletcircle}{%
	\tikz{%
	\useasboundingbox (-0.2em,-0.32em) rectangle(0.2em,0.32em);%
	\node[draw=black,fill=black,circle,minimum width=0.3em,minimum height=0.3em,inner sep=0pt] at (0,0) {};}}
 
	\setlist[itemize,1]{
		label=\bulletcircle,
		leftmargin=*,
		labelindent=2.75pt,
		labelsep=8pt,
		topsep=0ex,
		itemsep=1.75ex,
		partopsep=0pt} 

	\setlist[itemize,2]{
		label=\raisebox{1.5pt}{\scalebox{.8}{$\rightslice$}},
		leftmargin=*,
		labelindent=0pt,
		labelsep=8pt,
		topsep=1.75ex,
		itemsep=1.75ex,
		partopsep=0pt}  

	\setlist[itemize,3]{
		label=--,
		leftmargin=*,
		labelindent=0pt,
		labelsep=8pt,
		topsep=1.75ex,
		itemsep=2ex,
		partopsep=0pt}  

	\setlist[enumerate,1]{
		label=\arabic*.,
		leftmargin=*,
		labelindent=0pt,
		labelsep=8pt,
		topsep=0ex,
		itemsep=9pt,
		partopsep=0pt} 

	\setlist[enumerate,2]{
		label=\alph*.,
		leftmargin=*,
		labelindent=0pt,
		labelsep=6pt,
		topsep=9pt,
		itemsep=9pt,
		partopsep=0pt}  

	\setlist[enumerate,3]{
		label=--,
		leftmargin=*,
		labelindent=0pt,
		labelsep=6pt,
		topsep=10pt,
		itemsep=10pt,
		partopsep=0pt}  

	\newlist{hsubenumerate}{enumerate}{10} 
	\setlist[hsubenumerate,1]{label=\arabic*.,
		leftmargin=*,
		labelindent=1.775pt,
		labelsep=6pt,
		topsep=9pt,
		itemsep=8pt,
		partopsep=0pt}  

	\setlist[hsubenumerate,2]{%
		label=-,
		leftmargin=*,
		labelindent=1.775pt,
		labelsep=6pt,
		topsep=10pt,
		itemsep=9pt,
		partopsep=0pt} 
	} %% end of handout format
} % end of handout option 

%% quicknote option %% 

\DeclareOption{quicknote}{%
    \gdef\myclasstype{extarticle}
	\PassOptionsToClass{11pt}{\myclasstype}

%	\setboolean{linguex}{true}

	\AtEndOfClass{%
		\RequirePackage[margin=.5in,includehead,includefoot]{geometry}
		\RequirePackage{titling}

		\usepackage{fancyhdr}
		\fancyhead{} % clear all header fields
		\fancyhead[L]{{\large \runtitle}}
		\fancyhead[R]{{\large \thedate}}
		\fancyfoot{} % clear all footer fields
		\fancyfoot[CO]{\thepage}
		\fancyfoot[CE]{\thepage}
		\renewcommand{\headrulewidth}{.5pt}

	\RequirePackage{titlesec}

	\titleformat{\section}{\sffamily\Large\bfseries}{\thesection}{1em}{}
	\titlespacing*{\section}{0pt}{3.25ex}{2.75ex}

	\titleformat{\subsection}{\sffamily\large\bfseries}{\thesubsection}{1em}{}
	\titlespacing*{\subsection}{0pt}{3.25ex}{2.75ex}

	\titleformat{\subsubsection}{\sffamily\normalsize\bfseries}{\thesubsubsection}{1em}{}
	\titlespacing*{\subsubsection}{0pt}{3.25ex}{2.75ex}

	%% List styles with [wbullets] selected
	\ifthenelse{\boolean{wbullets}}{%% bullet commands go here
	\newcommand{\bulletcircle}{%
	\tikz{%
	\useasboundingbox (-0.2em,-0.32em) rectangle(0.2em,0.32em);%
	\node[draw=black,fill=black,circle,minimum width=0.3em,minimum height=0.3em,inner sep=0pt] at (0,0) {};}}
 
	\setlist[itemize,1]{
		label=\bulletcircle,
		leftmargin=*,
		labelindent=2.75pt,
		labelsep=8pt,
		topsep=0ex,
		itemsep=1.0ex,
		partopsep=12pt} 

	\setlist[itemize,2]{
		label=\raisebox{1.5pt}{\scalebox{.8}{$\rightslice$}},
		leftmargin=*,
		labelindent=0pt,
		labelsep=8pt,
		topsep=1.0ex,
		itemsep=1.0ex,
		partopsep=0pt}  

	\setlist[itemize,3]{
		label=--,
		leftmargin=*,
		labelindent=0pt,
		labelsep=8pt,
		topsep=1.0ex,
		itemsep=1.0ex,
		partopsep=0pt}  

	\setlist[enumerate,1]{
		label=\arabic*.,
		leftmargin=*,
		labelindent=0pt,
		labelsep=8pt,
		topsep=0ex,
		itemsep=1.0ex,
		partopsep=0pt} 

	\setlist[enumerate,2]{
		label=\alph*.,
		leftmargin=*,
		labelindent=0pt,
		labelsep=6pt,
		topsep=1.0ex,
		itemsep=1.0ex,
		partopsep=0pt}  

	\setlist[enumerate,3]{
		label=--,
		leftmargin=*,
		labelindent=0pt,
		labelsep=6pt,
		topsep=10pt,
		itemsep=10pt,
		partopsep=0pt}  

	\newlist{hsubenumerate}{enumerate}{10} 
	\setlist[hsubenumerate,1]{label=\arabic*.,
		leftmargin=*,
		labelindent=1.775pt,
		labelsep=6pt,
		topsep=9pt,
		itemsep=8pt,
		partopsep=0pt}  

	\setlist[hsubenumerate,2]{%
		label=-,
		leftmargin=*,
		labelindent=1.775pt,
		labelsep=6pt,
		topsep=10pt,
		itemsep=9pt,
		partopsep=0pt} 


	}{}
	



	} %% end of AtEndOfClass quicknote

	\AtBeginDocument{%
		\makeatletter
		\@afterindentfalse
		\@afterheading
		\makeatother}

	\AtEndPreamble{%
		\pagestyle{fancy}	
		\makeatletter
		\let\runtitle\@title
	\makeatother}
}

%% coverletter option %% 

\DeclareOption{coverletter}{%
    \gdef\myclasstype{memoir}
	\PassOptionsToClass{11pt}{\myclasstype}
	\PassOptionsToClass{oneside}{\myclasstype}
	\PassOptionsToClass{letterpaper}{\myclasstype}

	\AtEndOfClass{% things for the class 
	\renewcommand{\dothis}[1]{\textcolor{red}{\uline{#1}}}
	\newcommand{\adcopy}[1]{\textcolor{blue}{#1}}

	\nonzeroparskip
	\setlength{\parindent}{0pt}
	\linespread{1.1}

	\usepackage{ragged2e}

	\setlrmarginsandblock{0.4in}{.4in}{*} 
	\setulmarginsandblock{0.5in}{0.7in}{*}
	\checkandfixthelayout


	%% Command for defining the salutation
	\newcommand{\mysalutation}[1]{\def\salutation{#1\vskip.75\baselineskip}}

	%% Command for defining the recipient address
	\newcommand{\myrecipient}[1]{\def\recipient{#1}}


	} % end of coverletter atendofclass

	\AfterEndPreamble{% stuff at the beginning of coverletter, including the heading
	\pagestyle{empty}
	\RaggedRight

	\noindent \begin{minipage}[t][0.55in][b]{5in}
    {\fontsize{26pt}{40pt}\selectfont
        \rmfamily\textbf{Nico Baier, Ph.D.}}
    \vfill%\vskip1ex
    \textsf{734-660-6123\, \raisebox{1.5pt}{{\tiny $\bullet$}}\,  nico.baier@gmail.com\, \raisebox{1.5pt}{{\tiny $\bullet$}}\, nbbaier.github.io}
	\end{minipage}

	\vskip2.5\baselineskip

	\begin{multicols}{2}
	\begin{minipage}[t]{.5\textwidth}
	{\small \recipient}
	\end{minipage}

	\begin{minipage}[t]{.47\textwidth}
	\hfill {\small \thedate}
	\end{minipage}
	\end{multicols}

	\vskip1.5\myskip

	\salutation


	} %% end of begin document

} %% end of coverletter option

%:pass unrecognised options off to \myclasstype
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{\myclasstype}}
%:process options
\ProcessOptions
%:load \myclasstype
\LoadClass{\myclasstype} % add options if desired

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%|--------------------------------|%
%%| Fonts, Symbols				   |%
%%|--------------------------------|%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Microtype, emphasis

\RequirePackage{microtype}
\RequirePackage[normalem]{ulem}

% Math symbols

\RequirePackage{bm}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{stmaryrd}
\RequirePackage{pifont}
\RequirePackage{bbding}
\RequirePackage{wasysym}
\RequirePackage{mathtools}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%|--------------------------------|%
%%| Colors, links, text, footnotes |%
%%|--------------------------------|%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[usenames,dvipsnames,svgnames,table]{xcolor}
\RequirePackage{soul}
\sethlcolor{yellow}
\definecolor{hlyellow}{cmyk}{0,0,0.2,0}
\newcommand{\dothis}[1]{\textcolor{blue}{#1}}
\newcommand{\alternate}[1]{\textcolor{red}{#1}}
\soulregister{\feature}{1}

\RequirePackage[colorlinks,%
breaklinks,%
linkcolor=splinkcolor, %
urlcolor=splinkcolor, %
citecolor=splinkcolor,%
filecolor=splinkcolor,%
plainpages=false,%
pdfpagelabels,%
bookmarks=true,%
pdfstartview=FitH,%
draft=false]{hyperref}

\definecolor{splinkcolor}{rgb}{.0,.0,.0}%{.0,.2,.4}

\newcommand{\doi}[1]{\url{http://dx.doi.org/#1}}

\urlstyle{rm}

\RequirePackage{cleveref}

\RequirePackage{setspace}
\RequirePackage{xspace}
\RequirePackage{cancel}
\RequirePackage{hyphenat}
\RequirePackage{lipsum}
\RequirePackage{blindtext}
\RequirePackage{kantlipsum}

\RequirePackage[bottom,hang,flushmargin,stable,multiple]{footmisc}
\renewcommand{\footnotemargin}[0]{1.0em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%|--------------------------------|%
%%| Floats, tables, figures        |%
%%|--------------------------------|%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{float}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{multicol}
\RequirePackage{multirow}
\RequirePackage{enumitem}

\setlength\heavyrulewidth{1.25pt}

\RequirePackage{caption}
\captionsetup{skip=4pt,font=small}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%|--------------------------------|%
%%| tikz				   			   |%
%%|--------------------------------|%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{tikz}
\usetikzlibrary{arrows,patterns,
   	calc,
    chains,
    fit,
    shapes,
    positioning,
	decorations.pathreplacing,
	backgrounds,
	decorations.pathmorphing,
	decorations.markings}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%|--------------------------------|%
%%| Proofing macros				   |%
%%|--------------------------------|%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifthenelse{\boolean{proofing}}{
%%%% highlight \ref commands without a cross reference %%%
	\makeatletter
		\def\@setref#1#2#3{%
		\ifx#1\relax 
		 \protect\G@refundefinedtrue
		 \nfss@text{\reset@font\bfseries\textcolor{red}{\hl{REF \<#3\>}}}%
		 \@latex@warning{Reference `#3' on page \thepage \space undefined}%
		 \else 
		 	\expandafter#2#1\null
		 \fi }
	\makeatother}{}


