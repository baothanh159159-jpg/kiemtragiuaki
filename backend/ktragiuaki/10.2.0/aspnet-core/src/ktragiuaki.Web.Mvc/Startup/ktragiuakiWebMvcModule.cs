using Abp.Modules;
using Abp.Reflection.Extensions;
using ktragiuaki.Configuration;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;

namespace ktragiuaki.Web.Startup;

[DependsOn(typeof(ktragiuakiWebCoreModule))]
public class ktragiuakiWebMvcModule : AbpModule
{
    private readonly IWebHostEnvironment _env;
    private readonly IConfigurationRoot _appConfiguration;

    public ktragiuakiWebMvcModule(IWebHostEnvironment env)
    {
        _env = env;
        _appConfiguration = env.GetAppConfiguration();
    }

    public override void PreInitialize()
    {
        Configuration.Navigation.Providers.Add<ktragiuakiNavigationProvider>();
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof(ktragiuakiWebMvcModule).GetAssembly());
    }
}
