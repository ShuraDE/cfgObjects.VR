using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Text;
using System.Threading.Tasks;

namespace cfgVehLogParser
{
    public enum side
    {
        NODATA= -2,
        NO_SIDE = -1,
        EAST = 0,
        WEST = 1,
        IND = 2,
        CIV = 3,
        NEUTRAL = 4,
        ENEMY = 5,
        FRIENDLY = 6,
        LOGIC = 7

    }

    [Serializable()]
    public class LogLines {
        private List<string> _loglines = new List<string>();

        public List<string> loglines
        {
            get { return _loglines; }
        }

        public void add (string value) {
            string addValue = "";
            foreach (char c in value.ToCharArray())
            {
                if (!(c < 32 || (c > 126 && c < 161)))
                {
                    addValue += c.ToString();
                }  else {
                    _loglines.Add("Parser: found unprintable char :" + (int)c);
                }
            }
            _loglines.Add(addValue);
        }
    }

    [Serializable()]
    public class ParentHiraObject {
        public int tier = -1;
        public string entry = "";

        public ParentHiraObject(int tier, string entry)
        {
            this.tier = tier;
            this.entry = entry;
        }
        public ParentHiraObject() { }
    }

    [Serializable()]
    public class ParentHiraColl {
        private List<ParentHiraObject> _parents = new List<ParentHiraObject>();

        public List<ParentHiraObject> parents {
            get { return _parents; }
        }

        public ParentHiraColl(List<string> parentList)
        {
            for (int i = parentList.Count - 1; i >= 0;i-- ) {
                _parents.Add(new ParentHiraObject(Math.Abs(i-parentList.Count), parentList[i]));
            }

        }
        public ParentHiraColl() {}
    }

    [Serializable()]
    public class ArmaObject
    {
        public ArmaObject() { }

        public ArmaObject(string idx)
        {
            this.idx = int.Parse(idx);
        }

        private string handleArray(string data, bool bForceCountLabel, bool bRemoveDefaults)
        {
            string retVal = "";
            string[] defValues = new string[] {"Throw","Put"};

            if (data.Length > 2) {  //check contains data
                Dictionary<string, int> mags = new Dictionary<string, int>();
                data = data.Substring(1, data.Length - 3);
                foreach (string mag in data.Split(',')) {
                    retVal = cleanStr(mag);
                    if (!(true && bRemoveDefaults && defValues.Contains(retVal))) { 
                        if (mags.ContainsKey(retVal)) {
                            mags[retVal]++;
                        } else {
                            mags.Add(retVal, 1);
                        }
                    }
                }

                retVal = "";

                foreach (KeyValuePair<string, int> pair in mags)
                {
                    retVal += (retVal.Length == 0 ? "":",");
                    if (!bForceCountLabel && pair.Value == 1) {
                        retVal += pair.Key;
                    } else {
                        retVal += pair.Value.ToString() + "x " + pair.Key;
                    }
                }


            }

            return retVal;
        }

        private string handleCoDriver(string datastring)
        {
            List<string> data = singleData(datastring);
            int cargo = 0;

            foreach (string dat in data)
            {
                if (dat.Equals("1")) { cargo++; }
            }

            return cargo.ToString() + "/" + data.Count;
        }

