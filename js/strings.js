function translate_string(lang) {
  strings = document.getElementsByClassName("tr-string");
  for (var i = 0; i < strings.length; i++) {
    current = strings[i];
    string_id = current.dataset.tr;
    text = current.textContent;
    replace_string = lang_strings[lang][string_id];
    if (current.placeholder) {
      current.placeholder = replace_string;
    } else {
      current.innerHTML = replace_string;
    }
  }
}

var lang_strings = {
  "en": {
    "title": "Markdown to PmWiki Converter",
    "intro": "This is a tool for converting Markdown text into PmWiki format.",
    "demo_btn": "Demo",
    "convert_btn": "Convert",
    "m2p": "Markdown to PmWiki",
    "p2m": "PmWiki to Markdown",
    "view": "View this project on <a href=\"https://github.com/dohliam/pmwiki-md-converter\">Github</a>.",
    "text_input": "Input",
    "text_output": "Output"
  },
  "zhs": {
    "title": "Markdown 至 PmWiki 转换器",
    "intro": "这是一个转换Markdown格式文本至Pmwiki的小转换工具。",
    "demo_btn": "展示",
    "convert_btn": "转换",
    "m2p": "Markdown 至 PmWiki",
    "p2m": "PmWiki 至 Markdown",
    "view": "在 <a href=\"https://github.com/dohliam/pmwiki-md-converter\">Github</a> 上检视本项目。",
    "text_input": "输入",
    "text_output": "输出"
  },
  "zht": {
    "title": "Markdown 至 PmWiki 轉換器",
    "intro": "這是一個轉換Markdown格式文本至Pmwiki的小轉換工具。",
    "demo_btn": "展示",
    "convert_btn": "轉換",
    "m2p": "Markdown 至 PmWiki",
    "p2m": "PmWiki 至 Markdown",
    "view": "在 <a href=\"https://github.com/dohliam/pmwiki-md-converter\">Github</a> 上檢視本項目。",
    "text_input": "輸入",
    "text_output": "輸出"
  }
};
