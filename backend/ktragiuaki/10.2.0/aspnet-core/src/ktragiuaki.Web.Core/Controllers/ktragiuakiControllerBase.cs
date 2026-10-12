using Abp.AspNetCore.Mvc.Controllers;
using Abp.IdentityFramework;
using Microsoft.AspNetCore.Identity;

namespace ktragiuaki.Controllers
{
    public abstract class ktragiuakiControllerBase : AbpController
    {
        protected ktragiuakiControllerBase()
        {
            LocalizationSourceName = ktragiuakiConsts.LocalizationSourceName;
        }

        protected void CheckErrors(IdentityResult identityResult)
        {
            identityResult.CheckErrors(LocalizationManager);
        }
    }
}
