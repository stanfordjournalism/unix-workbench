# Automating with cron

The Unix [cron](https://en.wikipedia.org/wiki/Cron) utility provides a way to automate tasks on Linux and Mac.

Such tasks, known as **cron jobs**, can invoke individual Unix commands as well as shell scripts written in Bash, Python or any other language installed on the system.

Imporant details on how to use cron are below.

--

- [Scheduling](#scheduling)
- [Logging output](#logging-output)
- [Good habits](#good-habits)
- [Debugging](#debugging)

## Scheduling

Cron provides a flexible means for scheduling jobs
at regular intervals:

```
# Every minute 
* * * * *  /bin/date >> /tmp/somefile.log

# Every hour, on the hour
0 * * * * /bin/date >> /tmp/somefile.log

# Every 15 minutes
0,15,30,45 * * * * /bin/date >> /tmp/somefile.log

# 11am every Sunday (Sunday is 0 to Saturday = 6)
0 11 * * 0 /bin/date >> /tmp/somefile.log
```

## Logging output

You can use simple shell redirection to pipe the output of a script (basically anything inside the script that would normally print to the shell) to an external file.

Here's an example that ovewrites on every run:

```bash
* * * * * /bin/date > /tmp/crontest.txt
```

Here's an example that appends on every run:

```bash
* * * * * /bin/date >> /tmp/crontest.txt
```


## Good habits

_It's important to note that cron is a very limited environment._ It can only "see" programs or files in a limited number of directories (typically only `/bin` and `/usr/bin`).

To minimize headaches, it's a good idea to provide full paths to built-in shell utilities, custom scripts and input/output files and directories. 

> If you run into issues, check out the [debugging](#debugging) section below.

Cron is a more constrained environment than the standard shell. It directories.

You can check by running the following in crontab:

```bash
* * * * * echo $PATH > /tmp/crontest.txt
```


If you're concerned about cron not being able to access Python or R binaries, for example, you can use their full path.

To determine the full path to the executable, run
below in the shell

```bash
which python
```

Then update crontab to something like:

```bash
* * * * * /usr/local/bin/python /path/to/myscript.py
```

## Debugging

If all of the above fails and you need a more precise
sense of what's going wrong, try redirecting messages produced by cron to a separate file.

Below, writes error messages to `error.log`, while sending normal output from your script (if any) to a separate file called `myscript.log`.

```bash
* * * * * /This/is/a/bad/path/R "print('hello world')" > /tmp/myscript.log 2>/tmp/error.log
```