using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class changes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Animals_Species_SpeciesID",
                table: "Animals");

            migrationBuilder.AlterColumn<int>(
                name: "SpeciesID",
                table: "Animals",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Animals_Species_SpeciesID",
                table: "Animals",
                column: "SpeciesID",
                principalTable: "Species",
                principalColumn: "SpeciesID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Animals_Species_SpeciesID",
                table: "Animals");

            migrationBuilder.AlterColumn<int>(
                name: "SpeciesID",
                table: "Animals",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Animals_Species_SpeciesID",
                table: "Animals",
                column: "SpeciesID",
                principalTable: "Species",
                principalColumn: "SpeciesID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
