onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /uart_rx_tb/rx_data
add wave -noupdate -expand /uart_rx_tb/exp_data
add wave -noupdate /uart_rx_tb/clk
add wave -noupdate /uart_rx_tb/rst
add wave -noupdate /uart_rx_tb/rx
add wave -noupdate /uart_rx_tb/received
add wave -noupdate /uart_rx_tb/parity_error
add wave -noupdate /uart_rx_tb/exp_err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2746700 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {2666400 ps} {3264900 ps}
