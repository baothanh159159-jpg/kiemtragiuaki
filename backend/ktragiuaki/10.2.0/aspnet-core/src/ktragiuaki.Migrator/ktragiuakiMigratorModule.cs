using Abp.Events.Bus;
using Abp.Modules;
using Abp.Reflection.Extensions;
using ktragiuaki.Configuration;
using ktragiuaki.EntityFrameworkCore;
using ktragiuaki.Migrator.DependencyInjection;
using Castle.MicroKernel.Registration;
using Microsoft.Extensions.Configuration;

namespace ktragiuaki.Migrator;

[DependsOn(typeof(ktragiuakiEntityFrameworkModule))]
public class ktragiuakiMigratorModule : AbpModule
{
    private readonly IConfigurationRoot _appConfiguration;

    public ktragiuakiMigratorModule(ktragiuakiEntityFrameworkModule abpProjectNameEntityFrameworkModule)
    {
        abpProjectNameEntityFrameworkModule.SkipDbSeed = true;

        _appConfiguration = AppConfigurations.Get(
            typeof(ktragiuakiMigratorModule).GetAssembly().GetDirectoryPathOrNull()
        );
    }

    public override void PreInitialize()
    {
        Configuration.DefaultNameOrConnectionString = _appConfiguration.GetConnectionString(
            ktragiuakiConsts.ConnectionStringName
        );

        Configuration.BackgroundJobs.IsJobExecutionEnabled = false;
        Configuration.ReplaceService(
            typeof(IEventBus),
            () => IocManager.IocContainer.Register(
                Component.For<IEventBus>().Instance(NullEventBus.Instance)
            )
        );
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof(ktragiuakiMigratorModule).GetAssembly());
        ServiceCollectionRegistrar.Register(IocManager);
    }
}
