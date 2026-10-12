using ktragiuaki.Debugging;

namespace ktragiuaki;

public class ktragiuakiConsts
{
    public const string LocalizationSourceName = "ktragiuaki";

    public const string ConnectionStringName = "Default";

    public const bool MultiTenancyEnabled = true;


    /// <summary>
    /// Default pass phrase for SimpleStringCipher decrypt/encrypt operations
    /// </summary>
    public static readonly string DefaultPassPhrase =
        DebugHelper.IsDebug ? "gsKxGZ012HLL3MI5" : "4053a96d25674fcf957c67bb9783242a";
}
