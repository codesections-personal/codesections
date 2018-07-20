+++
date = 2018-06-03T14:26:44-04:00
+++

<div class="content-wrapper">
<section class="page-header">
<h1 class="page-title">RegEx Game</h1>
<div class="page-discription">
  <h2 class="page-discription__title">Validate Password</h2>
  <p class="page-discription__details">Validate a password to have the following criteria: 8-16 characters must include: 1 lowercase, 1 uppercase, 1 number only lowercase, uppercase, and numbers are valid</p>
  <p class="page-discription__details"><strong>Note:</strong> In a production environment, having a maximum length for a password is a very bad practice, and banning special characters is a bad practice.</p>
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
  <div class="should-match-string">Password1234</div>
  <div class="should-match-string">111xxxYY</div>
  <div class="should-match-string">123456aA</div>
  <div class="should-match-string">fhewoh123EWD</div>
  <div class="should-match-string">12345abcdeFGHIJK</div>
</div>

<div class="should-not-match desired-output__title">Should <strong>not</strong> match
  <div class="should-not-match-string">#Password1234</div>
  <div class="should-not-match-string">12345aA</div>
  <div class="should-not-match-string">no$pesialCharacter5</div>
  <div class="should-not-match-string">paws&amp;*fsB</div>
  <div class="should-not-match-string">ThisIsTooLongOfAPassword</div>
</div>
</section>
</section></div>
