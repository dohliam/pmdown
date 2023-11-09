"-------------------------------------------------------------------------------
"  Description: Convert PMWiki to Markdown
"   Maintainer: Martin Krischik «krischik@users.sourceforge.net»
"       Author: Martin Krischik «krischik@users.sourceforge.net»
"    Copyright: Copyright © 2023 Martin Krischik
" Name Of File: autoload/pm2md.vim
"      Version: 1.1
"	 Usage: copy to autoloa directory
"      History: 18.10.2023 MK Initial Release
"      History: 29.10.2023 MK Update Extract_Text to get initial and update
"			      timestamps
"-------------------------------------------------------------------------------

""
"  Extract text from PMWiki raw data file. Usefull if you use the PMWiki
"  database file to start the conversion process. 
"
function! pm2md#Extract_Text ()
    1
    /\v^ctime=/
    let l:create_time = line(".")->getline()->substitute("^.\\{-}=", "", "")

    1
    /\v^time=/
    let l:modify_time = line(".")->getline()->substitute("^.\\{-}=", "", "")

    % global! /^text=/ delete
    1 substitute /^text=//
    1 substitute /%0a/\r/ge

    call append (1, 'date	    : "' . system ("gdate -d @" . modify_time . " --rfc-3339=seconds")[:-2] . '"')
    call append (1, 'lastmod	    : "' . system ("gdate -d @" . create_time . " --rfc-3339=seconds")[:-2] . '"')
endfunction "pm2md#Extract_Text

""
"   Extract date and lastmod from PMWiki file and correct the dates of
"   converted markdown file. Normaly pm2md#Extract_Text should correctly
"   extract the dates. Die function only needs to be used if this fails for
"   whatever reason
"
function pm2md#Fix_Dates (Markdown, PMWiki)
    execute "edit" a:PMWiki

    1
    /\v^ctime=/
    let l:create_time = line(".")->getline()->substitute("^.\\{-}=", "", "")

    1
    /\v^time=/
    let l:modify_time = line(".")->getline()->substitute("^.\\{-}=", "", "")

    execute "edit" a:Markdown
    1
    /\Vlastmod\s\*:/
    . substitute /\v:.*$/\= ': "' . system("gdate -d @" . modify_time . " --rfc-3339=seconds")[:-2] . '"'/

    1
    /\Vdate\s\*:/
    . substitute /\v:.*$/\= ': "' . system("gdate -d @" . create_time . " --rfc-3339=seconds")[:-2] . '"'/

endfunction "pm2md#Fix_Dates

""
"  Add hugo front matter. Uses the first line as title, description and
"  summary. Uses the file date as article date. Works best when called
"  directly after pm2md#Extract_Text without saving in between.
"
function! pm2md#Add_Front_Matter ()
    let l:Title_Line=getline(1)
    let l:Title_Text=Title_Line->substitute("^(:title ", "", "")->substitute(":)$", "", "")

    1 insert
---
title	    : "(:title:)"
description : "(:title:)"
summary     : "(:title:)."
showSummary : true
date	    : (:date:)
draft	    : true
type	    : "page"
categories  : []
tags	    : []
---
.
    2,4 substitute /(:title:)/\= l:Title_Text /e
    6	substitute /(:date:)/\= strftime("%Y-%m-%dT%T%z",expand("%")->getftime()) /e
    12	delete
 
    $ append
<!-- vim: set wrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab : -->
<!-- vim: set textwidth=79 filetype=markdown foldmethod=marker spell : -->
<!-- vim: set spell spelllang=en_gb : -->
.

    set wrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab
    set textwidth=79 filetype=markdown foldmethod=marker spell
    set spell spelllang=en_gb
endfunction "pm2md#Add_Front_Matter

