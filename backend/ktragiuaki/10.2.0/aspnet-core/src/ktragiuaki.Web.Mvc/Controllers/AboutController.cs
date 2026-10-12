using Abp.AspNetCore.Mvc.Authorization;
using ktragiuaki.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace ktragiuaki.Web.Controllers;

[AbpMvcAuthorize]
public class AboutController : ktragiuakiControllerBase
{
    public ActionResult Index()
    {
        return View();
    }
}
