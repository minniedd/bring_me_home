using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Donation
    {
        [Key]
        public int DonationID { get; set; }

        public int? DonorID { get; set; }

        [DataType(DataType.Date)]
        public DateTime Date { get; set; }

        [Column(TypeName = "decimal(18, 2)")]
        public decimal Amount { get; set; }

        public int DonationTypeID { get; set; }

        [StringLength(500)]
        public string Description { get; set; }

        [StringLength(50)]
        public string PaymentMethod { get; set; }

        [StringLength(100)]
        public string PayPalTransactionID { get; set; }

        [EmailAddress, StringLength(100)]
        public string PayPalPayerEmail { get; set; }

        [StringLength(50)]
        public string PayPalStatus { get; set; }

        public int? AcknowledgedByStaffID { get; set; }

        [DataType(DataType.Date)]
        public DateTime? AcknowledgementDate { get; set; }

        public bool TaxReceiptIssued { get; set; }

        // Navigation properties
        [ForeignKey("DonorID")]
        public virtual Donor Donor { get; set; }

        [ForeignKey("DonationTypeID")]
        public virtual DonationType DonationType { get; set; }

        [ForeignKey("AcknowledgedByStaffID")]
        public virtual Staff AcknowledgedBy { get; set; }
    }

}

