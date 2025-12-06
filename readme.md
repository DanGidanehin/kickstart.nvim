## NVIM Guide

### Editing a File

`x` - delete character under cursor
`i` - enter editing mode before cursor
`a` - enter editing mode after cursor
`o` - open a line below the cursor and place you in Insert mode
`:w` - save changes made to the file (can use filename to copy this instance of the file to another file like :w TEST)
`wa` - write all files
`:wq` - quit with saving changes
`:qa` - close all nvim windows
`:q!` - quit with discarding all changes made
`:source %` - to reflect changes from current file (restart vim)

### Operators and Motions

The format for a change command is:
`operator  [number]  motion`
where:
operator - is what to do, such as [d](d) for delete
[number] - is an optional count to repeat the motion
motion - moves over the text to operate on, such as:
[w](w) (word),
[$]($) (to the end of line), etc.

`dw` - delete a word
`d$` - delete from the cursor to the end of the line

A short list of motions:
`w` - until the start of the next word, EXCLUDING its first character.
`e` - to the end of the current word, INCLUDING the last character.
`$` - to the end of the line, INCLUDING the last character.

`0` - go to the start of the line
`$` - go to the end of the line

### Words Navigation

`WORD` - ignoring punctuation and jumping into the next word separated by whitespace

`w` - go to the next start of the word
`W` - go to the next start of the WORD
`e` - go to the next end of the word
`E` - go to the next end of the WORD
`b` - go to the previous start of the word
`B` - go to the previous start of the WORD
`ge` - go to the previous end of the word
`gE` - go to the previous end of the WORD

**Typing a number before a motion repeats it that many times.**
`2b` - go to the start of the second previous word from cursor
`3w` - go to the start of the third word from cursor

### Undo and Redo

`u` - single undo
`U` - undo line changes
`ctrl + r` - redo

### The Copy and Put Commands

When using delete command deleted text is copied to the clipboard and to put it somewhere we can use p command
`p` - put the copied text after the cursor
`P` - put the copied text before the cursor
`y` - copy the selected text command
`yw` - copy the word starting from the cursor

### Change and Replace Commands

`rx` - replace the character at the cursor with x
`ce` - change until the end of a word
`cw` - change until the start of a next word
`ciw` - change the whole word no matter where is the cursor
`c$` - change until the end of the line
`R` - replace multiple characters

The format for change is:
`c   [number]   motion`

### Cursor Location and File Status

`ctrl + g` - show location in file and file status
`{count}G` - jump to the specified line
`G` - go to the end of the file
`gg` - go to the start of the file

### Search Command

`/` followed by a phrase - to search for the phrase
`n` - next search result
`N` - previous search result

`ctrl + o` - go back to where you came from
`ctrl + i` - go further to where you came from

### Matching Parentheses Search

`%` - find the matching parentheses

### The Substitute Command

`:s/old/new/` - change the first match of old to new
`:s/old/new/g` - change all matches of old to new in the line
`:s/old/new/G` - change all matches of old to new in the file
To change every occurrence of a character string between two lines, type
`:#,#s/old/new/g`
where # are the line numbers of the range of lines where the substitution is to be done (i.e., `1,3` means from line 1 to line 3, inclusive).
`:%s/old/new/g`
to change every occurrence in the whole file.
`:%s/old/new/gc`
to find every occurrence in the whole file, with a prompt whether to substitute or not.

### Executing External Commands

`:!` - with this command we can execute shell commands
`:!ls` - will show all the files inside current directory

### Selecting Text to Write

Press `v` to enter Visual mode and then extend selection with vim motions

After selecting some text and pressing : you'll se
`:'<, '>`
write w TEST after that and the final command should look like that
`:'<,'>w TEST`
This will write copied text to the TEST file

### Retrieving and Merging Files

`:r FILENAME` - retrieve the content of the file FILENAME

`:r !ls` - reads the output of the ls command and
puts it below the cursor position.

### Set Option

`:set ic` - set ignore case option
`:set hls is` - set the 'hlsearch' and 'incsearch' options
`:set noic` - disable ignore case option
`:set inv{setting}` - to toggle setting
`/{query}\c` - `\c` is used to ignore case for just one search command

`ic ignorecase` ignore upper/lower case when searching
`is incsearch` show partial matches for a search phrase
`hls hlsearch` highlight all matching phrases

### Help

To get help type `:help`
use `ctrl + w` to switch between tabs
type `:q` to close the help window

### Completion

`ctrl + d` - see the commands that starts with your input

### Tabs

`gt` - go to the next tab
`gT` - go to the previous tab
`{N}gt` - jump directly to tab N

`:tabn` - go to **next** tab
`:tabp` - go to **previous** tab
`:tabfirst` - jump to the **first** tab
`:tablast` - jump to the **last** tab
`:tabn {N}` - jump to
`:tabnew` - open a new tab
`:tabedit filename` - open a file in a new tab

### Explorer

`:Explore` - go to the vim explorer
`:e filename` - create file inside current directory
`a` - when pressing a you are creating a file inside selected folder

### Tree Sitter

`:InspectTree` - inspect file tree with parser

## CUSTOM KEYMAPS

### keymaps.lua

`<leader>qr` - Reload Neovim config

`<leader>ya` - Yank entire buffer to clipboard
`<leader>va` - Select entire buffer
`<leader>pa` - Paste clipboard over entire buffer

`<leader>nh` - Clear search highlights
`<leader>oa` - Open file in Arc
`<leader>tw` - Toggle wrap (linebreak/breakindent)

`<leader>sv` - Vertical split
`<leader>sh` - Horizontal split
`<leader>sx` - Close current split

`<leader>hh` - Resize window left
`<leader>ll` - Resize window right
`<leader>kk` - Resize window up
`<leader>jj` - Resize window down

