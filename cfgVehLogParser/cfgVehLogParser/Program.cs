using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Xml.Serialization;
using System.Security;

namespace cfgVehLogParser
{
    class Program
    {
        internal static string wikiPrefix = "";
        internal static int wikiItems = 250;
        internal static string wikiUsername = "Shura";
        internal static int wikiUserID = 5;

        static int Main(string[] args)
        {


            if (args.Length == 0)
            {
                Console.WriteLine("need importfile");
                return 1;
            }

            if (args.Length > 3)
            {
                Console.WriteLine("input: datafile.txt with path! ;  max numbers of wiki entries (number); wiki page prefix (Objects/  ; Objects: ; ...)");
                return 1;
            }

            string inputFile = args[0];

            if (args.Length >= 2)
            {
                if (!int.TryParse(args[1], out wikiItems))
                {
                    Console.WriteLine("amount must be numeric");
                }
            }

            if (args.Length == 3)
            {
                wikiPrefix = args[2];
            }



            if (!System.IO.File.Exists(inputFile))
            {
                Console.WriteLine("file not found");
                return 1;
            }

            string filePath = System.IO.Path.GetDirectoryName(inputFile);

            int stateParse = 0;
            
            int counter = 0;
            int maxCount = 0;
            int lineCount = 0;

            Boolean bNoValidLine = true;
            Boolean bIgnoreLine = true;

            string line;
            string data = "";
            string attributeDef = "";

            string[] defPrefix = {"def_001","def_002","def_003","def_004","def_005","def_006","exp_scr"};
            string[] datPrefix = {"exp_001","exp_002","exp_003","exp_004","exp_005","exp_006","exp_scr","exp_idx"};
            string startData = "exp_idx: 1";

            ArmaObjects allObj = new ArmaObjects();
            ArmaObject aObj = new ArmaObject();

            // Read the file and display it line by line.
            System.IO.StreamReader file =  new System.IO.StreamReader(inputFile);
            while ((line = file.ReadLine()) != null)
            {
                lineCount++;

                if (stateParse > 0)
                {

                    counter++;
                    //line 1 & 2                    
                    /* definition
13:56:57 "debug: Export Data:"
13:56:57 "def_001: [className,_generalMacro,vehicleClass,displayName,[availableForSupportTypes],[weapons],[magazines],textSingular,[BASE],side,model,_parent,timeToLive]"
13:56:57 "def_002: [faction,crew,picture,icon,slingLoadCargoMemoryPoints,crewCrashProtection,crewExplosionProtection,numberPhysicalWheels,tracksSpeed,CommanderOptics,maxGForce,fireResistance,airCapacity,tf_hasLRradio,author]"
13:56:57 "def_003: [[cargoIsCoDriver],transportSoldier,transportVehicleCount,transportAmmo,transportFuel,transportRepair,maximumLoad,transportMaxMagazines,transportMaxWeapons,transportMaxBackpacks]"
13:56:57 "def_004: [fuelCapacity,armor,audible,accuracy,camouflage,accerleration,brakeDistance,maxSpeed,minSpeed,[hiddenSelections],[hiddenSelectionsTextures]]"
13:56:57 "def_005: [armorStructural,armorFuel,armorGlass,armorLights,armorWheels,armorHull,armorTurret,armorGun,armorEngine,armorTracks,armorHead,armorHands,armorLegs,armorEngine,armorAvionics,armorVRotor,armorHRotor,armorMissiles]"
13:56:57 "def_006: [[_maxWidth,_maxLength,_maxHeight],[_radius2D,_radius3D],[_worldWidth,_worldLength,_worldHeight],[bbox_p1, bbox_p2]]"
13:56:57 "exp_scr: _scrshot_file"
                    */

                    if (stateParse == 1)
                    {
                        //check data start
                        if (line.Contains(startData) && line.Length == startData.Length+11 ) {
                            stateParse = 2;
                            Console.WriteLine("start");
                        }

                        //get header                        
                        if (line.Length > 19 && defPrefix.Contains(line.Substring(10, 7)))
                        {
                            attributeDef = line.Substring(19);
                            Console.WriteLine(attributeDef);
                        } 
                    }

                    //debug
                    //if (counter > 20) { break; }

                    /* logentries with no relevant rror:
                    18:20:37 Warning Message: Picture iconmanat not found
                    18:20:37 WARNING: Function 'name' - 814c4080# 168927: o_soldier_01.p3d has no unit
                    18:20:37  - network id 0:0
                    18:20:37  - person 
                    */

                    if (stateParse == 2 && line.Length > 9) {

                        bNoValidLine = true;

                        line = line.Substring(9);
                        if (line.Length >= 11)
                        {
                            data = line.Substring(10,line.Length -11);
                            bNoValidLine = false;
                        }
                        //check special errors
                        bIgnoreLine = false;
                        bIgnoreLine |= (line.StartsWith("WARNING: Function 'name' -") && line.EndsWith("has no unit"));
                        bIgnoreLine |= (line.Equals(" - network id 0:0"));
                        bIgnoreLine |= (line.Equals(" - person "));
                        bIgnoreLine |= ((line.StartsWith("Warning Message: Picture")) && line.EndsWith("not found"));
                        bIgnoreLine |= (line.Equals("No owner"));
                        bIgnoreLine |= line.StartsWith("\"debug: done");
                        //bIgnoreLine |= (line.EndsWith("Vehicles with brain cannot be created using 'createVehicle'!"));
                        bIgnoreLine |= (line.StartsWith("\"skipped objects::"));

                        if (line.EndsWith("Vehicles with brain cannot be created using 'createVehicle'!")) {
                            aObj.createable = false;
                            bIgnoreLine = true;
                        }

                        if (bNoValidLine)
                        {
                            if (aObj != null && !bIgnoreLine) { 
                                aObj.log.add(line);
                                aObj.logContainsErrors = true;
                                //Console.WriteLine("add log " + " - #" + line + "#");
                            }
                        }
                        else
                        {
                            switch (line.Substring(1, 7))
                            {
                                case "exp_idx":
                                    aObj = new ArmaObject(data);
                                    allObj.objList.Add(aObj);
                                    break;
                                case "exp_001":
                                case "exp_002":
                                case "exp_003":
                                case "exp_004":
                                case "exp_005":
                                case "exp_006":
                                    aObj.ParseData(line.Substring(1, 7), data);
                                    break;
                                case "exp_scr":
                                    break;
                                default:
                                    if (line.Equals("\"debug: " + aObj.className + "\""))
                                    { break; }
                                    if (!bIgnoreLine) {
                                        aObj.logContainsErrors = true;
                                        aObj.log.add(line);
                                    }
                                    break;
                            }
                        }
                    }
                } else { 
                    //10:59:58 "debug: Found 1245 Objects"
                    if (line.Length >= 32 &&  line.Substring(9,14).Equals("\"debug: Found ") && line.Substring(line.Length-8).Equals("Objects\"")) {
                        maxCount = int.Parse(line.Substring(23, line.Length - 31));
                        Console.WriteLine("announnced: " + maxCount.ToString() + " objects");
                        stateParse = 1;
                    }
                }
            }

            Console.WriteLine("read " + counter + " lines");

            if (wikiItems == 0) { wikiItems = allObj.objList.Count; }

            file.Close();

            Console.WriteLine("write out files @ " + filePath );
            Console.WriteLine("arma_objects.xml");
            Console.WriteLine("arma_classes.txt");
            Console.WriteLine("arma_wiki_[0-" + (Math.Abs(allObj.objList.Count / wikiItems) + (allObj.objList.Count % wikiItems > 0 ? 1 : 0)) + "].xml");
            WriteOut(allObj, filePath);
            Console.WriteLine("write done");
  
            Console.ReadLine();

            return 0;

        }

