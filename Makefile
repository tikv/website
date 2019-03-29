serve:
	hugo server \
		--buildDrafts \
		--buildFuture \
		--disableFastRender

production-build:
	hugo --minify

preview-build:
	hugo \
		--buildDrafts \
		--buildFuture \
		--baseURL $(DEPLOY_PRIME_URL) \
		--minify
