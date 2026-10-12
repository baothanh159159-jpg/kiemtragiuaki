using Abp.AutoMapper;
using Abp.Modules;
using Abp.Reflection.Extensions;
using ktragiuaki.Authorization;

namespace ktragiuaki;

[DependsOn(
    typeof(ktragiuakiCoreModule),
    typeof(AbpAutoMapperModule))]
public class ktragiuakiApplicationModule : AbpModule
{
    public override void PreInitialize()
    {
        Configuration.Authorization.Providers.Add<ktragiuakiAuthorizationProvider>();
    }

    public override void Initialize()
    {
        var thisAssembly = typeof(ktragiuakiApplicationModule).GetAssembly();

        IocManager.RegisterAssemblyByConvention(thisAssembly);

        Configuration.Modules.AbpAutoMapper().Configurators.Add(
            // Scan the assembly for classes which inherit from AutoMapper.Profile
            cfg => cfg.AddMaps(thisAssembly)
        );
    }
}
