# BUGS:
# - messes up $_

MD5SUM=md5sum
DATE=date

if [ "`uname -s`" == "Darwin" ]; then
	MD5SUM=md5
	DATE=gdate
fi

HOSTNAME_SUM=$(hostname | $MD5SUM | cut -d' ' -f1 | tr a-z A-Z)
LOGIN_COLOR=$(echo "ibase=16; $(echo $HOSTNAME_SUM | head -c8) % 6 + 1" | bc)
DIR_COLOR=$(echo "ibase=16; $(echo $HOSTNAME_SUM | head -c5) % 6 + 1" | bc)

function timer_debug_trap {
	date=$($DATE +%s%N)

	if [ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]; then
		# running before a command
		timer=${timer:-$date}
	else
		# running after a command
		timer=${timer:-$date}
		t_total=${1:-$(( ($date - $timer)/1000000 ))}
		t_h=$(( $t_total/3600000 ))
		t_m=$(( $t_total%3600000/60000 ))
		t_s=$(( $t_total%60000/1000 ))
		t_ms=$(printf %03d $(( $t_total%1000 )))

		if [ $t_h -eq 0 -a $t_m -eq 0 -a $t_s -ne 0 ]; then
			timer_show="${t_s}.${t_ms}s"
		else
			timer_show="${t_h}h${t_m}m${t_s}s${t_ms}ms"
			timer_show=${timer_show#0h}
			timer_show=${timer_show#0m}
			timer_show=${timer_show#0s}
			timer_show=${timer_show#0}
			timer_show=${timer_show#0}
			timer_show=${timer_show#0ms}
		fi
		if [ "$timer_show" != "" ]; then
			timer_show=" $timer_show"
		fi

		unset timer
		unset t_total
		unset t_h
		unset t_m
		unset t_s
		unset t_ms
	fi

	unset date
}

trap 'timer_debug_trap' DEBUG

export PS1='\[\e[0;32m\].--{\[\e[1;31m\]'"\$(if [[ \$? == 0 ]]; then echo \"\[\033[0;32m\]\342\234\223\"; else echo \"\[\033[0;31m\]\342\234\227\"; fi)"'${timer_show}\[\e[0;32m\]}-{\[\e[0;3'$LOGIN_COLOR'm\]\u@\h\[\e[0;32m\]} -- {\[\e[0;3'$DIR_COLOR'm\]\w\[\e[0;32m\]} -- \[\e[0;33m\]$(__git_ps1 "(%s) ")\[\e[0;32m\]--- -\n\[\e[0;32m\]\`-={\[\e[0;36m\]\$ \[\e[0;37;0m\]'

