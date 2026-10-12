using Abp.Configuration.Startup;
using Abp.Localization.Dictionaries;
using Abp.Localization.Dictionaries.Xml;
using Abp.Reflection.Extensions;

namespace ktragiuaki.Localization;

public static class ktragiuakiLocalizationConfigurer
{
    public static void Configure(ILocalizationConfiguration localizationConfiguration)
    {
        localizationConfiguration.Sources.Add(
            new DictionaryBasedLocalizationSource(ktragiuakiConsts.LocalizationSourceName,
                new XmlEmbeddedFileLocalizationDictionaryProvider(
                    typeof(ktragiuakiLocalizationConfigurer).GetAssembly(),
                    "ktragiuaki.Localization.SourceFiles"
                )
            )
        );
    }
}
