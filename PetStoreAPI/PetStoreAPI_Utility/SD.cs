using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PetStoreAPI_Utility
{
    public static class SD
    {
        public static string PetStoreAPIBase { get; set; }
        public enum ApiType
        {
            GET,
            POST,
            PUT,
            DELETE
        }
        public const string TokenCookie = "JWTToken";
        public static string AccessToken = "JWTToken";
        public static string RefreshToken = "RefreshToken";
        public static string CurrentAPIVersion = "v2";
        public const string User = "USER";
        public enum ContentType
        {
            Json,
            MultipartFormData,
        }

        public enum RequestStatus
        {
            Pending,
            Approved,
            Rejected
        }
    }
}
