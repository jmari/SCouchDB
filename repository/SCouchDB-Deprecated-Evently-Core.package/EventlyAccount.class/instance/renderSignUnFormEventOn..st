as yet unclassified
renderSignUnFormEventOn: evently
(evently at:'account' onEvent:'signupForm')
selector: 'a[href=#login]' onClick:(Array with:'loginForm');
selector: 'form' onSubmit:'function(e) {
 		var name = $(''input[name=name]'', this).val(),
    		pass = $(''input[name=password]'', this).val();              
  		$(this).trigger(''doSignup'', [name, pass]);
  		return false;
	}';
mustache:'<form>
  <label for="name">Name</label> <input type="text" name="name" value="" autocapitalize="off" autocorrect="off">
  <label for="password">Password</label> <input type="password" name="password" value="">
  <input type="submit" value="Signup">
  <a href="#login">or Login</a>
</form>';
onEvent:'after' do:'function() {
  $("input[name=name]", this).focus();
}'
