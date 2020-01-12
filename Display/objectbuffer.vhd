-- description: object buffer that holds the objects to display
--    object locations can be controlled from upper level
--    example contains a wall, a rectanble box and a round ball

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity objectbuffer is
    generic (
        OBJECT_SIZE : natural := 16;
        PIXEL_SIZE : natural := 24;
        RES_X : natural := 1280;
        RES_Y : natural := 720
    );
    port (
        video_active       : in  std_logic;
        pixel_x, pixel_y   : in  std_logic_vector(OBJECT_SIZE-1 downto 0);
        object1x, object1y : in  std_logic_vector(OBJECT_SIZE-1 downto 0);
        object2x, object2y : in  std_logic_vector(OBJECT_SIZE-1 downto 0);
        backgrnd_rgb       : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
        rgb                : out std_logic_vector(PIXEL_SIZE-1 downto 0)
    );
end objectbuffer;

architecture rtl of objectbuffer is
    
    --create a scoreboard seperator bar named bar_t
    signal object_bar_x :std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(616, OBJECT_SIZE));
    signal object_bar_y :std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(22, OBJECT_SIZE));
    constant BAR_T_SIZE_X: integer := 48;
    constant BAR_T_SIZE_Y: integer := 16;
    signal bar_t_x_l: unsigned (OBJECT_SIZE-1 downto 0);
    signal bar_t_y_t: unsigned (OBJECT_SIZE-1 downto 0);
    signal bar_t_x_r: unsigned (OBJECT_SIZE-1 downto 0);
    signal bar_t_y_b: unsigned (OBJECT_SIZE-1 downto 0);
    
    -- create a scoreboard 4x1280
    constant SCR_BOARD_Y_T: integer := 60;
    constant SCR_BOARD_Y_B: integer := 64;
    
    -- create a 5 pixel vertical wall
    constant WALL_L_X_L: integer := 0;
    constant WALL_L_X_R: integer := 10;
    constant WALL_R_X_L: integer := 1270;
    constant WALL_R_X_R: integer := 1280;
    constant WALL_B_Y_T: integer := 710;
    constant WALL_B_Y_B: integer := 720;
    
    -- 1st object is a vertical box 48x8 pixel
    constant USR_SIZE_X: integer :=  16;
    constant USR_SIZE_Y: integer := 128;
   
    --x, y coordinates of the usr1
    signal usr1_x_l : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr1_y_t : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr1_x_r : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr1_y_b : unsigned (OBJECT_SIZE-1 downto 0);
    
    --x, y coordinates of the usr1
    signal usr2_x : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1244, OBJECT_SIZE));
    signal usr2_y : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(296, OBJECT_SIZE));
    signal usr2_x_l : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr2_y_t : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr2_x_r : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr2_y_b : unsigned (OBJECT_SIZE-1 downto 0);

    -- 2nd object is a ball
    constant BALL_SIZE: integer:=32;
    type rom_type is array (0 to 31) of std_logic_vector(31 downto 0); --rom_type for ball 32x32 top hazýrlanacak
    constant BALL_ROM: rom_type := (
       "00000000000111111111100000000000",
       "00000000111111111111111100000000",
       "00000001111111111111111110000000",
       "00000111111111111111111111100000",
       "00001111111111111111111111110000",
       "00011111111111111111111111111000",
       "00011111111111111111111111111000",
       "00111111111111111111111111111100",
       "01111111111111111111111111111110",
       "01111111111111111111111111111110",
       "01111111111111111111111111111110",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "11111111111111111111111111111111",
       "01111111111111111111111111111110",
       "01111111111111111111111111111110",
       "01111111111111111111111111111110",
       "00111111111111111111111111111100",
       "00011111111111111111111111111000",
       "00011111111111111111111111111000",
       "00001111111111111111111111110000",
       "00000111111111111111111111100000",
       "00000001111111111111111110000000",
       "00000000111111111111111100000000",
       "00000000000111111111100000000000"
    );
    constant USR_SCR_SIZE_X: integer := 32;
    constant USR_SCR_SIZE_Y: integer := 40;
    type rom_type_n is array (0 to 39) of std_logic_vector(31 downto 0);--rom type for numbers
    constant n_0: rom_type_n :=(
    "00000000000000000000000000000000",
    "00000000001111111111100000000000",
    "00000000011111111111111100000000",
    "00000000111111111111111110000000",
    "00000001111111111111111111000000",
    "00000011111111111111111111100000",
    "00000111111111111111111111100000",
    "00000111111110000001111111110000",
    "00001111111100000000111111110000",
    "00001111111100000000111111110000",
    "00001111111000000000011111111000",
    "00011111111000000000011111111000",
    "00011111111000000000011111111000",
    "00011111111000000000011111111000",
    "00011111110000000000001111111000",
    "00011111110000000000001111111000",
    "00011111110000000000001111111000",
    "00011111110000000000001111111000",
    "00011111110000000000001111111100",
    "00111111110000000000001111111100",
    "00111111110000000000001111111100",
    "00111111110000000000001111111100",
    "00011111110000000000001111111000",
    "00011111110000000000001111111000",
    "00011111110000000000001111111000",
    "00011111110000000000001111111000",
    "00011111111000000000001111111000",
    "00011111111000000000011111111000",
    "00011111111000000000011111111000",
    "00011111111000000000011111111000",
    "00011111111000000000011111110000",
    "00001111111100000000111111110000",
    "00001111111110000001111111100000",
    "00000111111111000111111111100000",
    "00000111111111111111111111000000",
    "00000011111111111111111111000000",
    "00000001111111111111111110000000",
    "00000000111111111111111000000000",
    "00000000001111111111100000000000",
    "00000000000000000000000000000000"
    );
    
    constant n_1: rom_type_n :=(
    "00000000000000000000000000000000",
    "00000000000000111111000000000000",
    "00000000000011111111000000000000",
    "00000000000111111111000000000000",
    "00000000011111111111000000000000",
    "00000000111111111111000000000000",
    "00000011111111111111000000000000",
    "00000111111111111111000000000000",
    "00000111111111111111000000000000",
    "00000111111001111111000000000000",
    "00000111110001111111000000000000",
    "00000111000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000000000001111111000000000000",
    "00000111111111111111111111100000",
    "00000111111111111111111111100000",
    "00000111111111111111111111100000",
    "00000111111111111111111111100000",
    "00000111111111111111111111100000",
    "00000111111111111111111111100000",
    "00000000000000000000000000000000");
    
    -- rom for ball abject
    signal rom_addr, rom_col: unsigned(0 to 4);
    signal rom_bit: std_logic;
    -- x, y coordinates of the ball
    signal ball_x_l : unsigned(OBJECT_SIZE-1 downto 0);
    signal ball_y_t : unsigned(OBJECT_SIZE-1 downto 0);
    signal ball_x_r : unsigned(OBJECT_SIZE-1 downto 0);
    signal ball_y_b : unsigned(OBJECT_SIZE-1 downto 0);
    --x,y coordinate of the usr1_scr
    signal usr1_scr_x : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(570, OBJECT_SIZE));
    signal usr1_scr_y : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(10, OBJECT_SIZE));
    signal usr1_scr_x_l : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr1_scr_y_t : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr1_scr_x_r : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr1_scr_y_b : unsigned (OBJECT_SIZE-1 downto 0);
    --rom for usr1_scr
    signal rom_addr_usr1,rom_col_usr1 : unsigned(0 to 4);
    signal rom_bit_usr1 : std_logic;
    --x,y coordinate of the usr1_scr
    signal usr2_scr_x : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(678, OBJECT_SIZE));
    signal usr2_scr_y : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(10, OBJECT_SIZE));
    signal usr2_scr_x_l : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr2_scr_y_t : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr2_scr_x_r : unsigned (OBJECT_SIZE-1 downto 0);
    signal usr2_scr_y_b : unsigned (OBJECT_SIZE-1 downto 0);
    --rom for usr1_scr
    signal rom_addr_usr2, rom_col_usr2 : unsigned(0 to 4);
    signal rom_bit_usr2 : std_logic;
    -- signals that holds the x, y coordinates
    signal pix_x, pix_y: unsigned (OBJECT_SIZE-1 downto 0);

    signal wall_l_on,wall_r_on, wall_b_on, usr1_on, usr2_on,square_usr1_scr_on, square_usr2_scr_on, square_ball_on, ball_on, usr1_scr_on, usr2_scr_on, scr_board_on,bar_t_on: std_logic;
    signal wall_rgb, usr1_rgb, usr2_rgb, ball_rgb, usr1_scr_rgb, usr2_scr_rgb, scr_board_rgb, bar_t_rgb: std_logic_vector(23 downto 0);

