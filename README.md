# [reel time](https://kfrn.github.io/reel-time)

#### _calculate the duration of your open-reel audio_

### About

The duration of open-reel audio depends on several variables, and as such, is not straightforward to calculate! **reel time** is here to help with that.

Input the characteristics of your audio tapes—audio config, tape thickness, recording speed, and quantity—to determine their duration.

**reel time** is multilingual:  
🇫🇷 Disponible en français et italien aussi!  
🇮🇹 Disponibile in italiano et francese anche!

**reel time** is inspired by open-source preservation tools like [ffmprovisr](https://amiaopensource.github.io/ffmprovisr/), [Cable Bible](https://amiaopensource.github.io/cable-bible/), and [SourceCaster](https://datapraxis.github.io/sourcecaster/), and of course also the [Open Reel Audio Duration Calculator](https://www.avpreserve.com/open-reel-audio-duration-calculator/) spreadsheet by Joshua Ranger of [AVPreserve](https://www.avpreserve.com/).

Suggestions and contributions are welcome! I'm happy to receive feature requests, bug reports, code changes, translations, general comments, etc. You can submit a github issue (or pull request), or [email me](mailto:kfnagels@gmail.com) directly.

### Dev notes

Setup:
* [install Elm](https://guide.elm-lang.org/install.html)
* [install Node](https://nodejs.org/en/download/)

To run locally:
```
git clone git@github.com:kfrn/reel-time.git
cd reel-time/
npm install
npm install -g create-elm-app
elm-app start
```

To run tests:
```
elm-app test
```

<!-- To deploy to github pages:
```
elm-app build
gh-pages -d build
``` -->

### Acknowledgements

This web app was scaffolded using [`create-elm-app`](https://www.npmjs.com/package/create-elm-app) and styled with assistance from [Bulma](https://bulma.io/).

Thanks to [Ashley Blewer](https://github.com/ablwr), [Kieran O'Leary](https://github.com/kieranjol), [Reto Kromer](https://github.com/retokromer), [Andrew Weaver](https://github.com/privatezero), and [Dave Rice](https://github.com/dericed) for providing feedback and encouragement!
