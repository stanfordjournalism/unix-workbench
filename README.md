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

### Homebrew for installs

Note, various commands below may require installation using [Homebrew](https://brew.sh/) on Macs.

Check if you have Homebrew already:

```bash
brew -v
```

If not, install it with:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

You can wrap up your commands into a shell script.

Drop the following commands into a shell script called `do_stuff.sh`

```
#!/bin/bash

date >> /tmp/doing-stuff.txt
```

Run the script by typing:

```bash
sh do_stuff.sh
```

## Automation

You can automate shell scripts or even individual Unix commands by using [cronjobs][], a tool built into Unix machines for scheduling tasks.

Let's automate our `do_stuff.sh` shell script from above.

To create a cronjob, you must edit your user's `crontab` file using `crontab -e`.

This will drop you into the crontab file using the default shell editor. Once you make changes and save, the cronjob will be active.

_It's important to note that cron is a very limited environment._ It can only "see" programs or files in a limited number of directories, so it's a good idea to provide full paths to built-in shell utilities, custom scripts and input/output files and directories.

> You may also need to configure the [PATH](https://en.wikipedia.org/wiki/PATH_(variable)) environment variable in a cron context. See [cronjobs][] for more background and details.

To set up your cronjob, first determine the location of your script:

```bash
pwd
```

Then, in crontab, paste the full path to your script and set it to run every minute. _You'll need to modify the path to `do_stuff.sh` to match the location on your machine!_

```bash
* * * * * /bin/sh /Users/tumgoren/code/unix-workbench/do_stuff.sh
```

After the script runs the first time, you should see the content:

```bash
cat /tmp/doing-stuff.txt
```

To watch as new content is added, you can continuously "tail" the file:

```bash
tail -f /tmp/doing-stuff.txt

# Hit "CTRL c" to exit
```

We can get feedback from our script by piping any logging and errors to a separate file. 

Let's update our cronjob as below:

```bash
* * * * * /bin/sh /Users/tumgoren/code/unix-workbench/do_stuff.sh > /tmp/doing-stuff.log 2>&1
```

Now let's break our script by changing `date` to `dat` in `do_stuff.sh`. This should produce an error that gets sent to our `/tmp/doing-stuff.log`.

After saving the file, wait a minute and then check the content of `/tmp/doing-stuff.log`

```bash
cat /tmp/doing-stuff.log
```

You can "tail" this file continuously once it's created, which can be quite handy when debugging a script:

```bash
tail -f /tmp/doing-stuff.log
```

Lastly, you can disable cronjobs by "commenting them out" with a hash (`#`), as below. Or you can of course delete them. 

Hit `crontab -e` and update as below:

```bash
#* * * * * /bin/sh /Users/tumgoren/code/unix-workbench/do_stuff.sh > /tmp/doing-stuff.log 2>&1
```

## Getting real

Let's work through a more real-world example of creating a shell script and automating it. 

We'll use the [`failed_banks_ca.sh`](fdic/failed_banks_ca.sh) script, which does the following:

- Downloads the FDIC Failed Banks list 
- Ceates a new CSV containing only CA banks
- Prints out the number of failed banks

[Download the script](https://raw.githubusercontent.com/stanfordjournalism/unix-workbench/main/fdic/failed_banks_ca.sh) and try running it:

```bash
sh failed_banks_ca.sh
```

If the script ran correctly, you should see two new files: `banklist.csv` and `failed_banks_ca.csv`. 

Delete these files:

```bash
rm banklist.csv failed_banks_ca.csv
```

Now, we'll try automating the script by adding the following to crontab:

```bash
# Changing the working directory simplifies things for this example
# NOTE: 
#  - double-arrow redirection appends to log file 
#  - We use FDIC_DIR to make the command more readable

FDIC_DIR=/Users/tumgoren/code/unix-workbench/fdic
* * * * * cd $FDIC_DIR && /bin/sh failed_banks_ca.sh >> /tmp/failed_banks.log 2>&1
```

You should see `banklist.csv` and `failed_banks_ca.csv` in the directory containing the script. And `/tmp/failed_banks.log` should display a message showing the count of failed banks in CA.


## More Power Tools

Here's a smattering of tools and examples that might be useful. 

> See [Power Tools for Data Wrangling](https://github.com/stanfordjournalism/stanford-progj-2021/blob/main/docs/power_tools_for_data_wrangling.md) for more.

### tree

The [tree](https://en.wikipedia.org/wiki/Tree_(command)) lists all directories and files and is quite handy when futzing about on the command line.

> Mac users should `brew intstall tree`

```bash
cd /some/directory
tree 
```

### Mirror a website

[wget](https://www.tutorialspoint.com/unix_commands/wget.htm) is another tool that helps download files. In some ways it resembles `curl`, but it also has some key differentiating features such as the ability to mirror an entire website.

```
wget --mirror https://data-driven.news/bna/2021
cd data-driven.news/
# fire up a local python web server
python -m http.server
```

Go to http://localhost:8000 and view the site.

### Socrata to SQL

[socrata2sql](https://sqlitebrowser.org/) allows you to easily import data sets from Socrata-backed government data sites into databases such as SQLite.

> NOTE: `socrata2sql` only works on Python 3.x

To install:

```bash
pip install socrata2sql
```

List the data sets available on [San Francisco open data portal](https://datasf.org/opendata/).

```bash
socrata2sql ls data.sfgov.org

# Or redirect the list to a file
socrata2sql ls data.sfgov.org > sfdatasets.txt
```

Create a SQLite database of [SF eviction notices](https://data.sfgov.org/Housing-and-Buildings/Eviction-Notices/5cei-gny5).
 
```bash
socrata2sql insert data.sfgov.org 5cei-gny5 
```

Depending on the site and the size of the data, you may need to register for an API key in order to pull the data down.

You can view and query SQLite databases using tools such as [DB Browser](https://sqlitebrowser.org/).

### State metadata

Need state metadata or related GIS files?

Try the Python [us][] library, which ships with a basic command-line utility:

```bash
pip install us
states ca
```

### Farmshare

Stanford offers free VMs in their [Farmshare](https://web.stanford.edu/group/farmshare/cgi-bin/wiki/index.php/Main_Page) cloud for you to experiment with.

You can use `ssh` to connect via "secure shell" to a machine.

```bash
# ssh sunetid@rice.stanford.edu
ssh tumgoren@rice.stanford.edu
```

These Ubuntu Linux VMs offer all the standard bash commands mentioned above.

Beware that you're not guaranteed to end up on the same machine, so installing software can get tricky. You can target a specific VM with a bit of a two-step:

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

These machines are free, but long term, you'll likely want to learn how to set up your own virtual machine in the cloud. 

Both Amazon Web Services and Google Cloud Platform offer free beginner tiers for spinning up virtual machines:

* [AWS EC2](https://aws.amazon.com/ec2/)
* [GCP Compute Engine](https://cloud.google.com/compute/)

### Data wrangling

[csvkit](https://csvkit.readthedocs.io/en/latest/) is a collection of Python utilities that allows you to more easily wrangle data.

Here's an [example script](csvkit_wrangle_budgets.sh) that merges yearly budget files into a single CSV. 

> NOTE: The tool is written in Python and the install can be flaky at times. It's worth the headaches, so reach out if you have trouble installing.


## Reference

- [The Unix Shell](http://swcarpentry.github.io/shell-novice/) - great starter tutorial


[Bash overview]: https://docs.google.com/presentation/d/1jsiTriZTTZxtGse9xia_e36MzJSseX-EUdzEZHrVmaA/edit?usp=sharing
[Bash drill]: https://github.com/stanfordjournalism/stanford-progj-2021/blob/main/exercises/bash_drill.md
[cronjobs]: cronjobs.md
[curl]: https://linuxhandbook.com/curl-command-examples/
[us]: https://github.com/unitedstates/python-us#cli
