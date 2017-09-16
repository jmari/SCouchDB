as yet unclassified
renderItemsEventOn:evently
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