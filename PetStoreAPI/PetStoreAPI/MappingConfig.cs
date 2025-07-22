using AutoMapper;
using PetStoreAPI.Models;
using PetStoreAPI.Models.Dto;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetStoreAPI.Configurations
{
    public class MappingConfig
    {
        public static MapperConfiguration RegisterMaps()
        {
            var mappingConfig = new MapperConfiguration(config =>
            {
                // Users Mapping
                config.CreateMap<UsersDto, ApplicationUser>()
                    .ForMember(dest => dest.UserName, u => u.MapFrom(src => src.UserName))
                    .ForMember(dest => dest.Name, u => u.MapFrom(src => src.Name))
                    .ForMember(dest => dest.Surname, u => u.MapFrom(src => src.Surname))
                    .ForMember(dest => dest.Email, u => u.MapFrom(src => src.Email)).ReverseMap();

                config.CreateMap<ApplicationUser, UsersDto>()
                    .ForMember(dest => dest.UserName, u => u.MapFrom(src => src.UserName))
                    .ForMember(dest => dest.Name, u => u.MapFrom(src => src.Name))
                    .ForMember(dest => dest.Surname, u => u.MapFrom(src => src.Surname))
                    .ForMember(dest => dest.Email, u => u.MapFrom(src => src.Email)).ReverseMap();

                // Post Mapping
                config.CreateMap<PostDto, Post>()
                    .ForMember(dest => dest.ApplicationUser, opt => opt.MapFrom(src => src.User))
                    .ReverseMap()
                    .ForMember(dest => dest.User, opt => opt.MapFrom(src => src.ApplicationUser)).ReverseMap();



                config.CreateMap<AdoptionRequestDto, AdoptionRequest>()
                    .ForMember(dest => dest.RequesterUser, opt => opt.MapFrom(src => src.RequesterUser))
                    .ReverseMap()
                    .ForMember(dest => dest.RequesterUser, opt => opt.MapFrom(src => src.RequesterUser));



                

                // First, add the UserDto to ApplicationUser mapping
                config.CreateMap<UserDto, ApplicationUser>().ReverseMap();


            });
            return mappingConfig;
        }
    }
}