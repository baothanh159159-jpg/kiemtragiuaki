using Abp.Authorization;
using ktragiuaki.Authorization.Roles;
using ktragiuaki.Authorization.Users;

namespace ktragiuaki.Authorization;

public class PermissionChecker : PermissionChecker<Role, User>
{
    public PermissionChecker(UserManager userManager)
        : base(userManager)
    {
    }
}
