using ktragiuaki.Configuration.Dto;
using System.Threading.Tasks;

namespace ktragiuaki.Configuration;

public interface IConfigurationAppService
{
    Task ChangeUiTheme(ChangeUiThemeInput input);
}
