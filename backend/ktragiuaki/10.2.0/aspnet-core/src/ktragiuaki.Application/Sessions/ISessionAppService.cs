using Abp.Application.Services;
using ktragiuaki.Sessions.Dto;
using System.Threading.Tasks;

namespace ktragiuaki.Sessions;

public interface ISessionAppService : IApplicationService
{
    Task<GetCurrentLoginInformationsOutput> GetCurrentLoginInformations();
}
