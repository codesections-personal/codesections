document.querySelector('.regex-solution').addEventListener('input', () => {
  let result = 'Sorry, please try again';
  document.querySelector('.should-match-string').style.color = '';
  const regexSearch = RegExp(document.querySelector('.regex-solution').value);
  //
  // Put this in try/catch block because invalid regex patterns aren't errors
  document.querySelectorAll('.should-match-string').forEach((span) => {
    if (regexSearch && regexSearch.test(span.innerHTML)) {
      span.style.color = 'green';
      span.dataset.regexSuccess = 'yes';
    } else {
      span.style.color = 'red';
      span.dataset.regexSuccess = 'no';
    }
  });


  document.querySelectorAll('.should-not-match-string').forEach((span) => {
    if (regexSearch && regexSearch.test(span.innerHTML)) {
      span.style.color = 'red';
      span.dataset.regexSuccess = 'no';
    } else {
      span.style.color = 'green';
      span.dataset.regexSuccess = 'yes';
    }
  });

  if (document.querySelectorAll('[data-regex-success=no]').length === 0) {
    result = 'All patterns matched!';
  }
  document.querySelector('.result-msg').innerHTML = result;
});
