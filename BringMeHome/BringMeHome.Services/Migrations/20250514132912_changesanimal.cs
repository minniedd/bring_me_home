using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class changesanimal : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AnimalColors");

            migrationBuilder.DropTable(
                name: "AnimalTemperamentJunctions");

            migrationBuilder.AddColumn<int>(
                name: "ColorID",
                table: "Animals",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "TempermentID",
                table: "Animals",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Animals_ColorID",
                table: "Animals",
                column: "ColorID");

            migrationBuilder.CreateIndex(
                name: "IX_Animals_TempermentID",
                table: "Animals",
                column: "TempermentID");

            migrationBuilder.AddForeignKey(
                name: "FK_Animals_AnimalTemperaments_TempermentID",
                table: "Animals",
                column: "TempermentID",
                principalTable: "AnimalTemperaments",
                principalColumn: "TemperamentID");

            migrationBuilder.AddForeignKey(
                name: "FK_Animals_Colors_ColorID",
                table: "Animals",
                column: "ColorID",
                principalTable: "Colors",
                principalColumn: "ColorID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Animals_AnimalTemperaments_TempermentID",
                table: "Animals");

            migrationBuilder.DropForeignKey(
                name: "FK_Animals_Colors_ColorID",
                table: "Animals");

            migrationBuilder.DropIndex(
                name: "IX_Animals_ColorID",
                table: "Animals");

            migrationBuilder.DropIndex(
                name: "IX_Animals_TempermentID",
                table: "Animals");

            migrationBuilder.DropColumn(
                name: "ColorID",
                table: "Animals");

            migrationBuilder.DropColumn(
                name: "TempermentID",
                table: "Animals");

            migrationBuilder.CreateTable(
                name: "AnimalColors",
                columns: table => new
                {
                    AnimalColorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AnimalID = table.Column<int>(type: "int", nullable: false),
                    ColorID = table.Column<int>(type: "int", nullable: false),
                    AnimalID1 = table.Column<int>(type: "int", nullable: true),
                    ColorID1 = table.Column<int>(type: "int", nullable: true),
                    IsPrimary = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalColors", x => x.AnimalColorID);
                    table.ForeignKey(
                        name: "FK_AnimalColors_Animals_AnimalID",
                        column: x => x.AnimalID,
                        principalTable: "Animals",
                        principalColumn: "AnimalID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AnimalColors_Animals_AnimalID1",
                        column: x => x.AnimalID1,
                        principalTable: "Animals",
                        principalColumn: "AnimalID");
                    table.ForeignKey(
                        name: "FK_AnimalColors_Colors_ColorID",
                        column: x => x.ColorID,
                        principalTable: "Colors",
                        principalColumn: "ColorID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AnimalColors_Colors_ColorID1",
                        column: x => x.ColorID1,
                        principalTable: "Colors",
                        principalColumn: "ColorID");
                });

            migrationBuilder.CreateTable(
                name: "AnimalTemperamentJunctions",
                columns: table => new
                {
                    JunctionID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AnimalID = table.Column<int>(type: "int", nullable: false),
                    AssessedByID = table.Column<int>(type: "int", nullable: true),
                    TemperamentID = table.Column<int>(type: "int", nullable: false),
                    AnimalID1 = table.Column<int>(type: "int", nullable: true),
                    AnimalTemperamentTemperamentID = table.Column<int>(type: "int", nullable: true),
                    AssessmentDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Notes = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    Rating = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalTemperamentJunctions", x => x.JunctionID);
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_AnimalTemperaments_AnimalTemperamentTemperamentID",
                        column: x => x.AnimalTemperamentTemperamentID,
                        principalTable: "AnimalTemperaments",
                        principalColumn: "TemperamentID");
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_AnimalTemperaments_TemperamentID",
                        column: x => x.TemperamentID,
                        principalTable: "AnimalTemperaments",
                        principalColumn: "TemperamentID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_Animals_AnimalID",
                        column: x => x.AnimalID,
                        principalTable: "Animals",
                        principalColumn: "AnimalID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_Animals_AnimalID1",
                        column: x => x.AnimalID1,
                        principalTable: "Animals",
                        principalColumn: "AnimalID");
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_Staff_AssessedByID",
                        column: x => x.AssessedByID,
                        principalTable: "Staff",
                        principalColumn: "StaffID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AnimalColors_AnimalID",
                table: "AnimalColors",
                column: "AnimalID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalColors_AnimalID1",
                table: "AnimalColors",
                column: "AnimalID1");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalColors_ColorID",
                table: "AnimalColors",
                column: "ColorID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalColors_ColorID1",
                table: "AnimalColors",
                column: "ColorID1");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_AnimalID",
                table: "AnimalTemperamentJunctions",
                column: "AnimalID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_AnimalID1",
                table: "AnimalTemperamentJunctions",
                column: "AnimalID1");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_AnimalTemperamentTemperamentID",
                table: "AnimalTemperamentJunctions",
                column: "AnimalTemperamentTemperamentID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_AssessedByID",
                table: "AnimalTemperamentJunctions",
                column: "AssessedByID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_TemperamentID",
                table: "AnimalTemperamentJunctions",
                column: "TemperamentID");
        }
    }
}
