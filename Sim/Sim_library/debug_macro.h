`ifndef	_DEBUG_MACRO_HEADER
`define	_DEBUG_MACRO_HEADER

// Display
`define	DISP_INFO		$write("INFO: [%m] %0t: ", $time)
`define	DISP_WARNING	$write("WARNING: [%m] %0t: ", $time)
`define	DISP_ERROR		$write("ERROR: [%m] %0t: ", $time)

// Dump

// Assert

`endif//_DEBUG_MACRO_HEADER
