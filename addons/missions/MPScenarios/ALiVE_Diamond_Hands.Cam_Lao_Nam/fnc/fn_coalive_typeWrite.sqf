/*
    Author: Wyqer, veteran29
    Date: 2019-07-21

    Description:
        Writing mission information on mission startup.

    Parameter(s):
        NONE

    Returns:
        Effects were started [BOOL]
*/

[] spawn {
    sleep 2;
    // Corner coordinates
    private _w = 0.80;
    private _h = 0.45;
    date params ["", "", "", "_hour", "_minute"];

    [
        [
            ["Operation: ", "<t align = 'left' shadow = '1' size = '0.7' font='tt2020style_e_vn_bold'>%1</t>"],
            ["Paper Hands"],
            [format ["Thursday 21st Dec 1967. %1%2%3%4h", ["0", ""] select (_hour >= 10), _hour, ["0", ""] select (_minute >= 10), _minute]],
            ["ST Sisler, MACV-SOG, 5th SF Group, Tri-Border Area", "<t align = 'left' shadow = '1' size = '0.7'>%1</t><br/><br/>"],
            ["Mission: ", "<t align = 'left' shadow = '1' size = '0.7' font='tt2020style_e_vn_bold'>%1</t>"],
            ["Conduct counter insurgency operations deep behind enemy lines.", nil, 3.5]
        ],
        [safeZoneX + safeZoneW - _w, _w],
        [safeZoneY + safeZoneH - _h - 0.05, _h]
    ] spawn vn_ms_fnc_sfx_typeText;
};

true
