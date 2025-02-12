// ----------------------------------------------------------------------------

#include "\x\alive\addons\fnc_analysis\script_component.hpp"
SCRIPT(test_unitAnalysis);

//execVM "\x\alive\addons\fnc_analysis\tests\test_appendClustersCiv.sqf"

// ----------------------------------------------------------------------------

private ["_result","_err","_logic","_timeStart","_timeEnd","_bounds","_grid","_plotter","_sector","_allSectors","_landSectors"];

LOG("Testing Unit Analysis Object");

ASSERT_DEFINED("ALIVE_fnc_sectorGrid","");
ASSERT_DEFINED("ALIVE_fnc_sectorAnalysisUnits","");

#define STAT(msg) sleep 3; \
diag_log ["TEST("+str player+": "+msg]; \
titleText [msg,"PLAIN"]

#define STAT1(msg) CONT = false; \
waitUntil{CONT}; \
diag_log ["TEST("+str player+": "+msg]; \
titleText [msg,"PLAIN"]

#define DEBUGON STAT("Setup debug parameters"); \
_result = [_grid, "debug", true] call ALIVE_fnc_sectorGrid; \
_err = "enabled debug"; \
ASSERT_TRUE(typeName _result == "BOOL", _err); \
ASSERT_TRUE(_result, _err);

#define DEBUGOFF STAT("Disable debug"); \
_result = [_grid, "debug", false] call ALIVE_fnc_sectorGrid; \
_err = "disable debug"; \
ASSERT_TRUE(typeName _result == "BOOL", _err); \
ASSERT_TRUE(!_result, _err);

#define TIMERSTART \
_timeStart = diag_tickTime; \
diag_log "Timer Start";

#define TIMEREND \
_timeEnd = diag_tickTime - _timeStart; \
["Timer End %1",_timeEnd] call ALiVE_fnc_dump;

//========================================

call ALiVE_fnc_staticDataHandler;

STAT("Create SectorGrid instance");
TIMERSTART
_grid = [nil, "create"] call ALIVE_fnc_sectorGrid;
[_grid, "init"] call ALIVE_fnc_sectorGrid;
TIMEREND


STAT("Create Grid");
TIMERSTART
_result = [_grid, "createGrid"] call ALIVE_fnc_sectorGrid;
TIMEREND


STAT("Create Sector Plotter");
TIMERSTART
_plotter = [nil, "create"] call ALIVE_fnc_plotSectors;
[_plotter, "init"] call ALIVE_fnc_plotSectors;
TIMEREND


DEBUGON


private ["_worldName","_file","_exportString","_gridData","_cluster","_clusterCenter","_clusterID","_sectorID","_sectorData","_consolidated"];


if(isNil "ALIVE_clustersCiv" && isNil "ALIVE_loadedCivClusters") then {
    _worldName = toLower(worldName);
    _file = format["\x\alive\addons\civ_placement\clusters\clusters.%1_civ.sqf", _worldName];
    call compile preprocessFileLineNumbers _file;
    ALIVE_loadedCivClusters = true;
};

_exportString = '';

_gridData = [] call ALIVE_fnc_hashCreate;

{
    _cluster = _x;
    _clusterCenter = [_cluster, "center"] call ALIVE_fnc_hashGet;
    _clusterID = [_cluster, "clusterID"] call ALIVE_fnc_hashGet;
    _sectorID = [_grid, "positionToGridIndex", _clusterCenter] call ALIVE_fnc_sectorGrid;
    _sectorID = format["%1_%2",_sectorID select 0, _sectorID select 1];

    if(_sectorID in (_gridData select 1)) then {
        _sectorData = [_gridData, _sectorID] call ALIVE_fnc_hashGet;
    }else{
        _sectorData = [] call ALIVE_fnc_hashCreate;
        [_sectorData, "consolidated", []] call ALIVE_fnc_hashSet;
        [_sectorData, "power", []] call ALIVE_fnc_hashSet;
        [_sectorData, "comms", []] call ALIVE_fnc_hashSet;
        [_sectorData, "marine", []] call ALIVE_fnc_hashSet;
        [_sectorData, "fuel", []] call ALIVE_fnc_hashSet;
        [_sectorData, "rail", []] call ALIVE_fnc_hashSet;
        [_sectorData, "construction", []] call ALIVE_fnc_hashSet;
        [_sectorData, "settlement", []] call ALIVE_fnc_hashSet;
    };

    _consolidated = [_sectorData, "consolidated"] call ALIVE_fnc_hashGet;
    _consolidated pushback [_clusterCenter,_clusterID];
    [_sectorData, "consolidated", _consolidated] call ALIVE_fnc_hashSet;

    //_sectorData call ALIVE_fnc_inspectHash;

    [_gridData, _sectorID, _sectorData] call ALIVE_fnc_hashSet;


} forEach (ALIVE_clustersCiv select 2);


