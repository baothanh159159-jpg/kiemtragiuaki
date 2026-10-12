using Abp.Zero.EntityFrameworkCore;
using ktragiuaki.Authorization.Roles;
using ktragiuaki.Authorization.Users;
using ktragiuaki.MultiTenancy;
using Microsoft.EntityFrameworkCore;

namespace ktragiuaki.EntityFrameworkCore;

public class ktragiuakiDbContext : AbpZeroDbContext<Tenant, Role, User, ktragiuakiDbContext>
{
    /* Define a DbSet for each entity of the application */

    public ktragiuakiDbContext(DbContextOptions<ktragiuakiDbContext> options)
        : base(options)
    {
    }
}
