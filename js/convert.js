function single_convert(word, tab) {
  translit = "";
  for (l in word) {
    letter = word[l];
    match = false;
    for (i in tab) {
      if (letter == tab[i].l) {
        translit += tab[i].t;
        match = true;
      }
    }
    if (match == false) {
      translit += letter;
    }
  }
    return translit;
}

function global_convert(word, tab) {
  translit = word.toLowerCase();
  for (i in tab) {
    var re = new RegExp(tab[i].l, "g");
    translit = translit.replace(re, tab[i].t);
  }
  return translit;
}

function convert_button() {
  text = window.text_input.value;
  output = window.text_output;
  options = window.option.value;

  if (options == "option2") {
    output.value = replacementsOpt2(text);
  } else {
    output.value = replacementsOpt1(text);
  }

//   output.value = replacementsOpt1(text);
}
