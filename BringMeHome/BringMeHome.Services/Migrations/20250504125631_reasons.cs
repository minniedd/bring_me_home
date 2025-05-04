using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class reasons : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AdoptionReasons");

            migrationBuilder.DropColumn(
                name: "AdoptionReasonId",
                table: "AdoptionApplications");

            migrationBuilder.AddColumn<int>(
                name: "ReasonID",
                table: "AdoptionApplications",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_ReasonID",
                table: "AdoptionApplications",
                column: "ReasonID");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Reasons_ReasonID",
                table: "AdoptionApplications",
                column: "ReasonID",
                principalTable: "Reasons",
                principalColumn: "ReasonID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Reasons_ReasonID",
                table: "AdoptionApplications");

            migrationBuilder.DropIndex(
                name: "IX_AdoptionApplications_ReasonID",
                table: "AdoptionApplications");

            migrationBuilder.DropColumn(
                name: "ReasonID",
                table: "AdoptionApplications");

            migrationBuilder.AddColumn<int>(
                name: "AdoptionReasonId",
                table: "AdoptionApplications",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "AdoptionReasons",
                columns: table => new
                {
                    ApplicationID = table.Column<int>(type: "int", nullable: false),
                    ReasonID = table.Column<int>(type: "int", nullable: false),
                    ReasonID1 = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdoptionReasons", x => new { x.ApplicationID, x.ReasonID });
                    table.ForeignKey(
                        name: "FK_AdoptionReasons_AdoptionApplications_ApplicationID",
                        column: x => x.ApplicationID,
                        principalTable: "AdoptionApplications",
                        principalColumn: "ApplicationID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionReasons_Reasons_ReasonID",
                        column: x => x.ReasonID,
                        principalTable: "Reasons",
                        principalColumn: "ReasonID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionReasons_Reasons_ReasonID1",
                        column: x => x.ReasonID1,
                        principalTable: "Reasons",
                        principalColumn: "ReasonID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionReasons_ReasonID",
                table: "AdoptionReasons",
                column: "ReasonID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionReasons_ReasonID1",
                table: "AdoptionReasons",
                column: "ReasonID1");
        }
    }
}
