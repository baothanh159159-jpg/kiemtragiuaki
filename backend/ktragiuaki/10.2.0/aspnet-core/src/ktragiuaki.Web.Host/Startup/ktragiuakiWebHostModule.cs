using Abp.Modules;
using Abp.Reflection.Extensions;
using ktragiuaki.Configuration;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;

namespace ktragiuaki.Web.Host.Startup
{
    [DependsOn(
       typeof(ktragiuakiWebCoreModule))]
    public class ktragiuakiWebHostModule : AbpModule
    {
        private readonly IWebHostEnvironment _env;
        private readonly IConfigurationRoot _appConfiguration;

        public ktragiuakiWebHostModule(IWebHostEnvironment env)
        {
            _env = env;
            _appConfiguration = env.GetAppConfiguration();
        }

        public override void Initialize()
        {
            IocManager.RegisterAssemblyByConvention(typeof(ktragiuakiWebHostModule).GetAssembly());
        }
    }
}
