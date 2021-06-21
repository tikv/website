yarn: 
	yarn

serve: yarn
	hugo server \
		--buildDrafts \
		--buildFuture \
		--disableFastRender \
		--bind 0.0.0.0

serve-production: yarn
	hugo server \
		--disableFastRender \
		--buildFuture \
		--bind 0.0.0.0

production-build: yarn
	hugo --minify \
		--buildFuture

preview-build: yarn
	hugo \
		--buildDrafts \
		--buildFuture \
		--baseURL $(DEPLOY_PRIME_URL) \
		--minify

docker:
	docker build -t tikv/website .
	docker run -it --rm -p 1313:1313 -v `pwd`:/home/builder/build tikv/website