        public bool ParseData(string section, string data)
        {
            List<string> valList = singleData(data);

            switch (section) {
              case ("exp_001"):
                //[className,_generalMacro,vehicleClass,displayName,[availableForSupportTypes],[weapons],[magazines],textSingular,[BASE],side,model,_parent,timeToLive]

                  this.className = valList[0];
                  this.generalMacro = valList[1];
                  this.vehicleClass = valList[2];
                  this.displayName = valList[3];
                  this.availableForSupportTypes = valList[4];
                  this.weapons = handleArray(valList[5],false,true);
                  this.magazines = handleArray(valList[6],true,false);
                  this.textSingular = valList[7];
                  this.filter = valList[8];
                  //this.side = valList[9];
                  this.side = ((side)Enum.Parse(typeof(side),(string.IsNullOrEmpty(valList[9])? "-2" : valList[9]))).ToString();
                  this.model = valList[10];
                  this.parent = valList[11];
                  this.ttl = valList[12];
                  this.mod = (valList[13].Length >= 1 && valList[13].Substring(0,1).Equals("@") ? valList[13].Substring(1) : valList[13]);
                  this.parents = new ParentHiraColl(singleData(valList[14]));
                  break;
                case ("exp_002"):
                  //[faction,crew,picture,icon,slingLoadCargoMemoryPoints,crewCrashProtection,crewExplosionProtection,numberPhysicalWheels,tracksSpeed,CommanderOptics,maxGForce,fireResistance,airCapacity,tf_hasLRradio,author]"
                  this.faction = valList[0];
                  this.crew = valList[1];
                  this.picture = valList[2];
                  this.icon = valList[3];
                  this.slingLoadCargoMemoryPoints = valList[4];
                  this.crewCrashProtection = valList[5];
                  this.crewExplosionProtection = valList[6];
                  this.numberPhysicalWheels = valList[7];
                  this.tracksSpeed = valList[8];
                  this.CommanderOptics = valList[9];
                  this.maxGForce = valList[10];
                  this.fireResistance = valList[11];
                  this.airCapacity = valList[12];
                  this.tf_hasLRradio = valList[13];
                  this.author = valList[14];
                  break;
                case ("exp_003"):
                //[[cargoIsCoDriver],transportSoldier,transportVehicleCount,transportAmmo,transportFuel,transportRepair,maximumLoad,transportMaxMagazines,transportMaxWeapons,transportMaxBackpacks]"
                  this.cargoIsCoDriver = handleCoDriver(valList[0]);
                  this.transportSoldier = valList[1];
                  this.transportVehicleCount = valList[2];
                  this.transportAmmo = valList[3];
                  this.transportFuel = valList[4];
                  this.transportRepair = valList[5];
                  this.maximumLoad = valList[6];
                  this.transportMaxMagazines = valList[7];
                  this.transportMaxWeapons = valList[8];
                  this.transportMaxBackpacks = valList[9];
                  break;
                case ("exp_004"):
                  //[fuelCapacity,armor,audible,accuracy,camouflage,accerleration,brakeDistance,maxSpeed,minSpeed,[hiddenSelections],[hiddenSelectionsTextures]]"

                  this.fuelCapacity = valList[0];
                  this.armor = valList[1];
                  this.audible = valList[2];
                  this.accuracy = valList[3];
                  this.camouflage = valList[4];
                  this.accerleration = valList[5];
                  this.brakeDistance = valList[6];
                  this.maxSpeed = valList[7];
                  this.minSpeed = valList[8];
                  this.hiddenSelections = handleArray(valList[9],false,false);
                  this.hiddenSelectionsTextures = valList[10];
                  break;
                case ("exp_005"):
                  //[armorStructural,armorFuel,armorGlass,armorLights,armorWheels,armorHull,armorTurret,armorGun,armorEngine,armorTracks,armorHead,armorHands,armorLegs,armorEngine,armorAvionics,armorVRotor,armorHRotor,armorMissiles]"
                  this.armorStructural = valList[0];
                  this.armorFuel = valList[1];
                  this.armorGlass = valList[2];
                  this.armorLights = valList[3];
                  this.armorWheels = valList[4];
                  this.armorHull = valList[5];
                  this.armorTurret = valList[6];
                  this.armorGun = valList[7];
                  this.armorEngine = valList[8];
                  this.armorTracks = valList[9];
                  this.armorHead = valList[10];
                  this.armorHands = valList[11];
                  this.armorLegs = valList[12];
                  this.armorAvionics = valList[13];
                  this.armorVRotor = valList[14];
                  this.armorHRotor = valList[15];
                  this.armorMissiles = valList[16];
                  break;
                case ("exp_006"):
                  //[[_maxWidth,_maxLength,_maxHeight],[_radius2D,_radius3D],[_worldWidth,_worldLength,_worldHeight],[bbox_p1, bbox_p2]]
                  this.modelSizes = valList[0];
                  this.radius = valList[1];
                  this.worldSizes = valList[2];
                  this.boundingBox = valList[3];
                  this.parentClassHirachical = valList[4];
                  break;
                case ("exp_scr"):
                  this.screenFile = data;
                  break;
              default:
                Console.WriteLine("unexpected section! " + section);
                break;
            }


            return true;
        }

