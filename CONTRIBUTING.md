# Contributing to TiVK documentation

We welcome contributions to help improve the TiKV documentation!

The TiKV docs are written in Markdown and use the [Google Developer Documentation Style Guide](https://developers.google.com/style/). Don't worry if this is new to you, we are happy to guide you along the way.

Before contributing, make sure that:

- You have logged into your GitHub account.
- You are familiar with the Markdown language used by the documentation.

## How to contribute to Docs

There are a couple of ways you can contribute to TiKV documentation.

### Review open PRs

Even though you might not be assigned as a reviewer, you are welcomed to check our [open pull requests](https://github.com/tikv/website/pulls) (PRs) and provide your reviews for the ones that interest you. Leave your comments and we can take it from there.

### Propose a change

If you spot any issue in the documentation that requires a change, and you feel like you are not ready to do it, feel free to propose a change by [creating an issue](https://github.com/tikv/website/issues). A good issue help us locate the problem quickly and come up with the fix.

### Submit your Own PR

If you have a specific idea of a fix or update, and [you have everything ready](#build-the-documentation-locally), follow these steps below to submit a PR:

1. **Fork the repository**, and then clone it to your local:

    ```bash
    $ git clone git@github.com:$GITHUB_USER/tikv/website.git
    $ cd website
    ```

2. Add the original repository as the `upstream` remote end:

    ```bash
    $ cd website
    $ git remote add upstream git@github.com:tikv/tikv.git
    $ git remote -v
    origin	git@github.com:$GITHUB_USER/website.git (fetch)
    origin	git@github.com:$GITHUB_USER/website.git (push)
    upstream  git@github.com:tikv/website.git (fetch)
    upstream  git@github.com:tikv/website.git (push)
    ```

3. Get your local master up-to-date with upstream/master and create your topic branch off the master:

    ```bash
    $ git fetch upstream
    $ git checkout master
    $ git rebase upstream/master
    $ git checkout -b new-branch-name
    ```

4. Make changes, save them, add, and finally commit them:

    ```bash
    $ git add $FILES
    $ git commit -s -v
    ```

    > **Note:** Our repository requires a DCO (Developer Certificate of Origin) for each commit. For more information see <https://github.com/probot/dco#how-it-works>. Forgot the DCO? Fix it with [this guide](https://github.com/src-d/guide/blob/master/developer-community/fix-DCO.md).

5. Push your changes to the remote:

    ```bash
    $ git push -u origin new-branch-name
    ```

6. Create a pull request

    Visit your fork in your browser, and click the **Compare & pull request** button next to your `new-branch-name` branch, and write a description of the pull request based on the template.

By now you have finished the general procedure of submitting a PR. Congratulations! The maintainers will carefully review your work within a day or two and let you know about any further required changes.

## Build the documentation locally

Our documentation and website is generated based on HUGO framework. If you want to test any changes that you made locally before submitting them as a PR, follow the steps below:

1. Install Hugo, Git, and Node Package Manager (NPM). For most common operating systems:

    ```bash
    # Ubuntu
    $ apt install npm hugo git
    # Mac
    $ brew install hugo node git
    # Windows (with https://scoop.sh/)
    $ scoop install nodejs hugo-extended git
    ```

2. Then in the `website` directory run `npm install` to install the required dependencies in the target folder.

    ```bash
    $ cd website
    $ npm install
    ```

3. in the `website` directory, run `make`. When the site generation is complete, you can get your local preview URL in the output, for example:

    ```bash
    $ make
    # ...
    Web Server is available at http://localhost:1313/ (bind address 0.0.0.0)
    Press Ctrl+C to stop
    ```

4. Point your browser at [localhost:1313](http://localhost:1313/) to preview your changes. If you make further changes, the site is automatically regenerated each time you hit the **Save** button. You can refresh the page to see the new changes. When you finish the preview, press **Ctrl + C** to stop the local server.

## Accomplishing common tasks

There are a few common tasks done on the website. Here are some pointers on how to do them.

### Find which page to edit

Documentation of a TiKV version is located under `content/docs/$VERSION`, where `$VERSION` is the major version. It's easiest to locate the page by navigating to the correct TiKV.org URL, like `https://tikv.org/docs/3.0/tasks/configure/security/`, and reading the components. In this case, the correct file to edit would be in `content/docs/3.0/tasks/configure/security/`.

If you are looking for specific content to update, for example you want to update documentation about the `ca-path` option, you can use a tool like `ag`, `grep`, or [`ripgrep`](https://github.com/BurntSushi/ripgrep#installation) to help find the correct files to edit:

```bash
$ rg "ca-path"
# ...
content\docs\3.0\reference\tools\tikv-ctl.md
23:    $ tikv-ctl --ca-path ca.pem --cert-path client.pem --key-path client-key.pem --host 127.0.0.1:21060 <subcommands>

content\docs\3.0\tasks\configure\security.md
38:ca-path = "/path/to/ca.pem"
97:    --ca-path   "/path/to/ca.pem"
# ...
```

### Add a page or section

We try to follow the ideas of 'Concepts', 'Tasks', and 'Reference' pages for our versioned documentation.

- **Concepts:** Explain high level concepts, background, and give context. Eg. "What are the components of TiKV?"
- **Tasks:** Explain how to perform a specific procedure. Eg. "How to configure TLS in TiKV?"
- **Reference:** Detailed lists, facts, or configuration info. Eg. "Storage options in TiKV"

If you're confused about where to place a page or section, just write it and we'll figure out where it fits best.

If you create a new page, you'll need to copy the metadata from an existing page. It looks like this:

```yaml
---
title: My Title
description: My description
menu:
    docs:
        parent: Tasks
        weight: 5     # Configure position
---
```

If your new page has the same name as an existing file, you need to rename it, or you'll receive an error when building the website.

### Use shortcodes

To use admonitions like a `warning` or `info` panel in the text, use shortcodes, which is a simple snippet inside a content file that Hugo will render using a predefined template, as shown below.  In the `/layouts/shortcodes/` folder, you can find a number of small 'custom elements', where you can add your custom shortcodes.

```markdown
{{< warning >}}
Content of the warning
{{</ warning >}}
```

### Add a blog

Create a file in `content/blog/` with the metadata updated accordingly:

```yaml
---
title: The title of the post
date: 2019-05-21
author: The author
---
```

### Adding an adopter

Add the adopter to `data/adopters.yaml` using the format of existing datums.