# [reel time](https://kfrn.github.io/reel-time)

#### _calculate the duration of your open-reel audio_

### About

The duration of open-reel audio depends on several variables, and as such, is not straightforward to calculate! **reel time** is here to help with that.

Input the characteristics of your audio tapes—audio config, tape thickness, recording speed, and quantity—to determine their duration.

**reel time** is multilingual:  
🇫🇷 Disponible aussi en français!  
🇮🇹 Disponibile anche in italiano!  
🇩🇪 Auch auf Deutsch verfügbar!

**reel time** is inspired by open-source preservation tools like [ffmprovisr](https://amiaopensource.github.io/ffmprovisr/), [Cable Bible](https://amiaopensource.github.io/cable-bible/), and [SourceCaster](https://datapraxis.github.io/sourcecaster/), and of course also the [Open Reel Audio Duration Calculator](https://www.avpreserve.com/open-reel-audio-duration-calculator/) spreadsheet by Joshua Ranger of [AVPreserve](https://www.avpreserve.com/).

Suggestions and contributions are welcome! I'm happy to receive feature requests, bug reports, code changes, translations, general comments, etc. You can submit a github issue (or pull request), or [email me](mailto:kfnagels@gmail.com) directly.

### Local setup

Dependencies:
* [Elm `0.19`](https://guide.elm-lang.org/install.html)
* [`nvm` (Node version manager)](https://github.com/nvm-sh/nvm#installing-and-updating)

To run locally:
```bash
git clone git@github.com:kfrn/reel-time.git
cd reel-time/

# Install dependencies
nvm install  # Will also install npm
npm install -g create-elm-app
npm install

elm-app start
```

To run tests:
```bash
elm-app test
```

<!-- To deploy to github pages:
```bash
npm install -g gh-pages  # If not already installed

elm-app build
gh-pages -d build
``` -->

### Acknowledgements

This web app was scaffolded using [`create-elm-app`](https://www.npmjs.com/package/create-elm-app) and styled with assistance from [Bulma](https://bulma.io/).

Thank you for encouragement and feedback:
- [Ashley Blewer](https://github.com/ablwr)
- [Kieran O'Leary](https://github.com/kieranjol)
- [Reto Kromer](https://github.com/retokromer)
- [Andrew Weaver](https://github.com/privatezero)
- [Dave Rice](https://github.com/dericed)

And thank you for contributions from:
- Reto: translation help
- [Corey Bailey](http://www.baileyzone.net/): info on 3" audio reels and quadraphonic audio
- [Christian Hieke](https://github.com/ingk): German translation.
