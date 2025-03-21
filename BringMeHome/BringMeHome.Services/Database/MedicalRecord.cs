using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class MedicalRecord
    {
        public int MedicalRecordID { get; set; }
        public int AnimalID { get; set; } 
        public DateTime ExaminationDate { get; set; }
        public string Diagnosis { get; set; }
        public string Treatment { get; set; }
        public string Notes { get; set; }
        public int VeterinarianID { get; set; } 

        // Navigation Properties
        public Animal Animal { get; set; }
        public Staff Veterinarian { get; set; }
    }
}
