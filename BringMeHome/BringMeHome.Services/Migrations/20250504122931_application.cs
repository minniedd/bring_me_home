using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class application : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Animals_AnimalID1",
                table: "AdoptionApplications");

            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_ApplicationStatuses_StatusID",
                table: "AdoptionApplications");

            migrationBuilder.DropIndex(
                name: "IX_AdoptionApplications_AnimalID1",
                table: "AdoptionApplications");

            migrationBuilder.DropColumn(
                name: "AnimalID1",
                table: "AdoptionApplications");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_ApplicationStatuses_StatusID",
                table: "AdoptionApplications",
                column: "StatusID",
                principalTable: "ApplicationStatuses",
                principalColumn: "StatusID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_ApplicationStatuses_StatusID",
                table: "AdoptionApplications");

            migrationBuilder.AddColumn<int>(
                name: "AnimalID1",
                table: "AdoptionApplications",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_AnimalID1",
                table: "AdoptionApplications",
                column: "AnimalID1");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Animals_AnimalID1",
                table: "AdoptionApplications",
                column: "AnimalID1",
                principalTable: "Animals",
                principalColumn: "AnimalID");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_ApplicationStatuses_StatusID",
                table: "AdoptionApplications",
                column: "StatusID",
                principalTable: "ApplicationStatuses",
                principalColumn: "StatusID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
