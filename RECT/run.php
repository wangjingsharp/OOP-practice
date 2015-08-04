<?php
	for($j=0; $j<70; $j++){
	$filename = sprintf("M%03d", $j);
	$handle = fopen($filename . ".RECT", "rb");
	$fsize = filesize($filename . ".RECT");
	print $fsize;
	print "\n";
	$a=unpack("s",fread($handle,2));
	print '$a : ' . $a[1] . "\n";
	
	$s = "[";
	for($i=0; $i<$a[1]; $i++){
		$x=unpack("s",fread($handle,2));
		$y=unpack("s",fread($handle,2));
		$w=unpack("s",fread($handle,2));
		$h=unpack("s",fread($handle,2));
		$w[1] -= $x[1];
		$h[1] -= $y[1];
		$s .= "[$x[1], $y[1], $w[1], $h[1]], \n";
	}
	$s .= "]";
	file_put_contents("$filename.js", $s);
	fclose($handle);
	}