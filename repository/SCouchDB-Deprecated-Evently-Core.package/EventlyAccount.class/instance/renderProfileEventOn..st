as yet unclassified
renderProfileEventOn:evently
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


