depth = -y;
if IBox == noone {
	IBox = instance_create_depth(x, y, depth + 1, obj_Interaction);
	IBox.TextToDraw = "* It's not time to go there...";
	IBox.TextQueue[0] = "* Go somewhere else.";
}
else {
	IBox.x = x;
	IBox.y = y;
	IBox._Host = id;
}