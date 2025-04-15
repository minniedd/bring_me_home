using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class ooooo : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionReasons_Reason_ReasonID",
                table: "AdoptionReasons");

            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionReasons_Reason_ReasonID1",
                table: "AdoptionReasons");

            migrationBuilder.DropForeignKey(
                name: "FK_Shelters_Cantons_CantonID",
                table: "Shelters");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Reason",
                table: "Reason");

            migrationBuilder.RenameTable(
                name: "Reason",
                newName: "Reasons");

            migrationBuilder.AlterColumn<int>(
                name: "CantonID",
                table: "Shelters",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Reasons",
                table: "Reasons",
                column: "ReasonID");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionReasons_Reasons_ReasonID",
                table: "AdoptionReasons",
                column: "ReasonID",
                principalTable: "Reasons",
                principalColumn: "ReasonID",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionReasons_Reasons_ReasonID1",
                table: "AdoptionReasons",
                column: "ReasonID1",
                principalTable: "Reasons",
                principalColumn: "ReasonID");

            migrationBuilder.AddForeignKey(
                name: "FK_Shelters_Cantons_CantonID",
                table: "Shelters",
                column: "CantonID",
                principalTable: "Cantons",
                principalColumn: "CantonID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionReasons_Reasons_ReasonID",
                table: "AdoptionReasons");

            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionReasons_Reasons_ReasonID1",
                table: "AdoptionReasons");

            migrationBuilder.DropForeignKey(
                name: "FK_Shelters_Cantons_CantonID",
                table: "Shelters");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Reasons",
                table: "Reasons");

            migrationBuilder.RenameTable(
                name: "Reasons",
                newName: "Reason");

            migrationBuilder.AlterColumn<int>(
                name: "CantonID",
                table: "Shelters",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Reason",
                table: "Reason",
                column: "ReasonID");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionReasons_Reason_ReasonID",
                table: "AdoptionReasons",
                column: "ReasonID",
                principalTable: "Reason",
                principalColumn: "ReasonID",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionReasons_Reason_ReasonID1",
                table: "AdoptionReasons",
                column: "ReasonID1",
                principalTable: "Reason",
                principalColumn: "ReasonID");

            migrationBuilder.AddForeignKey(
                name: "FK_Shelters_Cantons_CantonID",
                table: "Shelters",
                column: "CantonID",
                principalTable: "Cantons",
                principalColumn: "CantonID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
