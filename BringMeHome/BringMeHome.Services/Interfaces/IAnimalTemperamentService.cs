﻿using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IAnimalTemperamentService
    {
        Task<PagedResult<AnimalTemperamentResponse>> GetAsync(AnimalTemperamentSearchObject search);
        Task<List<AnimalTemperamentResponse>> GetAllAsync();
        Task<AnimalTemperamentResponse?> GetByIdAsync(int id);
        Task<AnimalTemperamentResponse> CreateAsync(AnimalTemperamentRequest request);
        Task<AnimalTemperamentResponse?> UpdateAsync(int id, AnimalTemperamentRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
