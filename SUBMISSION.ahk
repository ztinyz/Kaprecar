#Requires AutoHotkey v2.0

L::
{
Send "{F5 down}{F5 up}"
MouseClick "left", 300, 1000
sleep 550
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
sleep 300
MouseClick "left", 480, 850
sleep 200
MouseMove 1000, 850
Send "{LButton down}"
MouseMove 800, 990
sleep 100
Send "{LButton up}"
sleep 50
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseMove 440, 980
}

LOOP
{
if(A_Now > "20240501000101")
{
Send "{F5 down}{F5 up}"
MouseClick "left", 300, 1000
sleep 550
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
sleep 300
MouseClick "left", 480, 850
sleep 200
MouseMove 1000, 850
Send "{LButton down}"
MouseMove 800, 990
sleep 100
Send "{LButton up}"
sleep 50
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseClick "left", 950, 1030
MouseMove 440, 980
sleep 10000
}

}
return