{
    _cluster = _x;
    _clusterCenter = [_cluster, "center"] call ALIVE_fnc_hashGet;
    _clusterID = [_cluster, "clusterID"] call ALIVE_fnc_hashGet;
    _sectorID = [_grid, "positionToGridIndex", _clusterCenter] call ALIVE_fnc_sectorGrid;
    _sectorID = format["%1_%2",_sectorID select 0, _sectorID select 1];

    if(_sectorID in (_gridData select 1)) then {
        _sectorData = [_gridData, _sectorID] call ALIVE_fnc_hashGet;
    }else{
        _sectorData = [] call ALIVE_fnc_hashCreate;
        [_sectorData, "consolidated", []] call ALIVE_fnc_hashSet;
        [_sectorData, "power", []] call ALIVE_fnc_hashSet;
        [_sectorData, "comms", []] call ALIVE_fnc_hashSet;
        [_sectorData, "marine", []] call ALIVE_fnc_hashSet;
        [_sectorData, "fuel", []] call ALIVE_fnc_hashSet;
        [_sectorData, "rail", []] call ALIVE_fnc_hashSet;
        [_sectorData, "construction", []] call ALIVE_fnc_hashSet;
        [_sectorData, "settlement", []] call ALIVE_fnc_hashSet;
    };

    _power = [_sectorData, "power"] call ALIVE_fnc_hashGet;
    _power pushback [_clusterCenter,_clusterID];
    [_sectorData, "power", _power] call ALIVE_fnc_hashSet;

    //_sectorData call ALIVE_fnc_inspectHash;

    [_gridData, _sectorID, _sectorData] call ALIVE_fnc_hashSet;


} forEach (ALIVE_clustersCivPower select 2);


{
    _cluster = _x;
    _clusterCenter = [_cluster, "center"] call ALIVE_fnc_hashGet;
    _clusterID = [_cluster, "clusterID"] call ALIVE_fnc_hashGet;
    _sectorID = [_grid, "positionToGridIndex", _clusterCenter] call ALIVE_fnc_sectorGrid;
    _sectorID = format["%1_%2",_sectorID select 0, _sectorID select 1];

    if(_sectorID in (_gridData select 1)) then {
        _sectorData = [_gridData, _sectorID] call ALIVE_fnc_hashGet;
    }else{
        _sectorData = [] call ALIVE_fnc_hashCreate;
        [_sectorData, "consolidated", []] call ALIVE_fnc_hashSet;
        [_sectorData, "power", []] call ALIVE_fnc_hashSet;
        [_sectorData, "comms", []] call ALIVE_fnc_hashSet;
        [_sectorData, "marine", []] call ALIVE_fnc_hashSet;
        [_sectorData, "fuel", []] call ALIVE_fnc_hashSet;
        [_sectorData, "rail", []] call ALIVE_fnc_hashSet;
        [_sectorData, "construction", []] call ALIVE_fnc_hashSet;
        [_sectorData, "settlement", []] call ALIVE_fnc_hashSet;
    };

    _comms = [_sectorData, "comms"] call ALIVE_fnc_hashGet;
    _comms pushback [_clusterCenter,_clusterID];
    [_sectorData, "comms", _comms] call ALIVE_fnc_hashSet;

    //_sectorData call ALIVE_fnc_inspectHash;

    [_gridData, _sectorID, _sectorData] call ALIVE_fnc_hashSet;


} forEach (ALIVE_clustersCivComms select 2);


