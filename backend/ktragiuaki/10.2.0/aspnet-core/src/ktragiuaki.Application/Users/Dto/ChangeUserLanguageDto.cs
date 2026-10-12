using System.ComponentModel.DataAnnotations;

namespace ktragiuaki.Users.Dto;

public class ChangeUserLanguageDto
{
    [Required]
    public string LanguageName { get; set; }
}