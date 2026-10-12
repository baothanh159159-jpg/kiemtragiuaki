using ktragiuaki.Roles.Dto;
using System.Collections.Generic;

namespace ktragiuaki.Web.Models.Roles;

public class RoleListViewModel
{
    public IReadOnlyList<PermissionDto> Permissions { get; set; }
}
