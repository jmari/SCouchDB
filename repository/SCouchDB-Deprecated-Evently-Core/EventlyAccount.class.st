Class {
	#name : #EventlyAccount,
	#superclass : #SCEvently,
	#category : 'SCouchDB-Deprecated-Evently-Core'
}

{ #category : #'as yet unclassified' }
EventlyAccount >> initialize:size [
	super initialize:size.

	self renderAccountEventOn:self.
	self renderLoggedinEventOn: self.
	self renderLoggedoutEventOn: self.
	self renderLoginFormEventOn:self.
	self renderSignUnFormEventOn:self.
	self renderItemsEventOn:self.
	self renderProfileEventOn:self

]

{ #category : #'as yet unclassified' }
EventlyAccount >> renderAccountEventOn:evently [

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
]

{ #category : #'as yet unclassified' }
EventlyAccount >> renderItemsEventOn:evently [
((evently at:'items' onEvent:'_changes') 
data:'function(data) {
  // $.log(data)
  var p;
  return {
    items : data.rows.map(function(r) {
      p = (r.value && r.value.profile) || {};
      p.message = r.value && r.value.message;
      return p;
    })
  }
};'
mustache:'<p>Customize this format here: <tt>ddoc.evently.items._changes.mustache</tt></p>
<h3>Recent Messages</h3>
<ul>
  {{#items}}
    <li>
      <div class="avatar">
        {{#gravatar_url}}<img src="{{gravatar_url}}" alt="{{name}}"/>{{/gravatar_url}}
        <div class="name">
          {{nickname}}
        </div>
      </div>
      <p>{{message}}</p>
      <div style="clear:left;"></div>
    </li>
  {{/items}}
</ul>
<p><em>Protip:</em> If you setup continuous replication between this database and a remote one, this list will reflect remote changes in near real-time.</p>
<p>This would be a good place to add pagination.</p>')

query view:'recent-items'; descending: true;limit: 50.
]

{ #category : #'as yet unclassified' }
EventlyAccount >> renderLoggedinEventOn: evently [
(evently at:'account' onEvent:'loggedIn')
selector: 'a[href=#logout]' 
onClick:(Array with:'doLogout') ;
data:'function(e, r) {
  return {
    name : r.userCtx.name,
    uri_name : encodeURIComponent(r.userCtx.name),
    auth_db : encodeURIComponent(r.info.authentication_db)
  };
}'
mustache:'<span>Welcome 
<a target="_new" href="/_utils/document.html?{{auth_db}}/org.couchdb.user%3A{{uri_name}}">{{name}}</a>! 
<a href="#logout">Logout?</a>
</span>';
onEvent:'after' do:'function(e, r) {
  $$(this).userCtx = r.userCtx;
  $$(this).info = r.info;
};'.

]

{ #category : #'as yet unclassified' }
EventlyAccount >> renderLoggedoutEventOn: evently [
(evently at:'account' onEvent:'loggedOut')
mustache: '<a href="#signup">Signup</a> or <a href="#login">Login</a>';
selector: 'a[href=#signup]' onClick:(Array with:'signupForm');
selector: 'a[href=#login]' onClick:(Array with:'loginForm').


]

{ #category : #'as yet unclassified' }
EventlyAccount >> renderLoginFormEventOn: evently [
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


]

{ #category : #'as yet unclassified' }
EventlyAccount >> renderProfileEventOn:evently [
((evently at:'profile') onEvent:'loggedIn' do:'function(e, r) {
  	var userCtx = r.userCtx;
  	var widget = $(this);
  	// load the profile from the user doc
  	var db = $.couch.db(r.info.authentication_db);
  	var userDocId = "org.couchdb.user:"+userCtx.name;
  	db.openDoc(userDocId, {
    		success : function(userDoc) {
      		var profile = userDoc["couch.app.profile"];
      		if (profile) {
        		// we copy the name to the profile so it can be used later
        		// without publishing the entire userdoc (roles, pass, etc)
        		profile.name = userDoc.name;
        		$$(widget).profile = profile;
        		widget.trigger("profileReady", [profile]);
      		} else {
        		widget.trigger("noProfile", [userCtx]);
      	}
    	}
  });
}';
onEvent:'loggedOut' mustache:'<p>Please log in to see your profile.</p>')
	onEvent:'after' do:'function() {  $$(this).profile = null;};'.

((evently at:'profile' onEvent:'noProfile')
data:'function(e, userCtx) {
  return userCtx;
}'
mustache:'<form>
  <p>Hello {{name}}, Please setup your user profile.</p>
  <label for="nickname">Nickname 
    <input type="text" name="nickname" value=""></label>
  <label for="email">Email (<em>for <a href="http://gravatar.com">Gravatar</a></em>)
    <input type="text" name="email" value=""></label>
  <label for="url">URL 
    <input type="text" name="url" value=""></label>
  <input type="submit" value="Go &rarr;">
  <input type="hidden" name="userCtxName" value="{{name}}" id="userCtxName">
</form>';
onEvent:'_init')
selector: 'form' onSubmit:'function() {
  var md5 = $$(this).app.require("vendor/couchapp/lib/md5");
  
  // TODO this can be cleaned up with docForm?
  // it still needs the workflow to edit an existing profile
  var name = $("input[name=userCtxName]",this).val();
  var newProfile = {
    rand : Math.random().toString(), 
    nickname : $("input[name=nickname]",this).val(),
    email : $("input[name=email]",this).val(),
    url : $("input[name=url]",this).val()
  }, widget = $(this);

  // setup gravatar_url
  if (md5) {
    newProfile.gravatar_url = ''http://www.gravatar.com/avatar/''+md5.hex(newProfile.email || newProfile.rand)+''.jpg?s=40&d=identicon'';    
  }

  // store the user profile on the user account document
  $.couch.userDb(function(db) {
    var userDocId = "org.couchdb.user:"+name;
    db.openDoc(userDocId, {
      success : function(userDoc) {
        userDoc["couch.app.profile"] = newProfile;
        db.saveDoc(userDoc, {
          success : function() {
            newProfile.name = userDoc.name;
            $$(widget).profile = newProfile;
            widget.trigger("profileReady", [newProfile]);
          }
        });
      }
    });
  });
  return false;
}'.


(((evently at:'profile' onEvent:'profileReady')
data:'function(e, p) {
  return p
}
'
mustache:'<div class="avatar">
  {{#gravatar_url}}<img src="{{gravatar_url}}"/>{{/gravatar_url}}
  <div class="name">
    {{nickname}}
  </div>
</div>
<p>Hello {{nickname}}!</p>
<div style="clear:left;"></div>') 
onEvent:'_init') 
selector: 'form' 
onSubmit: 'function() {
  var form = $(this);
  var fdoc = form.serializeObject();
  fdoc.created_at = new Date();
  fdoc.profile = $$("#profile").profile;
  $$(this).app.db.saveDoc(fdoc, {
    success : function() {
      form[0].reset();
    }
  });
  return false;
};'; onEvent:'after' do:'function(e, p) {
  $$(this).profile = p;
};'



]

{ #category : #'as yet unclassified' }
EventlyAccount >> renderSignUnFormEventOn: evently [
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

]
