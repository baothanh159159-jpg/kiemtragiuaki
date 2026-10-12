using Abp.Application.Services;
using ktragiuaki.Authorization.Accounts.Dto;
using System.Threading.Tasks;

namespace ktragiuaki.Authorization.Accounts;

public interface IAccountAppService : IApplicationService
{
    Task<IsTenantAvailableOutput> IsTenantAvailable(IsTenantAvailableInput input);

    Task<RegisterOutput> Register(RegisterInput input);
}