""
"   Converts most of PMWiki syntax to markdown. Currently only the three types
"   of tables need to be concerted seperatly.
"
function! pm2md#Convert ()
    " Convert odered list
    "
    % substitute /\v^(#{1,})(.*)/\= repeat(" ", submatch(1)->strlen() - 1) . "1. " . submatch(2)->trim() /e

    " Convert unodered list
    "
    % substitute /\v^(\*{1,})(.*)/\= repeat(" ", submatch(1)->strlen() - 1) . "* " . submatch(2)->trim()/e

    " Convert definition list
    "
    % substitute /\v^[:;](.{-}):(.*)/\= "\n**" . submatch(1)->trim() . "**\n" . ": " . submatch(2)->trim() /e
    % substitute /\v^-\>(.*)/\= ": " . submatch(1)->trim() /e

    " Convert header
    "
    % substitute /\v^(!{1,})(.*)/\= repeat("#", submatch(1)->strlen() - 1) . " " . submatch(2)->trim() /e

    " Convert external links
    "
    % substitute !\v\[\[(https{0,1}://.{-})\|(.{-})\]\]![\2](\1)!ge

    " Convert interal links
    "
    % substitute !\v\[\[(.{-})\|(.{-})\]\]![\2](\1)!ge
    % substitute !\v\[\[(.{-})\]\]![\1](\1)!ge

    " Convert small text
    "
    % substitute !\v\[-(.{-})-\]!<small>\1</small>!ge
    % substitute !\v'-(.{-})-'!<small>\1</small>!ge

    " Convert super and subscript
    "'^
    % substitute !\v'\^(.{-})\^'!<sup>\1</sup>!ge
    % substitute !\v'_(.{-})_'!<sub>\1</sub>!ge

    " Convert bold italic
    "
    % substitute /\v'{5,5}(.{-})'{5,5}/_**\1**_/ge

    " Convert bold
    "
    % substitute /\v'{3,3}(.{-})'{3,3}/**\1**/ge

    " Convert italic
    "
    % substitute /\v'{2,2}(.{-})'{2,2}/_\1_/ge

    " Convert monospaced
    "
    % substitute /\v\@{2,2}(.{-})\@{2,2}/`\1`/ge

    " Convert code blocks
    "
    % substitute /\V\^[@/```text/e
    % substitute /\V\^@]/```/e

    " Convert Picture links
    "
    % substitute #^%25width=\(\d*\)px%25 .*/\(.*.png\|.*.jpg\) | \(.*\)#![\3](\2?width=\1 "\3")#ge
    % substitute #^%25lframe%25 .*/\(.*.png\|.*.jpg\) | \(.*\)#![\2](\1?width=320 "\2")#ge
    % substitute #^%25lframe width=\d*px%25 .*/\(.*.png\|.*.jpg\) | \(.*\)#![\2](\1?width=320 "\2")#ge
endfunction "pm2md#Convert

""
"   Relace a standart table which begins with {| and |}. Converts one table at
"   a time to. Position cursort in the line above the {|.
"
function! pm2md#Convert_Table ()
    /{|/ mark s
    /|}/ mark e

    "	Replace single line column marker
    "
    's,'e substitute /||!\?/|/ge

    "  Replace header marker (denoted by a '!') with column marker
    "
    's,'e substitute /^!\s.\{-}\s|/|/e

    "  Replace column marker (dentoted by a '|') with column marker
    "
    's,'e substitute /||/|/ge

    "  Delete row marker
    "
    's,'e global /^|-/ delete

    " Convert caption 
    "
    's,'e substitute /^|+\(.*\)/**\1**/e

    "  Add missing with column marker at end of line
    "
    's,'e substitute /[^|]$/\0 |/e
endfunction "pm2md#Convert_Table

""
"   Relace a simple tables where each row is on one column. Converts one table
"   at a time to. Use line select to select the table from begin to end.
"
function! pm2md#Convert_Simple_Table () range
    "	Replace single line column marker
    "
    execute a:firstline . "," . a:lastline " substitute /||!\\?/|/ge"
    "  Add missing with column marker at end of line
    "
    execute a:firstline . "," . a:lastline " substitute /[^|]$/\\0 |/e" 
endfunction "pm2md#Convert_Simple_Table

""
"   Relace a complex table using the (:table:) markup. Converts one table at a
"   time to. Place the cursor in the line above (:table:). Needs the
"   {{< rawhtml >}} shortcode.
"
function! pm2md#Convert_Complex_Table () 
    /^(:table[: ]/ mark s
    /^(:tableend/  mark e

    "	Replace rows.
    "
    's,'e substitute !(:cellnr\(.*\):)\(.*\)!\= "<\/tr>\r<tr>\r<td" . submatch(1)->substitute('\s\(.\{-}\)=\(.\{-}\)\s',' \1="\2" ',"g") . ">" . submatch(2)->trim() . "</td>"!g
    normal 's 
    /<\/tr>/ delete

    "	Replace columns.
    "
    's,'e substitute !(:cell\(.*\):)\(.*\)!\= "<td" . submatch(1)->substitute('\s\(.\{-}\)=\(.\{-}\)\s',' \1="\2" ',"ge") . ">" . submatch(2)->trim() . "</td>"!g

    " replace simple picture links.
    "
    's,'e substitute #\v(https://.{-}.png)#<img src="\1"></img>#ge

    "	Replace table start.
    "
    's,'e substitute /(:table[: ]\(.*\):)/\= "{{< rawhtml >}}\r<table " . submatch(1) . ">"/ge

    "	Replace table end.
    "
    's,'e substitute !(:tableend:)!</tr>\r</table>\r{{< /rawhtml >}}!ge
endfunction "pm2md#Convert_Complex_Table

" vim: set textwidth=78 nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
" vim: set filetype=vim fileencoding= fileformat=unix foldmethod=marker :
" vim: set nospell spelllang=en_bg :
