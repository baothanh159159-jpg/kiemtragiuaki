using Abp.AspNetCore.Mvc.ViewComponents;

namespace ktragiuaki.Web.Views;

public abstract class ktragiuakiViewComponent : AbpViewComponent
{
    protected ktragiuakiViewComponent()
    {
        LocalizationSourceName = ktragiuakiConsts.LocalizationSourceName;
    }
}
