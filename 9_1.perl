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

$hx = 0;
$hy = 0;
$tx = 0;
$ty = 0;

%hash = (point_to_key(0, 0), 1);

while ($a = <>) {
    $d = $dir{substr($a, 0, 1)};
    
    $len = int(substr($a, 2));
    
    for( $i = 0; $i < $len; $i = $i + 1 ) {
       $hx = $hx + $moves[$d][0];
       $hy = $hy + $moves[$d][1];
       @temp = get_close($tx, $ty, $hx, $hy);
       $tx = $tx + $temp[0];
       $ty = $ty + $temp[1];
       $hash{point_to_key($tx, $ty)} = 1;
    }
}

@keys = keys %hash;
$size = @keys;
print $size
