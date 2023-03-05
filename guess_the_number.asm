# define variables
.data
game_init_msg: .asciiz "You are now playing 'Guess the Number'. \nA random number between 1 and 100 is generated. \nYou have 10 guesses. \nTry guessing the number until you get it right.\n\n"
win_msg: .asciiz "\n*** Congrats! Your guess was correct! ***\n"
lose_msg: .asciiz  "\n*** You have reached the maximum number of guesses. ***\n"
wrong_guess_msg: .asciiz "Wrong. "
play_again_msg: .asciiz "Play again? (y/n) : "
input_prompt_msg: .asciiz "Guess a number: "
input_prompt_wrong_msg: .asciiz "Guess another number: "
guess_too_big_msg : .asciiz "Try guessing a bit lower."
guess_too_small_msg: .asciiz "Try guessing a bit higher."
guesses_remaining_msg: .asciiz "\nGuesses remaining : "
new_line: .asciiz "\n"


# entry point of the program
.text
main: 
 j init_game

# game logics
# > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >
init_game: # entry point of the game 
  la $a0, game_init_msg
  jal print_string
  jal generate_rand 
  
  li $t3, 10 # set max number of guesses
  move $t2, $t3 # load initial number of gusses
  
  jal print_gusses_remaining
  jal enter_new_line
  
  li $t0, 1 # set initial deaths to zero
  la $t1, input_prompt_msg # load intial input prompt message into $t1
  
  j game_loop

game_loop: # the main game loop
  move $a0, $t1 # load input prompt message to print
  jal print_string
  jal read_integer
  move $s0, $v0 # store player input in $s0
  
  jal check_win_condition 
  
  # if player has not guessed correctly
  la $a0, wrong_guess_msg
  jal print_string
  jal give_feedback
  jal print_gusses_remaining
  jal enter_new_line
  
  jal enter_new_line
  la $t1, input_prompt_wrong_msg 
  j game_loop

check_win_condition:
  addi $t0, $t0, 1 # incrememnt number of tries
  beq $s0, $s1, on_win # if input was equal to random number, the round is won
  bgt $t0, $t3, on_lose
  jr $ra

print_gusses_remaining:
  li $v0, 4
  la $a0, guesses_remaining_msg
  syscall
  
  li $v0, 1
  move $a0, $t2
  syscall
  sub $t2, $t2, 1
  la $a0, new_line
  li $v0, 4 
  syscall
  jr $ra

give_feedback: # evaluate the guess (i.e. is it bigger? smaller?)
  bgt $s0, $s1, is_bigger
  blt $s0, $s1, is_smaller
  j end_eval
 
  is_bigger:
    la $a0, guess_too_big_msg
    j print_string
  is_smaller:
    la $a0, guess_too_small_msg
    j print_string
    
  end_eval:  
  jr $ra

on_win:
  la $a0, win_msg
  jal print_string 
  j prompt_play_again

on_lose:
  la $a0, lose_msg
  jal print_string 
  j prompt_play_again
  
prompt_play_again:
  jal enter_new_line
  la $a0, play_again_msg
  jal print_string
  jal read_character
  beq $v0, 121, init_game 
  j exit
# < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 


# utility
# > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >
read_character:
  li $v0, 12
  syscall
  jr $ra

read_integer: # read integer input and store in $a0
  li $v0, 5
  syscall
  jr $ra

generate_rand: # generate random number in range 1-100 and store in $s1 and returns to caller
  li $v0, 42
  li $a1, 100
  syscall
  addi $s1, $a0, 1
  jr $ra

print_string: # print string argument at $a0 and returns to caller
  li $v0, 4 
  syscall   
  jr $ra
  
enter_new_line:
  la $a0, new_line
  j print_string
  
print_integer: # print integer sotred at $a0 and returns to caller
  li $v0, 1
  syscall
  jr $ra

exit: # exits program with syscall 10
  li $v0, 10
  syscall
# < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