        static internal void WriteOut(ArmaObjects allObj, string filePath)
        {
            Type[] types = { typeof(List<ArmaObject>), typeof(ArmaObject), typeof(ParentHiraObject), typeof(ParentHiraColl), typeof(LogLines) };

            allObj.buildSections();

            //all attributes
            XmlSerializer mySerializer = new XmlSerializer(typeof(ArmaObjects), types );
            StreamWriter myWriter = new StreamWriter(filePath + "\\arma_objects.xml");
            mySerializer.Serialize(myWriter, allObj);
            myWriter.Close();


            //write class list 
            string[] lstClass;
            lstClass = (from ls in allObj.objList select ls.className).ToArray();
            System.IO.File.WriteAllLines(filePath + "\\arma_classes.txt", lstClass);

            int page = 0;
            string[] extendedByVehicle = new string[] {"Car","Tank","Motorcycle","Helicopter","Plane","Ship"};
            //pages, media wiki doesnt do all in one if to many

            for (int i = 0; i < allObj.objList.Count; i += wikiItems)
            {
                page++;
                //write media wiki import xml
                using (System.IO.StreamWriter file = new System.IO.StreamWriter(filePath + "\\arma_wiki_" + page + ".xml"))
                {
                    string header = "<mediawiki xmlns=\"http://www.mediawiki.org/xml/export-0.4/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"   xsi:schemaLocation=\"http://www.mediawiki.org/xml/export-0.4/ http://www.mediawiki.org/xml/export-0.4.xsd\" version=\"0.4\" xml:lang=\"en\"><siteinfo>  <!-- … the XML header from an arbitrary wiki page export --> </siteinfo>";

                    file.WriteLine(header);
                    for (int x = 0; x < wikiItems; x++)
                    {
                        
                        if ((i + x) >= allObj.objList.Count) { break; }
                        file.WriteLine("<!-- " + allObj.objList[i + x].idx + "-->");
                        file.WriteLine("<page><title>" + wikiPrefix + allObj.objList[i+x].className + "</title><revision><contributor><username>"+ wikiUsername + "</username><id>" + wikiUserID + "</id></contributor><minor/><text xml:space= \"preserve\">");

                        file.WriteLine("{{Object");
                        file.WriteLine("|Classname=" + SecurityElement.Escape(allObj.objList[i + x].className));
                        file.WriteLine("|Displayname=" + SecurityElement.Escape(allObj.objList[i + x].displayName));
                        file.WriteLine("|HighParent=" + SecurityElement.Escape(allObj.objList[i + x].parentClassHirachical));
                        file.WriteLine("|Type=" + SecurityElement.Escape(allObj.objList[i + x].vehicleClass));
                        file.WriteLine("|SubType=" + SecurityElement.Escape(allObj.objList[i + x].textSingular));
                        file.WriteLine("|Side=" + SecurityElement.Escape(allObj.objList[i + x].side));
                        file.WriteLine("|Faction=" + SecurityElement.Escape(allObj.objList[i + x].faction));
                        file.WriteLine("|ModBase=" + SecurityElement.Escape(allObj.objList[i + x].mod.Replace("@", "")));
                        file.WriteLine("|Author=" + SecurityElement.Escape(allObj.objList[i + x].author));
                        file.WriteLine("|Armor=" + SecurityElement.Escape(allObj.objList[i + x].armor));
                        file.WriteLine("|hiddenSel=" + SecurityElement.Escape(allObj.objList[i + x].hiddenSelections));
                        file.WriteLine("|genLogErr=" + SecurityElement.Escape(allObj.objList[x + i].logContainsErrors.ToString()));
                        file.WriteLine("|logErr=" + SecurityElement.Escape(String.Join("\n",allObj.objList[x + i].log.loglines)));
                        file.WriteLine("|createable=" + SecurityElement.Escape(allObj.objList[x + i].createable.ToString()));
                        if (allObj.objList[x + i].parentClassHirachical != null) { file.WriteLine("|hiraTree=" + SecurityElement.Escape(allObj.objList[x + i].parentClassHirachical.ToString())); }

                        file.WriteLine("|accuracy=" + SecurityElement.Escape(allObj.objList[i + x].accuracy));
                        file.WriteLine("|camouflage=" + SecurityElement.Escape(allObj.objList[i + x].camouflage));
                        file.WriteLine("|weapons=" + SecurityElement.Escape(allObj.objList[i + x].weapons));
                        file.WriteLine("|magazines=" + SecurityElement.Escape(allObj.objList[i + x].magazines));

                        file.WriteLine("|accuracy=" + SecurityElement.Escape(allObj.objList[i + x].accuracy));
                        file.WriteLine("|camouflage=" + SecurityElement.Escape(allObj.objList[i + x].camouflage));
                        file.WriteLine("|weapons=" + SecurityElement.Escape(allObj.objList[i + x].weapons));
                        file.WriteLine("|magazines=" + SecurityElement.Escape(allObj.objList[i + x].magazines));
                        file.WriteLine("|audible=" + SecurityElement.Escape(allObj.objList[i + x].audible));
                        file.WriteLine("|crewProtectExplo=" + SecurityElement.Escape(allObj.objList[i + x].crewExplosionProtection));
                        file.WriteLine("|crewProtecCrash=" + SecurityElement.Escape(allObj.objList[i + x].crewCrashProtection));
                        file.WriteLine("|transportSoldier=" + SecurityElement.Escape(allObj.objList[i + x].transportSoldier));
                        file.WriteLine("|maxLoad=" + SecurityElement.Escape(allObj.objList[i + x].maximumLoad));
                        file.WriteLine("|fuelCapacity=" + SecurityElement.Escape(allObj.objList[i + x].fuelCapacity));
                        file.WriteLine("|maxSpeed=" + SecurityElement.Escape(allObj.objList[i + x].maxSpeed));
                        file.WriteLine("|brakeDist=" + SecurityElement.Escape(allObj.objList[i + x].brakeDistance));
                        file.WriteLine("|cargoIsCoDriver=" + SecurityElement.Escape(allObj.objList[i + x].cargoIsCoDriver));
                        file.WriteLine("|crew=" + SecurityElement.Escape(allObj.objList[i + x].crew));
                        file.WriteLine("|transMaxWeap=" + SecurityElement.Escape(allObj.objList[i + x].transportMaxWeapons));
                        file.WriteLine("|transMaxMag=" + SecurityElement.Escape(allObj.objList[i + x].transportMaxMagazines));
                        file.WriteLine("|transMaxBackpack=" + SecurityElement.Escape(allObj.objList[i + x].transportMaxBackpacks));
                        file.WriteLine("|transAmmo=" + SecurityElement.Escape(allObj.objList[i + x].transportAmmo));
                        file.WriteLine("|transFuel=" + SecurityElement.Escape(allObj.objList[i + x].transportFuel));
                        file.WriteLine("|transRepair=" + SecurityElement.Escape(allObj.objList[i + x].transportRepair));
                        file.WriteLine("|wheelsCount=" + SecurityElement.Escape(allObj.objList[i + x].numberPhysicalWheels));
                        file.WriteLine("|hasTracks=" + SecurityElement.Escape((double.Parse(allObj.objList[i + x].tracksSpeed) != 0 ? "1" : "0")));


                        file.WriteLine("}}");

                        file.WriteLine("</text></revision></page>");
                    }

                    createWikiCategories("Objekt Author", allObj.author, file, "AttObjAuthor");
                    createWikiCategories("Objekt Mod", allObj.mod, file, "AttModBase");
                    createWikiCategories("Objekt Typ", allObj.type, file, "AttObjType");
                    createWikiCategories("Objekt Subtyp", allObj.subtype, file, "AttObjSubType");
                    createWikiCategories("Objekt Faction", allObj.factions, file, "AttFaction");
                    createWikiCategories("Objekt Root", allObj.root, file, "AttClassParent");

                    /* create kat pages with queries for:
                     *  [[Kategorie:Objekt Author {{{Author|}}}]]
                        [[Kategorie:Objekt Mod {{{ModBase|}}}]]
                        [[Kategorie:Objekt Typ {{{Type|}}}]]
                        [[Kategorie:Objekt Subtyp {{{SubType|}}}]]
                        [[Kategorie:Objekt Faction {{{Faction|}}}]]
                        [[Kategorie:Objekt Root {{{HighParent|}}}]]  
                    */

                    file.WriteLine("</mediawiki>");


                }
            }
        }
        static internal void createWikiCategories(string catLabel, Dictionary<string, int> catColl, StreamWriter file, string catSMWAtt)
        {
            foreach (string cat in catColl.Keys)
            {
                file.WriteLine("<!-- category " + catLabel + " " + cat + "-->");
                file.WriteLine("<page><title>Category:" + catLabel + " " + cat + "</title><revision><contributor><username>Shura</username><id>5</id></contributor><minor/><text xml:space= \"preserve\">");
                file.WriteLine("{{#ask:");
                file.WriteLine("[[AttCategory::Object]][[" + catSMWAtt + "::" + cat + "]]");
                file.WriteLine("|?AttClassname=Classname");
                file.WriteLine("|?AttObjDisplayname=Label");
                file.WriteLine("|?AttObjType=Typ");
                file.WriteLine("|?AttModBase=Mod");
                file.WriteLine("|?Has image=Thumb");
                file.WriteLine("|?genLogErr=LogErr");
                file.WriteLine("}}");
                file.WriteLine("</text></revision></page>");
            }
        }
    }
}
