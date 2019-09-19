# The TiKV website

This repo houses the assets used to build the [TiKV](https://github.com/tikv/tikv) website available at https://tikv.org.

## Publishing

The site is published automatically by [Netlify](https://netlify.com) whenever changes are pushed to the `master` branch. You do not need to manually publish or manage the site deployment.

## Running the site locally

To run the site locally, you'll need to install [Yarn](https://yarnpkg.com) and [Hugo](https://gohugo.io) (in particular the [extended](https://gohugo.io/getting-started/installing/) version).

You can alternatively use the provided `Dockerfile` via:

```bash
$ make docker-image
$ make docker-serve
```

If the locally website is running, the below message should be show.
```markdown
docker run --rm --interactive --tty --volume `pwd`:/home/builder/build -p 13131:13131 tikv-website sh -c "yarn && make serve-production"
yarn install v1.16.0
[1/4] Resolving packages...
success Already up-to-date.
Done in 0.14s.
hugo server \
	--disableFastRender \
	--buildFuture \
	--bind 0.0.0.0
Building sites … WARN 2019/09/19 00:48:43 found no layout file for "HTML" for "section": You should create a template file which matches Hugo Layouts Lookup Rules for this combination.
WARN 2019/09/19 00:48:43 found no layout file for "HTML" for "section": You should create a template file which matches Hugo Layouts Lookup Rules for this combination.

                   | EN  
+------------------+----+
  Pages            | 86  
  Paginator pages  |  0  
  Non-page files   |  0  
  Static files     | 53  
  Processed images |  0  
  Aliases          |  0  
  Sitemaps         |  1  
  Cleaned          |  0  

Total in 430 ms
Watching for changes in /home/builder/build/{assets,content,data,layouts,static}
Watching for config changes in /home/builder/build/config.yaml
Environment: "development"
Serving pages from memory
Web Server is available at http://localhost:1313/ (bind address 0.0.0.0)
Press Ctrl+C to stop
```

## Adding blog posts

To add a new blog post, add a Markdown file to the `content/blog` folder. There's currently a `first-post.md` file in that directory that can serve as a template.
