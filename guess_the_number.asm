# define variables
.data
game_init_msg: .asciiz "You are now playing 'Guess the Number'. \nA random number between 1 and 100 is generated. \nYou have 10 guesses. \nTry guessing the number until you get it right.\n\n"
win_msg: .asciiz "\nYour guess was correct!"
lose_msg: .asciiz  "You have run out of all lives."
wrong_guess_msg: .asciiz "Wrong. "
play_again_msg: .asciiz "Play again? y/n"
input_prompt_msg: .asciiz "Guess a number: "
input_prompt_wrong_msg: .asciiz "Guess another number: "
input_too_big_msg : .asciiz "Try guessing a bit lower."
input_too_small_msg: .asciiz "Try guessing a bit higher."

# entry point of the program
.text
main:
 j init_game

# game logics
# > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >
init_game: # entry point of the game
  la $a0, game_init_msg
  la $t3, input_prompt_msg
  jal print_string
  jal generate_rand 
  li $t0, 0 # set initial deaths to zero
  j game_loop

game_loop: # the main game loop
  move $a0, $t3 # load input prompt message to print
  jal print_string
  jal read_integer
	
  beq $v0, $t4, on_win # if input was equal to random number, the round is won
  la $a0, wrong_guess_msg
  jal print_string
  la $t3, input_prompt_wrong_msg
	
  add $t0, $t0, 1
  bgt $t0, 10, on_lose
  
  j game_loop

on_win:
  la $a0, win_msg
  jal print_string 

on_lose:
  la $a0, lose_msg
  jal print_string 
# < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 


# utility
# > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >
read_integer: # read integer input and store in $a0
  li $v0, 5
  syscall
  jr $ra

generate_rand: # generate random number in range 1-100 and store in $t3
  li $v0, 42
  li $a1, 100
  syscall
  addi $t4, $a0, 1
  jr $ra

print_string: # print string argument at $a0
  li $v0, 4 
  syscall   
  jr $ra

exit:
  li $v0, 10
  syscall
# < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < 

