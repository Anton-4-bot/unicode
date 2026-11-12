platform ""
	requires {
		main! : List(Str) => Try({}, [Exit(I32), ..])
	}
	exposes [Locale]
	packages {}
	provides { "roc_main": main_for_host! }
	hosted {
		"hosted_locale_all": Host.locale_all!,
		"hosted_locale_get": Host.locale_get!,
	}
	targets: {
		inputs_dir: "targets/",
		x64mac: { inputs: ["libhost.a", app] },
		arm64mac: { inputs: ["libhost.a", app] },
		x64win: { inputs: ["host.lib", app] },
		x64musl: { inputs: ["rcrt1.o", "libhost.a", app, "libc.a"] },
		arm64musl: { inputs: ["rcrt1.o", "libhost.a", app, "libc.a"] },
	}

import Host
import Locale

main_for_host! : List(Str) => I32
main_for_host! = |args|
	match main!(args) {
		Ok({}) => 0
		Err(Exit(code)) => code
		Err(_) => 1
	}