### multigrep.lua

`<leader>fg` - Telescope: Multi Grep
`<C-q>` - Send selected items to quickfix list (inside Telescope)
`:FindReplace <search> <replace>` - Search and replace across all files in the quickfix list

### alpha.lua

`e` - New File
`SPC ee` - Toggle file explorer
`SPC ff` - Find File
`SPC fs` - Find Word
`SPC wr` - Restore Session For Current Directory
`q` - Quit NVIM

### autosession.lua

`<leader>qd` - Delete session and quit

### bufferline.lua

`<leader>bo` - Open new empty buffer
`<leader>bx` - Close current buffer
`<leader>bn` - Go to next buffer
`<leader>bp` - Go to previous buffer
`<leader>b[1-9]` - Go to buffer 1-9
`<leader>b0` - Go to last buffer

### coc.lua

`gd` - Go to Definition
`gy` - Go to Type Definition
`gi` - Go to Implementation
`gr` - Find References
`H` - Show Documentation
`[d` - Previous Diagnostic
`]d` - Next Diagnostic
`<space>dg` - List Diagnostics
`<space>sy` - List Symbols
`<space>ol` - Show Outline
`<leader>cl` - Run Code Lens
`<leader>rn` - Rename Symbol
`<leader>rf` - Refactor Current File
`<leader>ca` - Code Action
`<leader>qf` - Quick Fix

### comment.lua

`<leader>kc` - Toggle line comment
`<leader>kb` - Toggle block comment
`<leader>ko` - Comment line below
`<leader>kO` - Comment line above
`<leader>ke` - Comment end of line

### dap.lua

`<leader>db` - Toggle Breakpoint
`<leader>dB` - Conditional Breakpoint
`<leader>dc` - Start/Continue Debugging
`<leader>di` - Step Into
`<leader>do` - Step Over
`<leader>dO` - Step Out
`<leader>dr` - Restart Debug Session
`<leader>dt` - Terminate Debug Session
`<leader>du` - Toggle Debug UI
`<leader>de` - Evaluate Expression

### floaterminal.lua

`<C-t>` - Toggle floating terminal
`<C-q>` - Hide terminal window
`<C-x>` - Reset floating terminal

### formatting.lua

`<leader>mp` - Format file or range

### harpoon.lua

`<leader>ha` - Mark file
`<leader>hd` - Remove file
`<C-e>` - Toggle Menu
`<leader>[1-8]` - Jump to file 1-8

### lazygit.lua

`<leader>lg` - Open LazyGit UI

### mbbill-undotree.lua

`<leader>uu` - Open/Focus Undotree
`<leader>ux` - Close Undotree
`<CR>` - Revert to selected state
`u` - Revert to selected state
`J` - Move to next undo state
`K` - Move to previous undo state
`q` - Quit Undotree

### nvim-cmp.lua

`<C-k>` - Previous suggestion
`<C-j>` - Next suggestion
`<C-b>` - Scroll documentation back
`<C-f>` - Scroll documentation forward
`<C-Space>` - Show completion suggestions
`<C-e>` - Close completion window
`<CR>` - Confirm selection

### nvim-tree.lua

`<leader>ee` - Focus explorer on current file
`<leader>er` - Refresh file explorer
`<leader>ex` - Close file explorer
`<C-n>` - Create new file in current folder

##### Inside nvim-tree

`<CR>` - Open File or Folder
`h` - Close Folder
`<S-Tab>` - Go Up One Directory
`<Tab>` - Focus Folder as Root
`R` - Refresh
`a` - Create File
`d` - Delete
`r` - Rename
`y` - Copy
`p` - Paste

### spectre.lua

`<C-s>` - Open/focus Spectre (Search/Replace Project)
`<leader>sf` - Search in current file
`<leader>qf` - Clear path (Switch to global search)
`<C-d>` - Close Spectre
`<leader>ic` - Toggle ignore case

##### Inside spectre

`<CR>` - Open file at result
`<leader>R` - Replace all occurrences
`<leader>rc` - Replace current item only
`<leader>o` - Show options menu
`<leader>q` - Send results to Quickfix list
`<leader>v` - Toggle view mode

### surround.lua

`<leader>yS` - Surround current line (Normal mode)
`<leader>ys` - Surround selection (Visual mode)
`<leader>ds` - Delete surrounding pair
`<leader>cs` - Change surrounding pair

### telescope.lua

`<leader>ff` - Fuzzy find files in cwd
`<leader>fr` - Fuzzy find recent files
`<leader>ft` - Find todos
`<leader>fk` - Find keymaps
`<leader>fp` - Find files in Lazy plugins

##### Inside telescope

`<C-k>` - Move selection previous
`<C-j>` - Move selection next
`<C-q>` - Send to quickfix list

### todo-comments.lua

`]t` - Next todo comment
`[t` - Previous todo comment

##### How to add todo-comments

`TODO:` - General task to be done
`FIX:` - Something is broken or needs fixing (also `FIXME`, `BUG`, `FIXIT`, `ISSUE`)
`HACK:` - A workaround or "clever" solution that might need refactoring later
`WARN:` - Warning about code (also `WARNING`, `XXX`)
`PERF:` - Performance related note (also `OPTIM`, `PERFORMANCE`, `OPTIMIZE`)
`NOTE:` - Informational note (also `INFO`)
`TEST:` - Related to testing (also `TESTING`, `PASSED`, `FAILED`)

### treesitter.lua

`<C-space>` - Init selection / Increment node
`<bs>` - Decrement node

### vim-maximizer.lua

`<leader>sm` - Maximize/minimize a split

### yazi.lua

`<leader>yz` - Open Yazi
