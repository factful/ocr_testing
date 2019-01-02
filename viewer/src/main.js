import App from './App.html';

import contents from './contents.js'

const app = new App({
	target: document.body,
	data: {
		name: 'world',
		pages: Object.entries(contents).map( (row)=>{ return row; } )
	}
});

export default app;