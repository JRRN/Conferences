using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace Infraestructure.Data.Migrations
{
    public partial class InitialCreate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "UserConferences",
                columns: table => new
                {
                    IdUserConference = table.Column<Guid>(nullable: false),
                    Nombre = table.Column<string>(nullable: true),
                    Genero = table.Column<string>(nullable: true),
                    Edad = table.Column<int>(nullable: false),
                    Horoscopo = table.Column<string>(nullable: true),
                    Fecha = table.Column<DateTime>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserConferences", x => x.IdUserConference);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserConferences");
        }
    }
}
