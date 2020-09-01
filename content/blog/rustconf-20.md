---
title: Rustconf 2020
date: 2020-08-27
author: Nick Cameron
tags: ['Rust', 'Community']
---

[Rustconf](https://rustconf.com/) 2020 happened last week (August 20th). For the first time, it was an online conference. Ironically that made it more difficult for me to attend because of timezones (and I was on vacation, so even less inclined to wake up at 4am). So I caught up with the talks earlier this week.

I'll write some short summaries of some of the talks I think will be of interest to the TiKV community. I watched all the talks and I think that there were some great talks that I'm not writing up, that's just because I have limited time and want to keep this post focussed. If you're thinking of watching any of the talks, you definitely should!

If you want to watch, this [playlist](https://www.youtube.com/playlist?list=PL85XCvVPmGQijqvMcMBfYAwExx1eBu1Ei) has them all, or you can watch the whole thing as a [stream](https://www.youtube.com/watch?v=ESXMg9OzWrQ).


## Opening Keynote by the Rust Core team

(Niko Matsakis, Mark Rousskov, Aidan Hobson Sayers, Ashley Williams, and Nick Cameron (me!)).

[Watch](https://www.youtube.com/watch?v=IwPRu5FhfIQ).

Its been five years since Rust 1.0 was released. This talk is a reflection on the values that have driven the project over that time. Spoiler alert: empowerment. We want to empower people to be systems programmers. I think you should watch the talk, I think it is a pretty good summary of what motivates the core team (I may be a little biased).

This talk may be interesting if you want to understand the values driving the Rust project.


## Error handling Isn't All About Errors by Jane Lusby

[Watch](https://www.youtube.com/watch?v=rAF8mLI0naQ).

Error handling is an open question in Rust at the moment. There are lots of libraries to help which do different things, and the choice can be a bit overwhelming. Jane is the author of one of those libraries, Eyre. Jane does a good job of explaining why error handling is a surprisingly large and difficult topic, and gives a good summary/survey of Rust's built-in error handling features and the various libraries which are available (including Eyre, in more detail).

This talk may be interesting if you are thinking about errors for a library, or you ever write code which causes or catches errors.


## How to Start a Solo Project that You'll Stick With by Harrison Bachrach

[Watch](https://www.youtube.com/watch?v=yv6L_xmjw5I).

This talk is (IMO) a bit more general than its title suggests. It is a good discussion of techniques for motivation for any kind of work, not just solo projects. Some of the points I found interesting are:

* making projects into habits,
* choose a satisfying project (and how to make a project more satisfying),
* setting SMART goals,
* extrinsic rewards diminish intrinsic motivation.

This talk may be interesting if you want to better motivate yourself to get things done, including side projects.


## Under a Microscope: Exploring Fast and Safe Rust for Biology by Samuel Lim

[Watch](https://www.youtube.com/watch?v=2b8InauuRqw).

Samuel gives a taste of how Rust can be used for science. Though not directly relevant to my work I found it really interesting.

This talk may be interesting if you want to see Rust being used outside its usual domains.

## Bending the Curve: A Personal Tutor at Your Fingertips by Esteban Kuber

[Watch](https://www.youtube.com/watch?v=Z6X7Ada0ugE).

Esteban has done really, really great work with the Rust compiler's error messages. Rust has some of the best error messages of any language, and that is largely thanks to Esteban.

Esteban's talk is about his philosophy and motivation for improving error messages. To sum that up in a sentence: think about them from the user's perspective. That of course requires understanding your user.

This talk may be interesting if you are curious about rustc's error messages.

## Macros for a More Productive Rust by jam1garner

[Watch](https://www.youtube.com/watch?v=dZiWkbnaQe8).

This talk is a really good introduction to Rust macros - how to write them and how to write them well.

This talk may be interesting if you want to write or use macros.


## Closing Keynote by Siân Griffin

[Watch](https://www.youtube.com/watch?v=RNsEsZbXE-4).

So, I was not expecting this talk to be like this. Siân is well-known for the Diesel framework and is a very active member of the crates.io team. This talk is not about any of those things. It is a deep dive into a glitch in the original Gameboy Pokémon games. Even if you're not really interested in Pokémon or computer games, this is an engrossing talk. Siân presents a very technical, specialist topic in a clear and really fun way.

This talk may be interesting if you have even a passing interest in tech.
