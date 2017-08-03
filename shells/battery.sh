Battery=$(acpi -b | grep "Battery" | sed -nr '/Battery/s/.*(\<[[:digit:]]+%).*/\1/p')
echo "<openbox_pipe_menu>"
echo "<item label=\"Battery: $Battery\"/>"
echo "</openbox_pipe_menu>"


