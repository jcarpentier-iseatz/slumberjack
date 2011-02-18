function swapFormat(link) {
  if ($('#formatted').is(':visible')) {
    $('#formatted').hide();
    $('#unformatted').show();
    $(link).text('Show Formatted');
  } else {
    $('#unformatted').hide();
    $('#formatted').show();
    $(link).text('Show Raw');
  }
}


$(function() {
  SyntaxHighlighter.all();
});