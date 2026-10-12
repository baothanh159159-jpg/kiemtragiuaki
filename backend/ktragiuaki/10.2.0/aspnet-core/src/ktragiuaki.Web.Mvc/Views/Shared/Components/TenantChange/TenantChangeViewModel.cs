using Abp.AutoMapper;
using ktragiuaki.Sessions.Dto;

namespace ktragiuaki.Web.Views.Shared.Components.TenantChange;

[AutoMapFrom(typeof(GetCurrentLoginInformationsOutput))]
public class TenantChangeViewModel
{
    public TenantLoginInfoDto Tenant { get; set; }
}
