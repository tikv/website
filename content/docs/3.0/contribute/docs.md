---
title: Improve the Docs
description: How to write documentation for TiKV
menu:
    docs:
        parent: Contribute
        weight: 2
---

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

If you have a specific idea of a fix or update, and you have everything ready (mostly Git environment), follow the steps below to submit a PR:

1. Fork the repository and clone it to your local:
    
    ```bash
    git clone git@github.com:$user/tikv/website.git # Replace "$user" with your GitHub ID
    ```

2. Add the original repository as the `upstream` remote end:

    ```bash
    cd $working_dir/website
    git remote add upstream git@github.com:tikv/tikv.git # Add the upstream repo
    git remote -v # Confirm that your remotes make sense
    ```

    If everything goes right, you will be able to see:
    
    ```bash
    $ git remote -v
    origin	git@github.com:$user/website.git (fetch)
    origin	git@github.com:$user/website.git (push)
    upstream  git@github.com:tikv/website.git (fetch)
    upstream  git@github.com:tikv/website.git (push)
    ```

3. Get your local master up-to-date with upstream/master and create your topic branch off the master:

    ```bash
    git fetch upstream
    git checkout master
    git rebase upstream/master
    git checkout -b new-branch-name
    ```

4. Make changes in your target documentation using the editor of your choice, and save your changes.

5. Commit your changes with a sign-off.

    ```bash
    git add <file> ... # Add the file(s) you want to commit
    git commit -s -m "commit-message: update the xx" # "-s" is used for DCO sign-off, which is required.
    ```

    > **Note:** Our repository requires a DCO (Developer Certificate of Origin) for each commit. For more information see <https://github.com/probot/dco#how-it-works>.

6. Push your changes to the remote:
    
    ```bash
    git push -u origin new-branch-name # "-u" is used to track the remote branch from origin
    ```

7. Create a pull request

    Visit your fork in your browser, and click the **Compare & pull request** button next to your new-branch-name branch, and you will be required to prepare the description of the pull request based on the template.

By now you have finished the general procedure of submitting a PR. Congratulations! The maintainers will carefully review your work within a day or two and let you know about any further required changes.

## Build the documentation locally

Our documentation and website is generated based on HUGO framework. If you want to test any changes that you made locally before submitting them as a PR, follow the steps below:

1. Install Hugo and some dependencies. For example, on a Mac, run:

    ```
    brew update
    brew install hugo
    brew install node
    ```

2. Then in the `website` directory run `npm install` to install the required dependencies in the target folder.

    ```
    cd $working_dir/website
    npm install
    ```

3. in the `website` directory, run `make`. When the site generation is complete, you can get your local preview URL in the output, for example:

    ```
    Web Server is available at http://localhost:1313/ (bind address 0.0.0.0)
    Press Ctrl+C to stop
    ```

4. Point your browser at <http://localhost:1313/> to preview your changes. If you make further changes, the site is automatically regenerated each time you hit the **Save** button. You can refresh the page to see the new changes.
When you finish the preview, press **Ctrl + C** to stop the local server.








