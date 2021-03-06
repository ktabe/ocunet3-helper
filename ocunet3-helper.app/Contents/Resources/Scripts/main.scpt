JsOsaDAS1.001.00bplist00�Vscript_0// OCUNET3 helper program for MacOS X
// k-abe

pidfile = '/tmp/.ocunet3-supporter.pid';

app = Application.currentApplication()
app.includeStandardAdditions = true;
finder = Application("Finder");

function run() {
	var appPath = app.pathTo(this);
	var script = Path(`${appPath}/Contents/Resources/Scripts/ocunet3-helper.sh`);
	if (!finder.exists(script)) {
		app.displayNotification(`${script} not found!`, {withTitle: 'Installation Error!'});
	} else {
		var cmdline = `(${script} & echo $!>${pidfile}) >/dev/null 2>&1`;
		// console.log(cmdline);
		app.doShellScript(cmdline, {administratorPrivileges: true});
		app.displayNotification('ocunet3-helper started');
	}
}

function quit() {
	var cmdline = `kill \`cat ${pidfile}\` && rm -f ${pidfile}`;
	app.doShellScript(cmdline, {administratorPrivileges: true});
}                              Fjscr  ��ޭ