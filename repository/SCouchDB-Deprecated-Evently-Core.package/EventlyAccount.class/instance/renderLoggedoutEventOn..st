as yet unclassified
renderLoggedoutEventOn: evently
(evently at:'account' onEvent:'loggedOut')
mustache: '<a href="#signup">Signup</a> or <a href="#login">Login</a>';
selector: 'a[href=#signup]' onClick:(Array with:'signupForm');
selector: 'a[href=#login]' onClick:(Array with:'loginForm').

