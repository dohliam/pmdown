def md_to_pm(text)
  text
    .gsub(/(^|\s)\*\*(.*?)\*\*/, "'''\\2'''")
    .gsub(/^\* /, "*")
    .gsub(/\[(.*?)\]\((.*?)\)/, "[[\\2|\\1]]")
    .gsub(/^(\s+)\* /) { |t| len = $1.length; "*"*len }
    .gsub(/^(#+) (.*)\n+/) { |t| len = $1.length; "!"*len + $2 + "\n" }
    .gsub(/(^|\s)_(.*?)_/, "\\1''\\2''")
    .gsub(/^\d+\. /, "#")
    .gsub(/^(\s+)\d+\. /) { |t| len = $1.length; "#"*len }
end

def pm_to_md(text)
  text
    .gsub(/^#(#+)/) { |t| len = $1.length; "  "*len + "1. " }
    .gsub(/^#/, "1. ")
    .gsub(/^\*(\*+)/) { |t| len = $1.length; "  "*len + "* " }
    .gsub(/^\*/, "* ")
    .gsub(/\[\[(.*?)\|(.*?)\]\]/, "[\\2](\\1)")
    .gsub(/^(\!+)(.*)\n+/) { |t| len = $1.length; "#"*len + " " + $2 + "\n\n" }
    .gsub(/'''(.*?)'''/, "**\\1**")
    .gsub(/''(.*?)''/, "_\\1_")
end
