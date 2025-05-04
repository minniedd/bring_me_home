using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class userdb : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Adopters_Cantons_CantonID",
                table: "Adopters");

            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Adopters_AdopterID",
                table: "AdoptionApplications");

            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Adopters_AdopterID1",
                table: "AdoptionApplications");

            migrationBuilder.DropIndex(
                name: "IX_AdoptionApplications_AdopterID1",
                table: "AdoptionApplications");

            migrationBuilder.DropColumn(
                name: "AdopterID1",
                table: "AdoptionApplications");

            migrationBuilder.DropColumn(
                name: "DateRegistered",
                table: "Adopters");

            migrationBuilder.DropColumn(
                name: "Email",
                table: "Adopters");

            migrationBuilder.DropColumn(
                name: "FirstName",
                table: "Adopters");

            migrationBuilder.DropColumn(
                name: "LastName",
                table: "Adopters");

            migrationBuilder.DropColumn(
                name: "ZipCode",
                table: "Adopters");

            migrationBuilder.AddColumn<string>(
                name: "Address",
                table: "Users",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "CityID",
                table: "Users",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "AdopterID",
                table: "AdoptionApplications",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "UserID",
                table: "AdoptionApplications",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AlterColumn<int>(
                name: "CantonID",
                table: "Adopters",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.CreateIndex(
                name: "IX_Users_CityID",
                table: "Users",
                column: "CityID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_UserID",
                table: "AdoptionApplications",
                column: "UserID");

            migrationBuilder.AddForeignKey(
                name: "FK_Adopters_Cantons_CantonID",
                table: "Adopters",
                column: "CantonID",
                principalTable: "Cantons",
                principalColumn: "CantonID");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Adopters_AdopterID",
                table: "AdoptionApplications",
                column: "AdopterID",
                principalTable: "Adopters",
                principalColumn: "AdopterID");

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Users_UserID",
                table: "AdoptionApplications",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Cities_CityID",
                table: "Users",
                column: "CityID",
                principalTable: "Cities",
                principalColumn: "CityID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Adopters_Cantons_CantonID",
                table: "Adopters");

            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Adopters_AdopterID",
                table: "AdoptionApplications");

            migrationBuilder.DropForeignKey(
                name: "FK_AdoptionApplications_Users_UserID",
                table: "AdoptionApplications");

            migrationBuilder.DropForeignKey(
                name: "FK_Users_Cities_CityID",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_Users_CityID",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_AdoptionApplications_UserID",
                table: "AdoptionApplications");

            migrationBuilder.DropColumn(
                name: "Address",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "CityID",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "UserID",
                table: "AdoptionApplications");

            migrationBuilder.AlterColumn<int>(
                name: "AdopterID",
                table: "AdoptionApplications",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "AdopterID1",
                table: "AdoptionApplications",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "CantonID",
                table: "Adopters",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "DateRegistered",
                table: "Adopters",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "Email",
                table: "Adopters",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "FirstName",
                table: "Adopters",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "LastName",
                table: "Adopters",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ZipCode",
                table: "Adopters",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_AdopterID1",
                table: "AdoptionApplications",
                column: "AdopterID1");

            migrationBuilder.AddForeignKey(
                name: "FK_Adopters_Cantons_CantonID",
                table: "Adopters",
                column: "CantonID",
                principalTable: "Cantons",
                principalColumn: "CantonID",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Adopters_AdopterID",
                table: "AdoptionApplications",
                column: "AdopterID",
                principalTable: "Adopters",
                principalColumn: "AdopterID",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AdoptionApplications_Adopters_AdopterID1",
                table: "AdoptionApplications",
                column: "AdopterID1",
                principalTable: "Adopters",
                principalColumn: "AdopterID");
        }
    }
}
