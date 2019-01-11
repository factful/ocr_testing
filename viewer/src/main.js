import App from './App.html';

import contents from './contents.js'
let entries = Object.entries(contents).map( (row)=>{ return row; } )

const app = new App({
	target: document.body,
	data: {
		count: 0,
		name: 'world',
		pages: entries,
		activePage: entries[0][0]
	},
	methods: {
	}
});


export default app;