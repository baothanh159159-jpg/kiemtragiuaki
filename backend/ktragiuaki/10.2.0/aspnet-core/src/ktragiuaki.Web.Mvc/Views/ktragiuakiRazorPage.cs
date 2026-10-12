using Abp.AspNetCore.Mvc.Views;
using Abp.Runtime.Session;
using Microsoft.AspNetCore.Mvc.Razor.Internal;

namespace ktragiuaki.Web.Views;

public abstract class ktragiuakiRazorPage<TModel> : AbpRazorPage<TModel>
{
    [RazorInject]
    public IAbpSession AbpSession { get; set; }

    protected ktragiuakiRazorPage()
    {
        LocalizationSourceName = ktragiuakiConsts.LocalizationSourceName;
    }
}
