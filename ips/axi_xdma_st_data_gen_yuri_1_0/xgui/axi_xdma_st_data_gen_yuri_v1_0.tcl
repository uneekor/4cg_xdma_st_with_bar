# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set NUMBER_OF_OUTPUT_WORDS [ipgui::add_param $IPINST -name "NUMBER_OF_OUTPUT_WORDS" -parent ${Page_0}]
  set_property tooltip {number of words in one axi-stream packet. 0 means packet never end.} ${NUMBER_OF_OUTPUT_WORDS}
  ipgui::add_param $IPINST -name "C_M00_AXIS_TDATA_WIDTH" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.NUMBER_OF_OUTPUT_WORDS { PARAM_VALUE.NUMBER_OF_OUTPUT_WORDS } {
	# Procedure called to update NUMBER_OF_OUTPUT_WORDS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUMBER_OF_OUTPUT_WORDS { PARAM_VALUE.NUMBER_OF_OUTPUT_WORDS } {
	# Procedure called to validate NUMBER_OF_OUTPUT_WORDS
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.NUMBER_OF_OUTPUT_WORDS { MODELPARAM_VALUE.NUMBER_OF_OUTPUT_WORDS PARAM_VALUE.NUMBER_OF_OUTPUT_WORDS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUMBER_OF_OUTPUT_WORDS}] ${MODELPARAM_VALUE.NUMBER_OF_OUTPUT_WORDS}
}

