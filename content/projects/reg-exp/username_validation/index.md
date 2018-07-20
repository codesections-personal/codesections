+++
date = 2018-06-03T14:26:44-04:00
+++

<div class="content-wrapper">
<section class="page-header">
<h1 class="page-title">RegEx Game</h1>
<div class="page-discription">
  <h2 class="page-discription__title">Username Validation</h2>
  <p class="page-discription__details">Determine whether a given username is valid according to the following restrictions: A username has to be between 6 and 10 characters and can only contain alphanumeric characters and '_'!</p>
  <p class="page-discription__details"><strong>Note:</strong> In production environments, having a maximum length for a password is a very bad practice.</p>
</div>
<a href="..">
  <div class="button button--back">Back
  </div>
</a>

</section>
<section class="regex-input">
<span class="regex-input__boarder">/</span>
<input class="regex-solution" type="text" placeholder="RegEx solution…"> 
<span class="regex-input__boarder">/</span>
  
<div class="result-msg">Make all words turn green to complete the challenge</div>
<section class="desired-output">
<div class="should-match desired-output__title">
  Should match
  <div class="should-match-string">myname</div>
  <div class="should-match-string">ingikim</div>
  <div class="should-match-string">ingi_kim</div>
  <div class="should-match-string">alpha123</div>
</div>

<div class="should-not-match desired-output__title">Should <strong>not</strong> match
  <div class="should-not-match-string">myreallylongname</div>
  <div class="should-not-match-string">@symbol</div>
  <div class="should-not-match-string">ingi-kim</div>
  <div class="should-not-match-string">name</div>
  <div class="should-not-match-string">jfah&amp;kf</div>
</div>
</section>
</section></div>
