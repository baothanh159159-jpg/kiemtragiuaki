using ktragiuaki.Roles.Dto;
using System.Collections.Generic;

namespace ktragiuaki.Web.Models.Common;

public interface IPermissionsEditViewModel
{
    List<FlatPermissionDto> Permissions { get; set; }
}