{
    _cluster = _x;
    _clusterCenter = [_cluster, "center"] call ALIVE_fnc_hashGet;
    _clusterID = [_cluster, "clusterID"] call ALIVE_fnc_hashGet;
    _sectorID = [_grid, "positionToGridIndex", _clusterCenter] call ALIVE_fnc_sectorGrid;
    _sectorID = format["%1_%2",_sectorID select 0, _sectorID select 1];

    if(_sectorID in (_gridData select 1)) then {
        _sectorData = [_gridData, _sectorID] call ALIVE_fnc_hashGet;
    }else{
        _sectorData = [] call ALIVE_fnc_hashCreate;
        [_sectorData, "consolidated", []] call ALIVE_fnc_hashSet;
        [_sectorData, "power", []] call ALIVE_fnc_hashSet;
        [_sectorData, "comms", []] call ALIVE_fnc_hashSet;
        [_sectorData, "marine", []] call ALIVE_fnc_hashSet;
        [_sectorData, "fuel", []] call ALIVE_fnc_hashSet;
        [_sectorData, "rail", []] call ALIVE_fnc_hashSet;
        [_sectorData, "construction", []] call ALIVE_fnc_hashSet;
        [_sectorData, "settlement", []] call ALIVE_fnc_hashSet;
    };

    _marine = [_sectorData, "marine"] call ALIVE_fnc_hashGet;
    _marine pushback [_clusterCenter,_clusterID];
    [_sectorData, "marine", _marine] call ALIVE_fnc_hashSet;

    //_sectorData call ALIVE_fnc_inspectHash;

    [_gridData, _sectorID, _sectorData] call ALIVE_fnc_hashSet;


} forEach (ALIVE_clustersCivMarine select 2);


{
    _cluster = _x;
    _clusterCenter = [_cluster, "center"] call ALIVE_fnc_hashGet;
    _clusterID = [_cluster, "clusterID"] call ALIVE_fnc_hashGet;
    _sectorID = [_grid, "positionToGridIndex", _clusterCenter] call ALIVE_fnc_sectorGrid;
    _sectorID = format["%1_%2",_sectorID select 0, _sectorID select 1];

    if(_sectorID in (_gridData select 1)) then {
        _sectorData = [_gridData, _sectorID] call ALIVE_fnc_hashGet;
    }else{
        _sectorData = [] call ALIVE_fnc_hashCreate;
        [_sectorData, "consolidated", []] call ALIVE_fnc_hashSet;
        [_sectorData, "power", []] call ALIVE_fnc_hashSet;
        [_sectorData, "comms", []] call ALIVE_fnc_hashSet;
        [_sectorData, "marine", []] call ALIVE_fnc_hashSet;
        [_sectorData, "fuel", []] call ALIVE_fnc_hashSet;
        [_sectorData, "rail", []] call ALIVE_fnc_hashSet;
        [_sectorData, "construction", []] call ALIVE_fnc_hashSet;
        [_sectorData, "settlement", []] call ALIVE_fnc_hashSet;
    };

    _fuel = [_sectorData, "fuel"] call ALIVE_fnc_hashGet;
    _fuel pushback [_clusterCenter,_clusterID];
    [_sectorData, "fuel", _fuel] call ALIVE_fnc_hashSet;

    //_sectorData call ALIVE_fnc_inspectHash;

    [_gridData, _sectorID, _sectorData] call ALIVE_fnc_hashSet;


} forEach (ALIVE_clustersCivFuel select 2);


{
    _cluster = _x;
    _clusterCenter = [_cluster, "center"] call ALIVE_fnc_hashGet;
    _clusterID = [_cluster, "clusterID"] call ALIVE_fnc_hashGet;
    _sectorID = [_grid, "positionToGridIndex", _clusterCenter] call ALIVE_fnc_sectorGrid;
    _sectorID = format["%1_%2",_sectorID select 0, _sectorID select 1];

    if(_sectorID in (_gridData select 1)) then {
        _sectorData = [_gridData, _sectorID] call ALIVE_fnc_hashGet;
    }else{
        _sectorData = [] call ALIVE_fnc_hashCreate;
        [_sectorData, "consolidated", []] call ALIVE_fnc_hashSet;
        [_sectorData, "power", []] call ALIVE_fnc_hashSet;
        [_sectorData, "comms", []] call ALIVE_fnc_hashSet;
        [_sectorData, "marine", []] call ALIVE_fnc_hashSet;
        [_sectorData, "fuel", []] call ALIVE_fnc_hashSet;
        [_sectorData, "rail", []] call ALIVE_fnc_hashSet;
        [_sectorData, "construction", []] call ALIVE_fnc_hashSet;
        [_sectorData, "settlement", []] call ALIVE_fnc_hashSet;
    };

    _construction = [_sectorData, "construction"] call ALIVE_fnc_hashGet;
    _construction pushback [_clusterCenter,_clusterID];
    [_sectorData, "construction", _construction] call ALIVE_fnc_hashSet;

    //_sectorData call ALIVE_fnc_inspectHash;

    [_gridData, _sectorID, _sectorData] call ALIVE_fnc_hashSet;


} forEach (ALIVE_clustersCivConstruction select 2);


