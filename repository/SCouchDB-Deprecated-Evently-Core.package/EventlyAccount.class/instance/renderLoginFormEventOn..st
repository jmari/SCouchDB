as yet unclassified
renderLoginFormEventOn: evently
(evently at:'account' onEvent:'loginForm')
selector: 'a[href=#signup]' onClick:(Array with:'signupForm');
selector: 'form' onSubmit:'function(e) {
 		var name = $(''input[name=name]'', this).val(),
    		pass = $(''input[name=password]'', this).val();              
  		$(this).trigger(''doLogin'', [name, pass]);
  		return false;
	}';
mustache:'<form>
  <label for="name">Name</label> <input type="text" name="name" value="" autocapitalize="off" autocorrect="off">
  <label for="password">Password</label> <input type="password" name="password" value="">
  <input type="submit" value="Login">
  <a href="#signup">or Signup</a>
</form>';
onEvent:'after' do:'function() {
  $("input[name=name]", this).focus();
}'.

