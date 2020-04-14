# The TiKV website

This repo houses the assets used to build the [TiKV](https://github.com/tikv/tikv) website available at https://tikv.org.

## Publishing

The site is published automatically by [Netlify](https://netlify.com) whenever changes are pushed to the `master` branch. You do not need to manually publish or manage the site deployment.

## Running the site locally

To run the site locally, you'll need to install [Yarn](https://yarnpkg.com) and [Hugo](https://gohugo.io) (in particular the [extended](https://gohugo.io/getting-started/installing/) version).

You can then host the development server for the site with:

```bash
make serve
```

Next, browse to [http://localhost:1313/](http://localhost:1313/).

Alternatively you can use the provided `Dockerfile` via:

```bash
make docker
```

> If you're using Docker for Mac or Windows, you may need to browse to the correct address, or set up port forwarding `1313`. On Linux or [WSL2 with Docker](https://hoverbear.org/blog/getting-the-most-out-of-wsl/#get-systemd-functional) you can visit [http://localhost:1313/](http://localhost:1313/).

## Adding blog posts

To add a new blog post, add a Markdown file to the `content/blog` folder. There's currently a `first-post.md` file in that directory that can serve as a template.
