
""
"  Extract text from PMWiki raw data file
"
function! PMWiki_Extract_Text ()
    % global! /^text=/ delete
    1 substitute /^text=//
    1 substitute /%0a/\r/ge
endfunction # PMWiki_Extract_Text

""
"  Add hugo front matter
"
function! PMWiki_Add_Front_Matter ()
    let l:Title_Line=getline(1)
    let l:Title_Text=Title_Line->substitute("^(:title ", "", "")->substitute(":)$", "", "")

    1 insert
---
title       : "(:title:)"
description : "(:title:)"
summary     : "(:title:)."
showSummary : true
date        : (:date:)
draft       : true
type        : "page"
categories  : []
tags        : []
---
.
    2,4 substitute /(:title:)/\= l:Title_Text /e
    6   substitute /(:date:)/\= strftime("%Y-%m-%dT%T%z",expand("%")->getftime()) /e
    12  delete
endfunction # PMWiki_Add_Front_Matter

function! PMWiki_To_Markdown ()
    " Convert odered list
    "
    % substitute /\v^(#{1,})(.*)/\= repeat(" ", submatch(1)->strlen() - 1) . "1. " . submatch(2)->trim() /e

    " Convert unodered list
    "
    % substitute /\v^(\*{1,})(.*)/\= repeat(" ", submatch(1)->strlen() - 1) . "* " . submatch(2)->trim()/e

    " Convert definition list
    "
    % substitute /\v^:(.{-}):(.*)/\= "\n**" . submatch(1)->trim() . "**\n" . ": " . submatch(2)->trim() /e
    % substitute /\v^-\>(.*)/\= ": " . submatch(1)->trim() /e

    " Convert header
    "
    % substitute /\v^(!{1,})(.*)/\= repeat("#", submatch(1)->strlen() - 1) . " " . submatch(2)->trim() /e

    " Convert external links
    "
    % substitute !\v\[\[(https{0,1}://.{-})\|(.{-})\]\]![\2](\1)!ge

    " Convert small text
    "
    % substitute !\v\[-(.{-})-\]!<small>\1</small>!e

    " Convert bold italic
    "
    % substitute /\v'''''(.*?)'''''/_**\\1**_"/e

    " Convert bold
    "
    % substitute /\v'''(.*?)'''/**\\1**"/e

    " Convert italic
    "
    % substitute /\v''(.*?)''/_\\1_"/e

    " Convert code blocks
    "
    % substitute /\V\^[@/```text/e
    % substitute /\V\^@]/```/e

    " Convert table
    "
    global /^||/ substitute /||!\?/|/g

endfunction PMWiki_To_Markdown

" vim: set textwidth=78 nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
" vim: set filetype=vim fileencoding= fileformat=unix foldmethod=marker :
" vim: set nospell spelllang=en_bg :
