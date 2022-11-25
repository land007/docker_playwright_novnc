const {chromium} = require('playwright');

(async () => {
	const browser = await chromium.launch({
		args: ['--use-fake-ui-for-media-stream', '--use-fake-device-for-media-stream'],
		headless: false
	});
	const context = await browser.newContext({
		permissions: ["camera", "microphone"]
	});
	// Open new page
	const page = await context.newPage();
	// Go to http://127.0.0.1:30117/ascii-video/index.html

	// ---------------------
//	await context.close();
//	await browser.close();å
})();