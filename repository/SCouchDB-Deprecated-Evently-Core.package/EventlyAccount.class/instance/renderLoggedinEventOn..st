as yet unclassified
renderLoggedinEventOn: evently
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
