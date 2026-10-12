using Abp.Authorization;
using Abp.Runtime.Session;
using ktragiuaki.Configuration.Dto;
using System.Threading.Tasks;

namespace ktragiuaki.Configuration;

[AbpAuthorize]
public class ConfigurationAppService : ktragiuakiAppServiceBase, IConfigurationAppService
{
    public async Task ChangeUiTheme(ChangeUiThemeInput input)
    {
        await SettingManager.ChangeSettingForUserAsync(AbpSession.ToUserIdentifier(), AppSettingNames.UiTheme, input.Theme);
    }
}
