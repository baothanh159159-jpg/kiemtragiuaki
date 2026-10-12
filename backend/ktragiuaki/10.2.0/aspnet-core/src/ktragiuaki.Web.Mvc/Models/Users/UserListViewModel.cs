using ktragiuaki.Roles.Dto;
using System.Collections.Generic;

namespace ktragiuaki.Web.Models.Users;

public class UserListViewModel
{
    public IReadOnlyList<RoleDto> Roles { get; set; }
}
