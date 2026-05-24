# zsh_greeting_arch
 my custom greeting cli tool to fetch system data and display it, along with configuarable text sections


dependencies :  figlet 
                bc

usage:
1.download the file
2.make it executable using : 
'''
chmod +x ~/zsh_greeting.sh
'''
3.Add the following to the end of .zshrc :
'''
if [[ -f ~/.zsh_greeting.sh && -t 1 ]]; then
    source ~/.zsh_greeting.sh
fi
'''