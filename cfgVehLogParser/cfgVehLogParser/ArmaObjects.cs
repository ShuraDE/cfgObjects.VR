using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cfgVehLogParser
{
    [Serializable()]
    public class ArmaObjects
    {
        internal Dictionary<string, int> factions = new Dictionary<string, int>();
        internal Dictionary<string, int> author = new Dictionary<string, int>();
        internal Dictionary<string, int> mod = new Dictionary<string, int>();
        internal Dictionary<string, int> type = new Dictionary<string, int>();
        internal Dictionary<string, int> subtype = new Dictionary<string, int>();
        internal Dictionary<string, int> root = new Dictionary<string, int>();

        public List<ArmaObject> objList = new List<ArmaObject>();

        public void buildSections()
        {
            foreach (ArmaObject obj in objList) {

                if (factions.ContainsKey(obj.faction))  {
                    factions[obj.faction]++;
                } else {
                    factions.Add(obj.faction, 1);
                }

                if (author.ContainsKey(obj.author))
                {
                    author[obj.author]++;
                } else {
                    author.Add(obj.author, 1);
                }

                if (mod.ContainsKey(obj.mod))
                {
                    mod[obj.mod]++;
                }
                else
                {
                    mod.Add(obj.mod, 1);
                }

                if (type.ContainsKey(obj.vehicleClass))
                {
                    type[obj.vehicleClass]++;
                } else {
                    type.Add(obj.vehicleClass, 1);
                }

                if (subtype.ContainsKey(obj.textSingular))
                {
                    subtype[obj.textSingular]++;
                } else {
                    subtype.Add(obj.textSingular, 1);
                }

                if (obj.parentClassHirachical != null)
                {
                    if (root.ContainsKey(obj.parentClassHirachical))
                    {
                        root[obj.parentClassHirachical]++;
                    }
                    else
                    {
                        root.Add(obj.parentClassHirachical, 1);
                    }
                }

            }

        }
    }
}
