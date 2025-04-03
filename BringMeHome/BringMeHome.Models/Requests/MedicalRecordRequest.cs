using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class MedicalRecordRequest
    {
        public int MedicalRecordID { get; set; }
        public int AnimalID { get; set; }
        public DateTime ExaminationDate { get; set; }
        public string Diagnosis { get; set; }
        public string Treatment { get; set; }
        public string Notes { get; set; }
        public int VeterinarianID { get; set; }
    }
}
