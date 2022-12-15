sub point_to_key {
    $x = $_[0];
    $y = $_[1];
    
    # Print a string using the values of the arguments
    return "".$x.",".$y;
}

sub get_close {
    $xx = $_[0];
    $yx = $_[1];
    $ttx = $_[2];
    $tty = $_[3];
    $resx = 0;
    $resy = 0;
    $will_move = (abs($ttx - $xx) > 1 or abs($tty - $yx) > 1);
    if ($will_move and $ttx != $xx) {
        $resx = ($ttx - $xx) / abs($ttx - $xx);
    }
    if ($will_move and $tty != $yx) {
        $resy = ($tty - $yx) / abs($tty - $yx);
    }
    @res = ($resx, $resy);
    return @res;
}

$\ = "\n";

@moves = ([0, 1], [1, 0], [0, -1], [-1, 0]);
%dir = ("R", 0, "D", 1, "L", 2, "U", 3);

$SNAKE_LEN = 10;
@knots = ([0, 0]);
for( $i = 1; $i < $SNAKE_LEN; $i = $i + 1 ) {
    push(@knots, [0, 0]);
}

%hash = (point_to_key(0, 0), 1);

while ($a = <>) {
    $d = $dir{substr($a, 0, 1)};
    $len = int(substr($a, 2));
    
    for( $i = 0; $i < $len; $i = $i + 1 ) {
        for ( $j = 0; $j < 2; $j = $j + 1 ) {
            $knots[0][$j] = $knots[0][$j] + $moves[$d][$j];
        }
        
        for ( $l = 1; $l < $SNAKE_LEN; $l = $l + 1) {        
            @temp = get_close($knots[$l][0], $knots[$l][1], $knots[$l - 1][0], $knots[$l - 1][1]);
            for ( $j = 0; $j < 2; $j = $j + 1 ) {
              $knots[$l][$j] = $knots[$l][$j] + $temp[$j];
            }
        }
        $hash{point_to_key($knots[$SNAKE_LEN - 1][0], $knots[$SNAKE_LEN - 1][1])} = 1;
    }
}

@keys = keys %hash;
$size = @keys;
print $size