        private string cleanStr(string buffer)
        {
            if (buffer.Length > 1)
            {
                if (buffer.Substring(0, 1).Equals("\""))
                {
                    buffer = buffer.Substring(1);
                }

                if (buffer.Substring(buffer.Length - 1, 1).Equals("\""))
                {
                    buffer = buffer.Substring(0, buffer.Length - 1);
                }
            }

            return buffer;
        }

        private List<string> singleData (string data) {
          List<string> retVal = new List<string>();
          string buffer = "";
          int openBrackets = 0;
          bool recheckString = false;
          bool activeStringValue = false;
          char lastChar = ' ';

          foreach (char c in data) {
            
            if (recheckString) {
                if (!(c == ',' && lastChar == ']')) { activeStringValue = true; }
            }
            recheckString = false;
              
            if (c == '[') {openBrackets++;}
            if (c == ']') { 
                openBrackets--;
                if (openBrackets == 1) { activeStringValue = false; recheckString = true; }
            } 
            

            if (c == '"' && lastChar == ',') { activeStringValue = true; }
            if (c == ',' && lastChar == '"') { activeStringValue = false; }
            
            if (c == ',' && openBrackets == 1 && !activeStringValue)
            {
              retVal.Add(cleanStr(buffer));
              buffer = "";
            } else {
              if (!((openBrackets == 1 && c == '[') || openBrackets == 0)) { buffer += c; }
              
            }
            lastChar = c;
          }
          retVal.Add(cleanStr(buffer));

          return retVal;
        }

        public int idx;
        public string screenFile;
//001
        public string className;
        public string generalMacro;
        public string vehicleClass;
        public string displayName;
        public string availableForSupportTypes;
        public string weapons;
        public string magazines;
        public string textSingular;
        public string filter;
        public string side;
        public string model;
        public string parent;
        public string ttl;
        public string mod;
        public ParentHiraColl parents  = new ParentHiraColl();
//002
        public string faction;
        public string crew;
        public string picture;
        public string icon;
        public string slingLoadCargoMemoryPoints;
        public string crewCrashProtection;
        public string crewExplosionProtection;
        public string numberPhysicalWheels;
        public string tracksSpeed;
        public string CommanderOptics;public string maxGForce;
        public string fireResistance;
        public string airCapacity;
        public string tf_hasLRradio;
        public string author;
//003
        public string cargoIsCoDriver;
        public string transportSoldier;
        public string transportVehicleCount;
        public string transportAmmo;
        public string transportFuel;
        public string transportRepair;
        public string maximumLoad;
        public string transportMaxWeapons;
        public string transportMaxMagazines;
        public string transportMaxBackpacks;
//004
        public string fuelCapacity;
        public string armor;
        public string audible;
        public string accuracy;
        public string camouflage;
        public string accerleration;
        public string brakeDistance;
        public string maxSpeed;
        public string minSpeed;
        public string hiddenSelections;
        public string hiddenSelectionsTextures;
//005
        public string armorStructural;
        public string armorFuel;
        public string armorGlass;
        public string armorLights;
        public string armorWheels;
        public string armorHull;
        public string armorTurret;
        public string armorGun;
        public string armorEngine;
        public string armorTracks;
        public string armorHead;
        public string armorHands;
        public string armorLegs;
        public string armorAvionics;
        public string armorVRotor;
        public string armorHRotor;
        public string armorMissiles;
//006
        public string modelSizes;
        public string worldSizes;
        public string radius;
        public string boundingBox;
        public string parentClassHirachical;

        public bool logContainsErrors = false;
        public LogLines log = new LogLines();

        public bool createable = true;

    }
}
