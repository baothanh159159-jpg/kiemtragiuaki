using Abp.Application.Services;
using ktragiuaki.MultiTenancy.Dto;

namespace ktragiuaki.MultiTenancy;

public interface ITenantAppService : IAsyncCrudAppService<TenantDto, int, PagedTenantResultRequestDto, CreateTenantDto, TenantDto>
{
}

