#!/usr/bin/env ruby

# convert Markdown (.md) files to PmWiki (.pmwiki) format

require_relative 'libpm2md.rb'

filename = ARGF
if !filename
  abort("Please specify a file to convert.")
elsif !File.exist?(filename)
  abort("Specified file does not exist.")
end

md_file = filename.read

# puts md_to_pm(md_file)
puts pm_to_md(md_file)
