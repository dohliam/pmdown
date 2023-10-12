
""
"  Extract text from PMWiki raw data file
"
function! PMWiki_Extract_Text ()
    % global! /^text=/ delete
    1 substitute /^text=//
    1 substitute /%0a/\r/ge
endfunction PMWiki_Extract_Text

""
"  Add hugo front matter
"
function! PMWiki_Add_Front_Matter ()
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

endfunction PMWiki_Add_Front_Matter

function! PMWiki_To_Markdown ()
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

    " Convert small text
    "
    % substitute !\v\[-(.{-})-\]!<small>\1</small>!e

    " Convert bold italic
    "
    % substitute /\v'{5,5}(.{-})'{5,5}/_**\1**_/e

    " Convert bold
    "
    % substitute /\v'{3,3}(.{-})'{3,3}/**\1**/e

    " Convert italic
    "
    % substitute /\v'{2,2}(.{-})'{2,2}/_\1_/e

    " Convert code blocks
    "
    % substitute /\V\^[@/```text/e
    % substitute /\V\^@]/```/e

    " Convert complex table
    "
endfunction PMWiki_To_Markdown

function! PMWiki_Table_To_Markdown ()
    let s:line=getline('.')

    /{|/,/|}/ substitute /||!\?/|/ge
    call setline('.', s:line)

    "  Replace header marker (denoted by a '!') with column marker
    "
    /{|/,/|}/ substitute /^!\s.\{-}\s|/|/e
    call setline('.', s:line)

    "  Replace column marker (dentoted by a '|') with column marker
    "
    /{|/,/|}/ substitute /||/|/ge
    call setline('.', s:line)

    "  Delete row marker
    "
    /{|/,/|}/ global  /^|-/ delete
    call setline('.', s:line)

    " Convert caption 
    "
    /{|/,/|}/ substitute /^|+\(.*\)/**\1**/e
    call setline('.', s:line)

    "  Add missing with column marker at end of line
    "
    /{|/,/|}/ substitute /[^|]$/\0 |/e
    call setline('.', s:line)

endfunction PMWiki_Table_To_Markdown

command PMWikiExtractText	:call PMWiki_Extract_Text()
command PMWikiAddFrontMatter	:call PMWiki_Add_Front_Matter()
command PMWikiToMarkdown	:call PMWiki_To_Markdown()
command PMWikiTableToMarkdown	:call PMWiki_Table_To_Markdown()

execute "47menu Plugin.Wiki.PMWiki\\ Extract\\ Text<Tab>"	    . escape(g:mapleader . "pe" , '\') . " :call PMWiki_Extract_Text()<CR>"
execute "47menu Plugin.Wiki.PMWiki\\ Add\\ Front\\ Matter<Tab>"	    . escape(g:mapleader . "pa" , '\') . " :call PMWiki_Add_Front_Matter()<CR>"
execute "47menu Plugin.Wiki.PMWiki\\ To\\ Markdown<Tab>"	    . escape(g:mapleader . "pm" , '\') . " :call PMWiki_To_Markdown()<CR>"
execute "47menu Plugin.Wiki.PMWiki\\ Table\\ To\\ Markdown<Tab>"    . escape(g:mapleader . "pt" , '\') . " :call PMWiki_Table_To_Markdown()<CR>"

" vim: set textwidth=78 nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
" vim: set filetype=vim fileencoding= fileformat=unix foldmethod=marker :
" vim: set nospell spelllang=en_bg :
