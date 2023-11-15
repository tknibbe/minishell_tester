#!/bin/bash

FOLDER=~/bullshit
if test -e "$FOLDER"; then
	echo "$FOLDER exists! yes baby" > /dev/null
else
	mkdir ~/bullshit
fi

rm lol 2> /dev/null
rm cat 2> /dev/null
rm test 2> /dev/null
rm NONEXISTINGFILE 2> /dev/null
rm test1 2> /dev/null

make -C .. > /dev/null 2> /dev/null


printf "\e[32mWELCOME TO THE TESTER BABY\e[0m\n\n"
printf "\e[32moutput and exit codes are expected to match.\nerror messages may differ so dont take those too serious\e[0m\n\n"
declare -i WRONG=0
err_mini=~/bullshit/err_mini
out_mini=~/bullshit/out_mini
out_bash=~/bullshit/out_bash
err_bash=~/bullshit/err_bash

print_diff () {
	printf "	mini:\n		$(cat -e "$1")\n"
	printf "	bash:\n		$(cat -e "$2")\n"
}

compare_command ()
{
	TEST="$1"
	echo -n "$TEST" | .././minishell 2>$err_mini >$out_mini
	mini_exit="$?"
	echo -n "$TEST" | bash 2>$err_bash >$out_bash
	bash_exit="$?"

	printf "\n\e[36m[$TEST];\e[0m\n"

	if (diff $out_mini $out_bash > /dev/null); then
		printf "Output: \e[32m✔\e[0m\n"
	else
	{
		((WRONG++))
		printf "Output: \e[31m✘\e[0m\n"
		print_diff $out_mini $out_bash
	}
	fi

	test1=$(tail -c 10 $err_mini)
	test2=$(tail -c 10 $err_bash)
	# printf "[$test1]\n[$test2]\n"
	if [ "$test1" = "$test2" ]; then
		printf "Error:  \e[32m✔\e[0m\n"
	else
	{
		printf "Error:  \e[31m?\e[0m\n"
		print_diff $err_mini $err_bash
	}
	fi

	if [ "$mini_exit" -eq "$bash_exit" ]; then
		printf "Exit:   \e[32m✔\e[0m\n"
	else
	{
		((WRONG++))
		printf "Exit:   \e[31m✘\e[0m\n"
		printf "mini_output: $mini_exit\nbash_output: $bash_exit\n"
	}
	fi
	sleep 0.5
	#printf "[$TEST]:\nOutput: $output_result\nError  : $error_result\nExit   : $exit_result\n\n"
	
}

compare_syntax () {
	echo -n "$1" | .././minishell 2>$err_mini
	mini_exit="$?"
	echo -n "$1" | bash 2>$err_bash
	bash_exit="$?"
	mini_syn=$(head -n 1 $err_mini)
	bash_syn=$(head -n 1 $err_bash)
	printf "\n\e[36m[$1];\e[0m\n$mini_syn\n$bash_syn\n"
	if [ "$mini_exit" -eq "$bash_exit" ]; then
		printf "Exit:   \e[32m✔\e[0m\n"
	else
	{
		printf "Exit:   \e[31m✘\e[0m\n"
		printf "mini_output: $mini_exit\nbash_output: $bash_exit\n"
	}
	fi
	sleep 0.2
	#printf "[$bash_syn]\n"
}

printf "\n\e[32mtesting syntax errors\e[0m\n"
compare_syntax "hello < |"
compare_syntax "< >"
compare_syntax "<< >>"
compare_syntax "< |"
compare_syntax "> |"
compare_syntax ") ()"
compare_syntax "| |"
compare_syntax "&&&"
compare_syntax "|||"
compare_syntax "|| |||"
compare_syntax ">>>"
compare_syntax "(| |)"
compare_syntax "(())"


printf "\n\e[32mtesting empty input\e[0m\n"
sleep 1
compare_command ""
compare_command "	"
# compare_command "'"
# compare_command '"'
# compare_command '""'


printf "\n\e[32mtesting basic commands\e[0m\n"
sleep 1
compare_command "ls -lah"
compare_command "cat ../Makefile"
compare_command "cat NONEXISTINNGFILE.c"
compare_command "echo "HEY" > cat"
compare_command "cd NONEXISTINGPATH"
compare_command "echo hey | echo hey | ls"
compare_command "ls -S"
compare_command "exit 92"


printf "\n\e[32mtesting redirects\e[0m\n"
sleep 1
compare_command "ls > test > test1 < test2 > test 3"
compare_command "echo >> test.sh"
compare_command "echo >> NONEXISTINGFILE"
compare_command "ls >> lol "
compare_command "echo < test.sh < test.sh < test.sh < test.sh"
compare_command ""
compare_command ""

printf "\n\e[32mtesting pipes\e[0m\n"
compare_command "ls | ls | ls | ls"
compare_command "echo "hey" | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat"
compare_command "ls | cat | cat | echo"
compare_command "echo "hey" | ls"
compare_command "echo "hey" | ls | cat | wc -l"


printf "\n\e[32mtesting expansiones\e[0m\n"
sleep 1
compare "echo $HOME"

printf "\n\e[32mtesting BONUS\e[0m\n"

compare_command "ls && ls"
compare_command "(ls)"
compare_command "ls || ls"
compare_command "(ls) && (ls)"
compare_command "(ls) || (ls)"
# compare_command "(((((((((((((((((((((ls)))))))))))))))))))))"
# compare_command "(((((((((((((((((((((ls))))))))))))))))))))) && ((((((((ls))))))))"
# compare_command "unset PATH && ls"
compare_command "cat test.sh | echo hey && echo bye | ls"
compare_command "(sleep 3 && echo 'deze is voor de fatoe') | cat"

#rm -rf ~/bullshit
rm lol 2> /dev/null
rm cat 2> /dev/null
rm test 2> /dev/null
rm NONEXISTINGFILE 2> /dev/null
rm test1 2> /dev/null

if [ "$WRONG" -eq 0 ]; then
	printf "\nALL TESTS PASSED\n"
else
	printf "\nTEST FAILED ON "$WRONG" MISTAKES!\n"
fi


# # $OLDPWD leaks

















