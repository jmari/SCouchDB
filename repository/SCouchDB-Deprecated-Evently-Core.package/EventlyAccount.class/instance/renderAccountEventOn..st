as yet unclassified
renderAccountEventOn:evently

(evently at:'account')  onEvent:'_init' do:
'function() {
  var elem = $(this);
  $$(this).userCtx = null;
  $.couch.session({
    success : function(r) {
      var userCtx = r.userCtx;
      if (userCtx.name) {
        elem.trigger("loggedIn", [r]);
      } else if (userCtx.roles.indexOf("_admin") != -1) {
        elem.trigger("adminParty");
      } else {
        elem.trigger("loggedOut");
      };
    }
  });
}' ;
onEvent:'adminParty' mustache:
'<p><strong>Admin party, everyone is admin!</strong> Fix this in <a href="/_utils/index.html">Futon</a> before proceeding.</p>';

onEvent:'doLogin' do:
'function(e, name, pass) {
  var elem = $(this);
  $.couch.login({
    name : name,
    password : pass,
    success : function(r) {
      elem.trigger("_init")
    }
  });      
}';
onEvent:'doLogout' do:
'function() {
  var elem = $(this);
  $.couch.logout({
    success : function() {
      elem.trigger("_init");
    }
  });
}';
onEvent:'doSignup' do:
'function(e, name, pass) {
  var elem = $(this);
  $.couch.signup({
    name : name
  }, pass, {
    success : function() {
      elem.trigger("doLogin", [name, pass]);
    }
  });
}'.