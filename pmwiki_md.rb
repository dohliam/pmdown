#!/usr/bin/env ruby

# convert Markdown (.md) files to PmWiki (.pmwiki) format

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

filename = ARGF
if !filename
  abort("Please specify a file to convert.")
elsif !File.exist?(filename)
  abort("Specified file does not exist.")
end

# md_file = File.read(filename)
md_file = filename.read

# puts md_to_pm(md_file)
puts pm_to_md(md_file)
