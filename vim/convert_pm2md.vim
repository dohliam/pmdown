
function s:Numbered_List(match)

endfunction s:Numbered_List()

function PMWiki_To_Markdown
    " Convert odered list
    "
    % substitute /\v^(#{1,})/\=repeat(" ", strlen(submatch(1)) - 1) . "1. "/
    
    " Convert unodered list
    "
    % substitute /\v^(\*{1,})/\=repeat(" ", strlen(submatch(1)) - 1) . "* "/

endfunction PMWiki_To_Markdown

" vim: set textwidth=78 nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
" vim: set filetype=vim fileencoding= fileformat=unix foldmethod=marker :
" vim: set nospell spelllang=en_bg :
