# Written by Josh Hartwell
# Borrowed from a lot of places, especially .oh-my-zsh
# Version 3 - 2016/08/20

local ZSH_CONF=$HOME/.zsh                      # Define the place I store all my zsh config stuff
local ZSH_CACHE=$ZSH_CONF/cache                # for storing files like history and zcompdump 
local LOCAL_ZSHRC=$HOME/.zshlocal/.zshrc       # Allow the local machine to have its own overriding zshrc if it wants it

# Load external config files and tools
   source $ZSH_CONF/functions.zsh              # Load misc functions. Done in a seperate file to keep this from getting too long and ugly
   source $ZSH_CONF/spectrum.zsh               # Make nice colors available
   source $ZSH_CONF/prompts.zsh                # Setup our PS1, PS2, etc.
   #source $ZSH_CONF/termsupport.zsh            # Set terminal window title and other terminal-specific things

# Set important shell variables
   export EDITOR=vim                           # Set default editor
   export WORDCHARS=''                         # This is the oh-my-zsh default, I think I'd like it to be a bit different 
   export PAGER=less                           # Set default pager
   export LESS="-R"                            # Set the default options for less 
   export LANG="en_US.UTF-8"                   # I'm not sure who looks at this, but I know it's good to set in general
   export PASSWORD_STORE_DIR=".pass"           # Set the location of the encrypted password store for 'pass'
   export PASSWORD_STORE_CLIP_TIME=30          # Set how long a password clipped to the clipboard with 'pass' lasts
   export LESSHISTFILE="/dev/null"                    # Prevent the less hist file from being made, I don't want it
   export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
   export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Misc
   setopt ZLE                                  # Enable the ZLE line editor, which is default behavior, but to be sure
   declare -U path                             # prevent duplicate entries in path
   #eval $(dircolors $ZSH_CONF/dircolors)       # Uses custom colors for LS, as outlined in dircolors
   umask 002                                   # Default permissions for new files, subract from 777 to understand
   setopt NO_BEEP                              # Disable beeps
   setopt AUTO_CD                              # Sends cd commands without the need for 'cd'
   setopt MULTI_OS                             # Can pipe to mulitple outputs
   unsetopt NO_HUP                             # Kill all child processes when we exit, don't leave them running
   setopt INTERACTIVE_COMMENTS                 # Allows comments in interactive shell.
   setopt RC_EXPAND_PARAM                      # Abc{$cool}efg where $cool is an array surrounds all array variables individually
   unsetopt FLOW_CONTROL                       # Ctrl+S and Ctrl+Q usually disable/enable tty input. This disables those inputs
   setopt LONG_LIST_JOBS                       # List jobs in the long format by default. (I don't know what this does but it sounds good)
   setopt vi                                   # Make the shell act like vi if i hit escape

# ZSH History 
   alias history='fc -fl 1'
   HISTFILE=$ZSH_CACHE/history                 # Keep our home directory neat by keeping the histfile somewhere else
   SAVEHIST=10000                              # Big history
   HISTSIZE=10000                              # Big history
   setopt EXTENDED_HISTORY                     # Include more information about when the command was executed, etc
   setopt APPEND_HISTORY                       # Allow multiple terminal sessions to all append to one zsh command history
   setopt HIST_FIND_NO_DUPS                    # When searching history don't display results already cycled through twice
   setopt HIST_EXPIRE_DUPS_FIRST               # When duplicates are entered, get rid of the duplicates first when we hit $HISTSIZE 
   setopt HIST_IGNORE_SPACE                    # Don't enter commands into history if they start with a space
   setopt HIST_VERIFY                          # makes history substitution commands a bit nicer. I don't fully understand
   setopt SHARE_HISTORY                        # Shares history across multiple zsh sessions, in real time
   setopt HIST_IGNORE_DUPS                     # Do not write events to history that are duplicates of the immediately previous event
   setopt INC_APPEND_HISTORY                   # Add commands to history as they are typed, don't wait until shell exit
   setopt HIST_REDUCE_BLANKS                   # Remove extra blanks from each command line being added to history

# ZSH Auto Completion
   # Figure out the short hostname
   if [[ "$OSTYPE" = darwin* ]]; then          
      # OS X's $HOST changes with dhcp, etc., so use ComputerName if possible.
      SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
   else
      SHORT_HOST=${HOST/.*/}
   fi

   #the auto complete dump is a cache file where ZSH stores its auto complete data, for faster load times
   local ZSH_COMPDUMP="$ZSH_CACHE/acdump-${SHORT_HOST}-${ZSH_VERSION}"  #where to store autocomplete data

   autoload -Uz compinit
   compinit -i -d "${ZSH_COMPDUMP}"                        # Init auto completion; tell where to store autocomplete dump
   zstyle ':completion:*' menu select                      # Have the menu highlight as we cycle through options
   zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'     # Case-insensitive (uppercase from lowercase) completion
   setopt COMPLETE_IN_WORD                                 # Allow completion from within a word/phrase
   setopt ALWAYS_TO_END                                    # When completing from the middle of a word, move cursor to end of word
   setopt MENU_COMPLETE                                    # When using auto-complete, put the first option on the line immediately
   setopt COMPLETE_ALIASES                                 # Turn on completion for aliases as well
   setopt LIST_ROWS_FIRST                                  # Cycle through menus horizontally instead of vertically

# Globbing
   setopt NO_CASE_GLOB                         # Case insensitive globbing
   setopt EXTENDED_GLOB                        # Allow the powerful zsh globbing features, see link:
   # http://www.refining-linux.org/archives/37/ZSH-Gem-2-Extended-globbing-and-expansion/
   setopt NUMERIC_GLOB_SORT                    # Sort globs that expand to numbers numerically, not by letter (i.e. 01 2 03)
   
# Aliases
   alias ll="exa -lah"

# Allow local zsh settings (superseding anything in here) in case I want something specific for certain machines
  if [[ -r $LOCAL_ZSHRC ]]; then
    source $LOCAL_ZSHRC
  fi

# Key bind
   bindkey '^[[1;3C' forward-word
   bindkey '^[[1;3D' backward-word
   bindkey '^R' history-incremental-search-backward   
