using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class faves : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AnimalColors_Animals_AnimalID",
                table: "AnimalColors");

            migrationBuilder.DropForeignKey(
                name: "FK_AnimalTemperamentJunctions_Animals_AnimalID",
                table: "AnimalTemperamentJunctions");

            migrationBuilder.CreateTable(
                name: "UserAnimalFavorites",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    AnimalId = table.Column<int>(type: "int", nullable: false),
                    DateFavorited = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserAnimalFavorites", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserAnimalFavorites_Animals_AnimalId",
                        column: x => x.AnimalId,
                        principalTable: "Animals",
                        principalColumn: "AnimalID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserAnimalFavorites_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserAnimalFavorites_AnimalId",
                table: "UserAnimalFavorites",
                column: "AnimalId");

            migrationBuilder.CreateIndex(
                name: "IX_UserAnimalFavorites_UserId",
                table: "UserAnimalFavorites",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_AnimalColors_Animals_AnimalID",
                table: "AnimalColors",
                column: "AnimalID",
                principalTable: "Animals",
                principalColumn: "AnimalID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AnimalTemperamentJunctions_Animals_AnimalID",
                table: "AnimalTemperamentJunctions",
                column: "AnimalID",
                principalTable: "Animals",
                principalColumn: "AnimalID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AnimalColors_Animals_AnimalID",
                table: "AnimalColors");

            migrationBuilder.DropForeignKey(
                name: "FK_AnimalTemperamentJunctions_Animals_AnimalID",
                table: "AnimalTemperamentJunctions");

            migrationBuilder.DropTable(
                name: "UserAnimalFavorites");

            migrationBuilder.AddForeignKey(
                name: "FK_AnimalColors_Animals_AnimalID",
                table: "AnimalColors",
                column: "AnimalID",
                principalTable: "Animals",
                principalColumn: "AnimalID",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AnimalTemperamentJunctions_Animals_AnimalID",
                table: "AnimalTemperamentJunctions",
                column: "AnimalID",
                principalTable: "Animals",
                principalColumn: "AnimalID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
