# Specify input and output file paths
set file {// Location of your SystemVerilog file} 
set sdc_file {// Location where you want to save the generated SDC file}


proc parse_sv_ports {file} {
    set ports {}
    set fp [open $file r]
    set content [read $fp]
    close $fp

  
    set port_pattern {^\s*(input|output)\s*(reg)?\s*(\[\d+:\d+\])?\s*(\w+)\s*(,)?}
    set lines [split $content "\n"]

    foreach line $lines {
        if {[regexp $port_pattern $line match direction reg width port comma]} {
            set port_info [dict create name $port direction $direction width $width]
            lappend ports $port_info
        }
    }
    return $ports
}


proc generate_sdc {ports sdc_file} {
    set fp [open $sdc_file w]

    
    puts $fp "# SDC file generated automatically from SystemVerilog module"
    puts $fp "# Date: [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]"
    puts $fp ""


    puts $fp "# Clock definition for clk"
    puts $fp "create_clock -period 10.000 -name clk -waveform {0.000 5.000} \[get_ports clk\]"
    puts $fp ""


    puts $fp "# Input and output delay constraints"
    foreach port $ports {
        set name [dict get $port name]
        set direction [dict get $port direction]
        set width [dict get $port width]

      
        if {$name == "clk"} {
            continue
        }

     
        if {$width == ""} {
            # Single-bit port
            if {$direction == "input"} {
                puts $fp "set_input_delay -clock clk 3.000 \[get_ports $name\]"
            } else {
                puts $fp "set_output_delay -clock clk 3.000 \[get_ports $name\]"
            }
        } else {
            # Multi-bit port
            # Remove brackets from width (e.g., [7:0] -> 7:0)
            set clean_width [string map {"[" "" "]" ""} $width]
            set bounds [split $clean_width ":"]
            set msb [lindex $bounds 0]
            set lsb [lindex $bounds 1]
            set bit_count [expr {$msb - $lsb + 1}]
            for {set i 0} {$i < $bit_count} {incr i} {
                if {$direction == "input"} {
                    puts $fp "set_input_delay -clock clk 3.000 \[get_ports {$name\[$i\]}\]"
                } else {
                    puts $fp "set_output_delay -clock clk 3.000 \[get_ports {$name\[$i\]}\]"
                }
            }
        }
    }

    close $fp
    puts "SDC file generated: $sdc_file"
}


set ports [parse_sv_ports $file]
generate_sdc $ports $sdc_file