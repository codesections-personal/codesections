+++
title = "RegExperiment"
template = "projects.html"
+++
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
  <h1 class="page-title page-header page-header__home">RegEx Game</h1>
  <table class="list-of-questions">
    <tbody><tr class="list-of-questions__row">
      <td class="list-of-questions__item"><strong>Capital Words</strong></td>
      <td class="list-of-questions__item">Validate whether a given string starts with a capital letter</td>
      <td class="list-of-questions__item">
        <a href="capital_words">
          <div class="button">Solve</div>
        </a>
      </td>
    </tr>
    <tr class="list-of-questions__row">
      <td class="list-of-questions__item"><strong>Does a Word Contain One 'a'</strong></td>
      <td class="list-of-questions__item">Validate whether the given word contains one and only one letter 'a'.</td>
      <td class="list-of-questions__item">
        <a href="one_a">
          <div class="button">Solve</div>
        </a>
      </td>
    </tr>
    <tr class="list-of-questions__row">
      <td class="list-of-questions__item"><strong>Find Prices</strong></td>
      <td class="list-of-questions__item">Determine whether the given string is a valid price</td>
      <td class="list-of-questions__item">
        <a href="find_prices">
          <div class="button">Solve</div>
        </a>
      </td>
    </tr>
    <tr class="list-of-questions__row">
      <td class="list-of-questions__item"><strong>Username Validation</strong></td>
      <td class="list-of-questions__item">Determine whether a given username is valid according to the following restrictions: A username has to be between 6 and 10 characters and can only contain alphanumeric characters and '_'!</td>
      <td class="list-of-questions__item">
        <a href="username_validation">
          <div class="button">Solve</div>
        </a>
      </td>
    </tr>
    <tr class="list-of-questions__row">
      <td class="list-of-questions__item"><strong>Hex Color Code</strong></td>
      <td class="list-of-questions__item">Determine whether a given string is valid Hex color code.</td>
      <td class="list-of-questions__item">
        <a href="hex_color_code">
          <div class="button">Solve</div>
        </a>
      </td>
    </tr>
    <tr class="list-of-questions__row">
      <td class="list-of-questions__item"><strong>Valid Number?</strong></td>
      <td class="list-of-questions__item">Match a valid phone number.</td>
      <td class="list-of-questions__item">
        <a href="valid_number">
          <div class="button">Solve</div>
        </a>
      </td>
    </tr>
    <tr class="list-of-questions__row">
      <td class="list-of-questions__item"><strong>Validate Password</strong></td>
      <td class="list-of-questions__item">Validate a password to have the following criteria: 8-16 characters must include: 1 lowercase, 1 uppercase, 1 number only lowercase, uppercase, and numbers are valid</td>
      <td class="list-of-questions__item">
        <a href="validate_password">
          <div class="button">Solve</div>
        </a>
      </td>
    </tr>
  </tbody></table>
</div>
