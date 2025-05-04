using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class applicationadoption : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Staff_ReviewedByStaffID",
                table: "AdoptionApplications");

            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Staff_StaffID",
                table: "AdoptionApplications");

            migrationBuilder.DropIndex(
                name: "IX_AdoptionApplications_StaffID",
                table: "AdoptionApplications");

            migrationBuilder.DropColumn(
                name: "StaffID",
                table: "AdoptionApplications");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Staff_ReviewedByStaffID",
                table: "AdoptionApplications",
                column: "ReviewedByStaffID",
                principalTable: "Staff",
                principalColumn: "StaffID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Staff_ReviewedByStaffID",
                table: "AdoptionApplications");

            migrationBuilder.AddColumn<int>(
                name: "StaffID",
                table: "AdoptionApplications",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_StaffID",
                table: "AdoptionApplications",
                column: "StaffID");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Staff_ReviewedByStaffID",
                table: "AdoptionApplications",
                column: "ReviewedByStaffID",
                principalTable: "Staff",
                principalColumn: "StaffID",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Staff_StaffID",
                table: "AdoptionApplications",
                column: "StaffID",
                principalTable: "Staff",
                principalColumn: "StaffID");
        }
    }
}
