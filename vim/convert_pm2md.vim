
function PMWiki_To_Markdown ()
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
    
    " Convert external links
    "
    % substitute !\v\[\[(https{0,1}://.{-})\|(.{-})\]\]![\2](\1)!ge

    " Convert small text
    "
    % substitute !\v\[-(.{-})-\]!<small>\1</small>!e

endfunction PMWiki_To_Markdown

" vim: set textwidth=78 nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
" vim: set filetype=vim fileencoding= fileformat=unix foldmethod=marker :
" vim: set nospell spelllang=en_bg :