{
    _cluster = _x;
    _clusterCenter = [_cluster, "center"] call ALIVE_fnc_hashGet;
    _clusterID = [_cluster, "clusterID"] call ALIVE_fnc_hashGet;
    _sectorID = [_grid, "positionToGridIndex", _clusterCenter] call ALIVE_fnc_sectorGrid;
    _sectorID = format["%1_%2",_sectorID select 0, _sectorID select 1];

    if(_sectorID in (_gridData select 1)) then {
        _sectorData = [_gridData, _sectorID] call ALIVE_fnc_hashGet;
    }else{
        _sectorData = [] call ALIVE_fnc_hashCreate;
        [_sectorData, "consolidated", []] call ALIVE_fnc_hashSet;
        [_sectorData, "power", []] call ALIVE_fnc_hashSet;
        [_sectorData, "comms", []] call ALIVE_fnc_hashSet;
        [_sectorData, "marine", []] call ALIVE_fnc_hashSet;
        [_sectorData, "fuel", []] call ALIVE_fnc_hashSet;
        [_sectorData, "rail", []] call ALIVE_fnc_hashSet;
        [_sectorData, "construction", []] call ALIVE_fnc_hashSet;
        [_sectorData, "settlement", []] call ALIVE_fnc_hashSet;
    };

    _settlement = [_sectorData, "settlement"] call ALIVE_fnc_hashGet;
    _settlement pushback [_clusterCenter,_clusterID];
    [_sectorData, "settlement", _settlement] call ALIVE_fnc_hashSet;

    //_sectorData call ALIVE_fnc_inspectHash;

    [_gridData, _sectorID, _sectorData] call ALIVE_fnc_hashSet;


} forEach (ALIVE_clustersCivSettlement select 2);


{
    _sectorID = _x;
    _sectorData = [_gridData,_sectorID] call ALIVE_fnc_hashGet;

    _consolidatedClusters = [_sectorData, "consolidated"] call ALIVE_fnc_hashGet;
    _powerClusters = [_sectorData, "power"] call ALIVE_fnc_hashGet;
    _commsClusters = [_sectorData, "comms"] call ALIVE_fnc_hashGet;
    _marineClusters = [_sectorData, "marine"] call ALIVE_fnc_hashGet;
    _fuelClusters = [_sectorData, "fuel"] call ALIVE_fnc_hashGet;
    _railClusters = [_sectorData, "rail"] call ALIVE_fnc_hashGet;
    _costructionClusters = [_sectorData, "construction"] call ALIVE_fnc_hashGet;
    _settlementClusters = [_sectorData, "settlement"] call ALIVE_fnc_hashGet;

    _exportString = _exportString + format['_sectorData = [ALIVE_gridData, "%1"] call ALIVE_fnc_hashGet;',_sectorID];
    //_exportString = _exportString + '_sectorData = [_sector, "data"] call ALIVE_fnc_sector;';

    _exportString = _exportString + '_clustersCiv = [] call ALIVE_fnc_hashCreate;';
    _exportString = _exportString + format['[_clustersCiv,"consolidated",%1] call ALIVE_fnc_hashSet;',_consolidatedClusters];
    _exportString = _exportString + format['[_clustersCiv,"power",%1] call ALIVE_fnc_hashSet;',_powerClusters];
    _exportString = _exportString + format['[_clustersCiv,"comms",%1] call ALIVE_fnc_hashSet;',_commsClusters];
    _exportString = _exportString + format['[_clustersCiv,"marine",%1] call ALIVE_fnc_hashSet;',_marineClusters];
    _exportString = _exportString + format['[_clustersCiv,"fuel",%1] call ALIVE_fnc_hashSet;',_fuelClusters];
    _exportString = _exportString + format['[_clustersCiv,"rail",%1] call ALIVE_fnc_hashSet;',_railClusters];
    _exportString = _exportString + format['[_clustersCiv,"construction",%1] call ALIVE_fnc_hashSet;',_costructionClusters];
    _exportString = _exportString + format['[_clustersCiv,"settlement",%1] call ALIVE_fnc_hashSet;',_settlementClusters];
    _exportString = _exportString + format['[_sectorData,"clustersCiv",_clustersCiv] call ALIVE_fnc_hashSet;'];

    _exportString = _exportString + format['[ALIVE_gridData, "%1", _sectorData] call ALIVE_fnc_hashSet;',_sectorID];

} forEach (_gridData select 1);

copyToClipboard _exportString;
["Adjustment complete, results have been copied to the clipboard"] call ALIVE_fnc_dump;

nil;
