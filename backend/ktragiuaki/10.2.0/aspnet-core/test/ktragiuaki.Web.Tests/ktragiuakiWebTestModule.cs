using Abp.AspNetCore;
using Abp.AspNetCore.TestBase;
using Abp.Modules;
using Abp.Reflection.Extensions;
using ktragiuaki.EntityFrameworkCore;
using ktragiuaki.Web.Startup;
using Microsoft.AspNetCore.Mvc.ApplicationParts;

namespace ktragiuaki.Web.Tests;

[DependsOn(
    typeof(ktragiuakiWebMvcModule),
    typeof(AbpAspNetCoreTestBaseModule)
)]
public class ktragiuakiWebTestModule : AbpModule
{
    public ktragiuakiWebTestModule(ktragiuakiEntityFrameworkModule abpProjectNameEntityFrameworkModule)
    {
        abpProjectNameEntityFrameworkModule.SkipDbContextRegistration = true;
    }

    public override void PreInitialize()
    {
        Configuration.UnitOfWork.IsTransactional = false; //EF Core InMemory DB does not support transactions.
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof(ktragiuakiWebTestModule).GetAssembly());
    }

    public override void PostInitialize()
    {
        IocManager.Resolve<ApplicationPartManager>()
            .AddApplicationPartsIfNotAddedBefore(typeof(ktragiuakiWebMvcModule).Assembly);
    }
}