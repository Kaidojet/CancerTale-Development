depth = -y;
if IBox == noone {
	IBox = instance_create_depth(x, y, depth + 1, obj_Interaction);
	IBox.TextToDraw = "* Welcome to the Test Map!";
	IBox.TextQueue[0] = "* Press F12 for DEBUG.";
}
else {
	IBox.x = x;
	IBox.y = y;
	IBox._Host = id;
}