# WikiContents
Based on [a tweet by @Fuzheado](https://twitter.com/fuzheado/status/1525164874640371713).

Using the [Godot game engine](https://godotengine.org/) and Python.

## Article selection
The scripts in the `Scripts` folder generate a list of potentially interesting articles. By first running `main.py` you can generate a csv file containing a sample of the most common sections on Wikipedia. `find_interesting_pages.py` will then find groups of articles (25 by default) and rank them based on how unique their section headings are compared to the previously generated list (with a weighting favouring more sections over less). The most unique article gets added to the database of articles which can be shown to the player.
