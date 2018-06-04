---
date: 2018-06-03T14:26:44-04:00
layout: reg-exp
---

<style>
.list-of-questions__item{
  padding: 8px;
  line-height: 1.42857143;
  vertical-align: top;
  border-top: 1px solid #ddd
}
.list-of-questions__row: hover{
  background-color: #f5f5f5
}
.list-of-questions{
  border-collapse: collapse;
  margin: auto;
  font-size: 1.4rem;
  width: 100%
}
html{
  font-size: 10px;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif
}
.nav-bar{
  font-size: 16px;
}
.footer {
  font-size: 16px;
}
.content-wrapper{
  margin: auto;
  position: relative
}
.page-title{
  font-size: 3em;
  font-weight: normal;
  margin-top: 5rem;
  margin-bottom: 0px
}
.page-discription__details{
  font-size: 1.4em;
  margin-top: 1em;
  text-align: left
}
.page-discription__title{
  margin: auto;
  margin-top: 8rem;
  font-size: 3em;
  font-weight: normal;
  text-align: left
}
.button{
  color: #fff;
  font-size: 1.4rem;
  background-color: #337ab7;
  border-color: #2e6da4;
  border-width: 1px;
  border-radius: 6px;
  padding: 1rem;
  cursor: pointer;
  width: 100px;
  width: fit-content;
  float: right
}
.button--back{
  margin-top: -3em
}
.page-header{
  margin: auto;
  text-align: center
}
.page-header__home{
  margin: 5rem
}
.regex-input{
  margin: auto;
  margin-top: 7em;
  text-align: center
}
.regex-input__boarder{
  font-size: 6em
}
.regex-solution{
  font-size: 1.4em;
  padding: .6em 1.2em;
  margin: 1em;
  width: 25em;
  vertical-align: bottom
}
.result-msg{
  font-size: 1.4em;
  margin-top: 7em;
  font-style: italic
}
.desired-output{
  max-width: 60%;
  margin: auto;
  width: fit-content;
  display: flex;
  font-size: 1.4rem
}
.desired-output__title{
  padding: 1em;
  padding-left: 0;
  font-size: 2.4rem
}
.should-match{
  padding-right: 6em
}
.should-not-match{
  padding-left: 6em
}
.should-match-string,.should-not-match-string{
  padding-top: 1em;
  padding-left: 1em;
  font-size: 1.4rem
}
.should-match-string{
  color: green
}
.should-not-match-string{
  color: red
}


  

  

</style>
  
<div class="content-wrapper">
<section class="page-header">
<h1 class="page-title">RegEx Game</h1>
<div class="page-discription">
  <h2 class="page-discription__title">Find Prices</h2>
  <p class="page-discription__details">Determine whether the given string is a valid price</p>
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
  <div class="should-match-string">$123</div>
  <div class="should-match-string">$0</div>
  <div class="should-match-string">$0.50</div>
  <div class="should-match-string">$99.99</div>
  <div class="should-match-string">$102472349.17</div>
</div>

<div class="should-not-match desired-output__title">Should <strong>not</strong> match
  <div class="should-not-match-string">hello</div>
  <div class="should-not-match-string">123</div>
  <div class="should-not-match-string">$0.577</div>
  <div class="should-not-match-string">$123.4.3</div>
  <div class="should-not-match-string">$823.h</div>
</div>
</section>
</section></div>
