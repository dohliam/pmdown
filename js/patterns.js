function replacementsOpt1(text) {
  output = text
  .replace(/(^|\s)\*\*_([^\*]+)_\*\*/g, "$1'''''$2'''''")
  .replace(/(^|\s)\*\*([^\*]+)\*\*/g, "$1'''$2'''")
  .replace(/^\* /gm, "*")
  .replace(/\[(.*?)\]\((.*?)\)/gm, "[[$2|$1]]")
  .replace(/^(#+)\s+(.*)\n+/gm, function (match, p1, p2) {
    return repeatString("!", p1.length) + p2 + "\n";
  })
  .replace(/^(\s+)\*\s+/gm, function (match) {
    return repeatString("*", match.length / 2);
  })
  .replace(/\b_([^_]+)_\b/g, "''$1''")
  .replace(/^\d+\. /gm, "#")
  .replace(/^(\s+)\d+\. /gm, function (match, p1) {
    return repeatString("#", p1.length / 2 + 1);
  })

  return output;
}

function replacementsOpt2(text) {
  output = text
    .replace(/^#(#+)/gm, function(match) {
      return repeatString("  ", match.length / 2) + "1. ";
    })
    .replace(/^#/gm, "1. ")
    .replace(/^\*(\*+)/gm, function(match) {
      return repeatString("  ", match.length / 2) + "* ";
    })
    .replace(/^\*/gm, "* ")
    .replace(/\[\[(.*?)\|(.*?)\]\]/g, "[$2]($1)")
    .replace(/^(\!+)(.*)\n+/gm, function(match, p1, p2) {
      return repeatString("#", p1.length) + " " + p2 + "\n\n";
    })
    .replace(/'''''(.*?)'''''/g, "**_$1_**")
    .replace(/'''(.*?)'''/g, "**$1**")
    .replace(/''(.*?)''/g, "_$1_");

  return output;
}

function repeatString(string, num) {
  collector = "";
  for (var i = 0; i < num; i++) { 
    collector += string;
  }
  return collector;
}

function demoText() {
  inputBox = window.text_input;
  options = window.option.value;
  text = "# Heading 1\n\nThis is some text. **Bold text**. _Italic text_.\n\n[This is a link](https://example.com)\n\n## Heading 2\n\n* First point\n* Second point\n  * Indented point 1\n  * Indented point 2\n* Third point\n  * Indent level 1\n    * Indent level 2\n      * Indent level 3\n\n1. First list item\n2. Second list item\n  1. Indented list item 1\n  2. Indented list item 2\n3. Third list item\n  1. Indented list level 1\n    1. Indented list level 2\n      1. Indented list level 3\n\n## Heading 3\n\nEnd of demo.\n"

  if (options == "option2") {
    text = replacementsOpt1(text);
  }

  inputBox.value = text;
}
