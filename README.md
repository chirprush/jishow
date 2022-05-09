# Jishow (字show)

Jishow is a small little application that lets you browse through some kanji.

## Dependencies

Firstly, you'll need the [`love2d`](https://love2d.org/) game engine for the graphics. Another optional dependency is is the pip library `grequests` if you want to regenerate the dictionary by running `get_kanji.py`, although this probably won't be necessary.

## Why?

I thought this would be a fun little weekend project, and this was also a good way to get a bit more familiar with `lua` and the `love2d` game engine itself.

## Credit

This project was massively helped out by https://kanjiapi.dev/ and their api for kanji. Originally, I intended to send a request for each new slide generated, but it was far too cumbersome. For this reason, I made a small little script to generate a dictionary from their api and convert it to a lua table (I guess I could have just downloaded a dictionary, but where's the fun in that?).
