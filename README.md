- [Bash overview](#bash-overview)
- [Getting data](#getting-data)
- [Shell scripts](#fdic-example)
- [Automation](#automation)
- [More Power Tools](#more-power-tools)
- [Reference](#reference)

## Bash overview

- [Bash overview][]
- [Bash drill][]

Bash allows you to redirect the output of a command to a file using `>` and `>>`. The former overwrites pre-existing content, the latter *appends* to pre-existing content.

```bash
curl -s http://example.com > some_file.html
```

Bash pipes allow you to feed the output from one command as the input to another command:

```bash
# find the rows with CA in them and 
# pipe to wc to get a count of the matching rows
grep CA state_data.txt | wc -l
```

## Getting data

 Downloading files with [curl][].
  
 > Mac users should run `brew install curl` if they don't have the command


```
# Stash a url in a shell variable
URL=http://example.com

# Download the URL data
# This will print the file contents to the command line
curl $URL

# You can redirect the output to a file
curl $URL > example.html

# Silence metadata info while downloading
# This can be useful in a shell scripting context
curl --silent $URL > example.html # or just use -s

# Or download to an identically named file
# Note the actual file is called index.html
curl -O $URL/index.html
```

## Shell scripts

- Download FDIC failed banks list
- Filter for CA records
- Poduce a new file containing only the CA records


## Automation

Automate a shell script with a cronjob

## More Power Tools

Here's a smattering of tools and examples that might be useful. 

> See [Power Tools for Data Wrangling](https://github.com/stanfordjournalism/stanford-progj-2021/blob/main/docs/power_tools_for_data_wrangling.md) for more.

### tree

`tree` lists all directories and files and is quite handy when futzing about on the command line.


```bash
brew intstall tree
cd /some/directory
tree 
```

### Mirror a website

wget is another tool that helps download files. In some ways it resembles `curl`, but it also has some key differentiating features such as the ability to mirror an entire website.

```
wget --mirror https://data-driven.news/bna/2021
cd data-driven.news/
# fire up a local python web server
python -m http.server
```

Go to http://localhost:8000 and view the site.

### Socrata to SQL

[socrata2sql](https://github.com/stanfordjournalism/stanford-progj-2021/blob/main/docs/power_tools_for_data_wrangling.md#even-more-power-tools) allows you to easily import data sets from Socrata-backed government data sites into a SQLite database.

Here's a one-liner that pulls in SF evictions from the [San Francisco open data portal](https://datasf.org/opendata/).


 
```bash
pip install socrata2sql
socrata2sql insert data.sfgov.org 5cei-gny5 
```

> Note, YMMV with Python 2.x. Try `pip3 install socrata2sql` if the above doesn't work.

Depending on the site and the size of the data, you may need to register for an API key in order to pull the data down.

Also

### State metadata

Need state metadata or related GIS files?

Try the Python [us][] library, which ships with a basic command-line utility:

```bash
pip install us
states ca
```

### Farmshare

Stanford offers free VMs in their [Farmshare](https://web.stanford.edu/group/farmshare/cgi-bin/wiki/index.php/Main_Page) cloud for you experiment with.

You can use `ssh` to connect via "secure shell" to a machine.

```bash
# ssh sunetid@rice.stanford.edu
ssh tumgoren@rice.stanford.edu
```

Once there all the normal bash commands mentioned above should work.

Beware that you're not guaranteed to end up on the same machine, so installing software can get tricky. You can target a specific with a bit of a two-step:

```bash
# Get the specific machine name
tumgoren@rice03:~$ hostname
rice03
# Quit the machine
exit

# connect to specific machine
ssh tumgoren@rice03.stanford.edu
tumgoren@rice03:~$ hostname
rice03
exit
```

### Data wrangling

csvkit is a collection of Python utilities that allows you to more easily wrangle data.

> NOTE: The tool is written in Python and the install can be flaky at times. It's worth the headaches, so reach out if you have trouble installing.


## Reference

- [The Unix Shell](http://swcarpentry.github.io/shell-novice/) - great starter tutorial


[Bash overview]: https://docs.google.com/presentation/d/1jsiTriZTTZxtGse9xia_e36MzJSseX-EUdzEZHrVmaA/edit?usp=sharing
[Bash drill]: https://github.com/stanfordjournalism/stanford-progj-2021/blob/main/exercises/bash_drill.md
[curl]: https://linuxhandbook.com/curl-command-examples/
[us]: https://github.com/unitedstates/python-us#cli