begin

    pix_x <= unsigned(pixel_x);
    pix_y <= unsigned(pixel_y);
    
    -- draw wall and color
    wall_l_on <= '1' when WALL_L_X_L<=pix_x and pix_x<=WALL_L_X_R else '0'; 
    wall_r_on <= '1' when WALL_R_X_L<=pix_x and pix_x<=WALL_R_X_R else '0';
    wall_b_on <= '1' when WALL_B_Y_T<=pix_y and pix_y<=WALL_B_Y_B else '0';
    wall_rgb <= x"808080"; -- gray
    --draw score board 
    scr_board_on <= '1' when SCR_BOARD_Y_T<=pix_y and pix_y<=SCR_BOARD_Y_B else '0';
    scr_board_rgb <=x"808080"; --gray
    --draw bar_t and color
    bar_t_x_l <= unsigned(object_bar_x);
    bar_t_y_t <= unsigned(object_bar_y);
    bar_t_x_r <= bar_t_x_l + BAR_T_SIZE_X - 1;
    bar_t_y_b <= bar_t_y_t + BAR_T_SIZE_Y - 1;
    bar_t_on <= '1' when bar_t_x_l<=pix_x and pix_x<=bar_t_x_r and
                       bar_t_y_t<=pix_y and pix_y<=bar_t_y_b else 
                       '0';
    bar_t_rgb <= x"808080"; --gray
    
    -- draw box and color
    -- calculate the coordinates
    usr1_x_l <= unsigned(object1x);
    usr1_y_t <= unsigned(object1y);
    usr1_x_r <= usr1_x_l + USR_SIZE_X - 1;
    usr1_y_b <= usr1_y_t + USR_SIZE_Y - 1;
    usr1_on <= '1' when usr1_x_l<=pix_x and pix_x<=usr1_x_r and
                       usr1_y_t<=pix_y and pix_y<=usr1_y_b else
              '0';
    -- box rgb output
    usr1_rgb <= x"00FF00"; --green
    
    -- draw box and color
    -- calculate the coordinates
    usr2_x_l <= unsigned(usr2_x);
    usr2_y_t <= unsigned(usr2_y);
    usr2_x_r <= usr2_x_l + USR_SIZE_X - 1;
    usr2_y_b <= usr2_y_t + USR_SIZE_Y - 1;
    usr2_on <= '1' when usr2_x_l<=pix_x and pix_x<=usr2_x_r and
                       usr2_y_t<=pix_y and pix_y<=usr2_y_b else
              '0';
    -- box rgb output
    usr2_rgb <= x"0000FF"; --blue

    -- draw ball and color
    -- calculate the coordinates
    ball_x_l <= unsigned(object2x);
    ball_y_t <= unsigned(object2y);
    ball_x_r <= ball_x_l + BALL_SIZE - 1;
    ball_y_b <= ball_y_t + BALL_SIZE - 1;

    square_ball_on <= '1' when ball_x_l<=pix_x and pix_x<=ball_x_r and
                               ball_y_t<=pix_y and pix_y<=ball_y_b else
                      '0';
    -- map current pixel location to ROM addr/col
    rom_addr <= pix_y(4 downto 0) - ball_y_t(4 downto 0);
    rom_col <= pix_x(4 downto 0) - ball_x_l(4 downto 0);
    rom_bit <= BALL_ROM(to_integer(rom_addr))(to_integer(rom_col));
    -- pixel within ball
    ball_on <= '1' when square_ball_on='1' and rom_bit='1' else '0';
    -- ball rgb output
    ball_rgb <= x"FF0000";   -- red
   --draw usr1_scr and color
   --calculate the coordinates
    usr1_scr_x_l <= unsigned(usr1_scr_x);
    usr1_scr_y_t <= unsigned(usr1_scr_y);
    usr1_scr_x_r <= usr1_scr_x_l + USR_SCR_SIZE_X - 1;
    usr1_scr_y_b <= usr1_scr_y_t + USR_SCR_SIZE_Y - 1;
    
    square_usr1_scr_on <= '1' when usr1_scr_x_l<=pix_x and pix_x<=usr1_scr_x_r and
                               usr1_scr_y_t<=pix_y and pix_y<=usr1_scr_y_b else
                      '0';
                      
   --map current pixel for usr1_scr
    rom_addr_usr1 <= pix_y(4 downto 0) - usr1_scr_y_t(4 downto 0);
    rom_col_usr1 <= pix_x(4 downto 0) - usr1_scr_x_l(4 downto 0);
    rom_bit_usr1 <= n_0(to_integer(rom_addr_usr1))(to_integer(rom_col_usr1));
    -- pixel within ball
    usr1_scr_on <= '1' when square_usr1_scr_on='1' and rom_bit_usr1='1' else '0';
    -- ball rgb output
    usr1_scr_rgb <= x"FF0000";   -- red
    
    --draw usr1_scr and color
   --calculate the coordinates
    usr2_scr_x_l <= unsigned(usr2_scr_x);
    usr2_scr_y_t <= unsigned(usr2_scr_y);
    usr2_scr_x_r <= usr2_scr_x_l + USR_SCR_SIZE_X - 1;
    usr2_scr_y_b <= usr2_scr_y_t + USR_SCR_SIZE_Y - 1;
    
    square_usr2_scr_on <= '1' when usr2_scr_x_l<=pix_x and pix_x<=usr2_scr_x_r and
                               usr2_scr_y_t<=pix_y and pix_y<=usr2_scr_y_b else
                      '0';
                      
   --map current pixel for usr1_scr
    rom_addr_usr2 <= pix_y(4 downto 0) - usr2_scr_y_t(4 downto 0);
    rom_col_usr2 <= pix_x(4 downto 0) - usr2_scr_x_l(4 downto 0);
    rom_bit_usr2 <= n_1(to_integer(rom_addr_usr2))(to_integer(rom_col_usr2));
    -- pixel within ball
    usr2_scr_on <= '1' when square_usr2_scr_on='1' and rom_bit_usr2='1' else '0';
    -- ball rgb output
    usr2_scr_rgb <= x"FF0000";   -- red
    
    
    
    -- display the image based on who is active
    -- note that the order is important
    process(video_active, wall_l_on, wall_r_on, wall_b_on, usr1_on, usr2_on, wall_rgb, usr1_rgb, usr2_rgb, ball_rgb, usr1_scr_rgb, usr1_scr_on, usr2_scr_on, backgrnd_rgb, ball_on, bar_t_on,scr_board_on) is
    begin
        if video_active='0' then
            rgb <= x"000000"; --blank
        else
            if wall_l_on = '1' then
                rgb <= wall_rgb;
            elsif wall_r_on = '1' then
                rgb <= wall_rgb;
            elsif wall_b_on = '1' then
                rgb <= wall_rgb;
            elsif scr_board_on = '1' then
                rgb <= scr_board_rgb; 
            elsif usr1_scr_on = '1' then
                rgb <= usr1_scr_rgb;
            elsif usr2_scr_on = '1' then
                rgb <= usr2_scr_rgb;
            elsif ball_on = '1' then
                rgb <= ball_rgb;
            elsif usr1_on = '1' then
                rgb <= usr1_rgb;
            elsif usr2_on = '1' then
                rgb <= usr2_rgb;
            elsif bar_t_on = '1' then
                rgb <= bar_t_rgb;
            else
                rgb <= backgrnd_rgb; -- x"FFFF00"; -- yellow background
            end if;
        end if;
    end process;

end rtl;