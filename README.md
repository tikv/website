# The TiKV website

This repo houses the assets used to build the [TiKV](https://github.com/tikv/tikv) website available at https://tikv.org.

## Publishing

The site is published automatically by [Netlify](https://netlify.com) whenever changes are pushed to the `master` branch. You do not need to manually publish or manage the site deployment.

## Running the site locally

To run the site locally, you'll need to install [Yarn](https://yarnpkg.com) and [Hugo](https://gohugo.io) (in particular the [extended](https://gohugo.io/getting-started/installing/) version).

You can alternatively use the provided `Dockerfile` via:

```bash
docker build -t tikv/website .
docker run -it --rm -p 1313:1313 -v `pwd`:/home/builder/build tikv/website
```

Or simpler, if you have [Docker Compose](https://docs.docker.com/compose/) installed:

```bash
docker-compose up
```

## Adding blog posts

To add a new blog post, add a Markdown file to the `content/blog` folder. There's currently a `first-post.md` file in that directory that can serve as a template.
