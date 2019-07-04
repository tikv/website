serve:
	hugo server \
		--buildDrafts \
		--buildFuture \
		--disableFastRender \
		--bind 0.0.0.0

serve-production:
	hugo server \
		--disableFastRender \
		--bind 0.0.0.0

production-build:
	hugo --minify

preview-build:
	hugo \
		--buildDrafts \
		--buildFuture \
		--baseURL $(DEPLOY_PRIME_URL) \
		--minify