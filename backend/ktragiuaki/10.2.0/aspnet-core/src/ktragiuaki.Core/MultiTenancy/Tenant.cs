using Abp.MultiTenancy;
using ktragiuaki.Authorization.Users;

namespace ktragiuaki.MultiTenancy;

public class Tenant : AbpTenant<User>
{
    public Tenant()
    {
    }

    public Tenant(string tenancyName, string name)
        : base(tenancyName, name)
    {
    }
}
