# jbyconfig
Linux config files 

### Add to end of ~/.bashrc
```
if [ -f ~/jbyconfig/jby_bashrc.sh ]; then . ~/jbyconfig/jby_bashrc.sh; fi
```
### For TMUX
```
ln -s /home/<user>/jbyconfig/tmux.conf /home/<user>/.tmux.conf
```
