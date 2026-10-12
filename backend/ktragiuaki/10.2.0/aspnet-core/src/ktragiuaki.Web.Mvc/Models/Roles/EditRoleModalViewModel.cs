using Abp.AutoMapper;
using ktragiuaki.Roles.Dto;
using ktragiuaki.Web.Models.Common;

namespace ktragiuaki.Web.Models.Roles;

[AutoMapFrom(typeof(GetRoleForEditOutput))]
public class EditRoleModalViewModel : GetRoleForEditOutput, IPermissionsEditViewModel
{
    public bool HasPermission(FlatPermissionDto permission)
    {
        return GrantedPermissionNames.Contains(permission.Name);
    }
}
