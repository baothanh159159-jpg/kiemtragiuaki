using Microsoft.EntityFrameworkCore;
using System.Data.Common;

namespace ktragiuaki.EntityFrameworkCore;

public static class ktragiuakiDbContextConfigurer
{
    public static void Configure(DbContextOptionsBuilder<ktragiuakiDbContext> builder, string connectionString)
    {
        builder.UseSqlServer(connectionString);
    }

    public static void Configure(DbContextOptionsBuilder<ktragiuakiDbContext> builder, DbConnection connection)
    {
        builder.UseSqlServer(connection);
    }
}
