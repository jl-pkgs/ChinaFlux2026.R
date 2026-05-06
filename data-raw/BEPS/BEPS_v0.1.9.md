This file is a merged representation of a subset of the codebase, containing specifically included files and files not matching ignore patterns, combined into a single document by Repomix.

# File Summary

## Purpose
This file contains a packed representation of a subset of the repository's contents that is considered the most important context.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Only files matching these patterns are included: *.jl, */*.jl, */*/*.jl
- Files matching these patterns are excluded: backup, clang
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)

# Directory Structure
```
aerodynamic_conductance_V2.jl
aerodynamic_conductance.jl
beps_main.jl
beps_modern.jl
BEPS_modules.jl
beps_optimize.jl
BEPS.jl
DataType/AeroConsts.jl
DataType/BEPS_State.jl
DataType/CanopyLayer.jl
DataType/Constant.jl
DataType/DataType.jl
DataType/LeafCache.jl
DataType/macro.jl
DataType/Met.jl
DataType/OUTPUT.jl
DataType/Params/BEPS_Param.jl
DataType/Params/GlobalData.jl
DataType/Params/macro.jl
DataType/Params/Param_Init.jl
DataType/Params/ParamPhoto.jl
DataType/Params/Params.jl
DataType/PhotoConsts.jl
DataType/setup.jl
DataType/StateSeries.jl
evaporation_canopy.jl
evaporation_soil.jl
heat_H_and_LE.jl
inter_prg.jl
netRadiation.jl
photosynthesis_helper.jl
photosynthesis.jl
rainfall_stage.jl
snowpack.jl
SoilPhysics/soil_water_factor_v2.jl
SoilPhysics/SoilPhysics.jl
SoilPhysics/UpdateHeatFlux.jl
SoilPhysics/UpdateSoilMoisture.jl
SPAC/BEPS_helper.jl
SPAC/helper.jl
SPAC/lai2.jl
SPAC/Leaf.jl
SPAC/snow_density.jl
SPAC/SPAC.jl
SPAC/ultilize.jl
SPAC/VCmax.jl
standalone/Photosynthesis/core.jl
standalone/Photosynthesis/helper.jl
standalone/Photosynthesis/photosynthesis.jl
standalone/Photosynthesis/radiation.jl
standalone/Photosynthesis/stomatal.jl
standalone/Photosynthesis/temperature.jl
standalone/Photosynthesis/types.jl
standalone/UpdateSoilMoisture.jl
surface_temperature.jl
```

# Files

## File: aerodynamic_conductance_V2.jl
````julia
# Psi_h
function cal_Ψh(ξ::FT, L::FT) where {FT<:AbstractFloat}
  # Bonan 2019, Eq 6.47
  if L >= 0
    Ψ_h = -5 * ξ
  else
    x::FT = (1 - 16 * ξ)^0.25
    Ψ_h = 2 * log((1 + x^2) / 2)
  end
  return Ψ_h
end

# phi_h
function cal_ϕh(ξ::FT, L::FT) where {FT<:AbstractFloat}
  # Bonan 2019, Eq 6.38
  if L > 0
    ϕ = 1 + 5 * ξ
  else
    ϕ = (1 - 16 * ξ)^(-0.5)
  end
  return ϕ
end


function cal_Nu(u::FT, nu_lower::FT)::FT
  # lw::T = 0.3 # leaf characteristic width =0.3 for BS
  # sigma::T = 5 # shelter factor =5 for BS
  # Re = (ud * lw / sigma) / nu_lower
  Re::FT = (u * 0.1) / nu_lower # Reynold's number
  Nu::FT = 1.0 * Re^0.5 # Nusselt number
  Nu
end

function ra_leaf_boundary(Tair::FT, u::FT)::FT
  nu_lower::FT = (13.3 + Tair * 0.07) / 1000000  # viscosity (cm2/s)
  alfaw::FT = (18.9 + Tair * 0.07) / 1000000

  Nu = cal_Nu(u, nu_lower)
  rb = min(40, 0.5 * 0.1 / (alfaw * Nu)) # leaf boundary resistance, [s m-1], `rb_o` or `rb_u`
  return rb
end


function aerodynamic_conductance_jl(h::FT, h_u::FT, z_wind::FT, clumping::FT,
  Tair::FT, u::FT, H::FT, lai_o::FT, lai_u::FT=0.0)

  k::FT = 0.4   # von Karman's constant
  cp::FT = 1010 # specific heat of air (J/kg/K)
  ρ_air::FT = 1.225 # density of air at 15 C (kg/m3)
  g::FT = 9.8 # gravitational acceleration (m/s2)

  # if wind_sp == 0.0
  G_o_a = 1 / 200.0
  G_o_b = 1 / 200.0
  G_u_a = 1 / 200.0
  G_u_b = 1 / 200.0
  ra_g = 300.0
  ra_u = 0.0
  ra_o = 0.0

  u == 0 && return ra_o, ra_u, ra_g, G_o_a, G_o_b, G_u_a, G_u_b

  ## this is else
  d::FT = 0.8 * h   # displacement height (m)
  z0m::FT = 0.08 * h  # momentum roughness length; ≈0.1h (Chen 1999)
  z0h::FT = 0.1 * z0m               # heat roughness length; kB⁻¹ ≈ 2.3

  ustar::FT = u * k / log((z_wind - d) / z0m) # TODO: Ψ_m is ignored here, friction velocity (m/s)

  L::FT = -(ρ_air * cp * (Tair + 273.3) * ustar^3) / (k * g * H)
  L = clamp(L, -1e6, 1e6)  # guard against H≈0
  ξ::FT = clamp((z_wind - d) / L, -2.0, 1.0)  # Bonan Figure 6.3

  Ψ_h = cal_Ψh(ξ, L)

  ra_o::FT = 1 / (k * ustar) * (log((z_wind - d) / z0h) - Ψ_h)
  ra_o = clamp(ra_o, 2.0, 500.0)

  # Bonan 2019, Eq 6.38
  ψ = cal_ϕh(ξ, L)
  ψ = min(10.0, ψ)

  #******** Leaf boundary layer resistance ******************/
  # Wind speed at tree top */
  u_h::FT = 1.1 * ustar / k  # wind speed at height h
  Le = lai_o * clumping

  ## 1. overstory
  gamma_o_m = (0.167 + 0.179 * u_h) * Le^(1.0 / 3.0)
  u_o = u_h * exp(-gamma_o_m * (1.0 - d / h))  # u(d) taking as the mean wind speed inside a stand */
  rb_o = ra_leaf_boundary(Tair, u_o)

  ## 2. Understory (林下层与树干空间)
  gamma_o_h = 0.1 + lai_o^0.75   # h ~ h_u之间主林冠下部及树干对湍流的阻滞 (使用 lai_o)
  gamma_u_m = 0.1 + lai_u^0.75     # h_u ~ 0之间林下层对湍流的阻滞 (使用 lai_u)

  u_hu = u_h * exp(-gamma_o_m * (1.0 - h_u / h)) # 风速衰减至林下层顶部 (h_u)
  u_u = u_hu * exp(-gamma_u_m * (1.0 - h_u * 0.8 / h_u)) # 简化为 exp(-gamma_u_m * 0.2) 亦可
  rb_u = ra_leaf_boundary(Tair, u_u)

  kh_o = 0.41 * ustar * (h - h * 0.8) / ψ # 主林冠顶部涡流扩散系数

  # h~h_u 之间的气动阻力 (介质为主林冠下部，使用 gamma_trunk)
  ra_u = h / (gamma_o_h * kh_o) * (exp(gamma_o_h * (1.0 - h_u / h)) - 1.0)

  ## 3. Ground (极近地表层)
  # K_h 从 h 衰减至 h_u (同样穿越主林冠下部，使用 gamma_trunk)
  kh_u = kh_o * exp(-gamma_o_h * (1.0 - h_u / h))

  gamma_g_h = 4.0
  # 林下层底部到地表的气动阻力 (完美的闭合公式)
  ra_g = h_u / (gamma_g_h * kh_u) * (exp(gamma_g_h) - 1.0)



  # 后处理
  ra_g = ra_g + ra_u + ra_o
  ra_g = max(120, ra_g)

  G_o_a = 1.0 / ra_o
  G_o_b = 1.0 / rb_o

  G_u_a = 1.0 / (ra_o + ra_u)
  G_u_b = 1.0 / rb_u
  return ra_o, ra_u, ra_g, G_o_a, G_o_b, G_u_a, G_u_b
end
````

## File: aerodynamic_conductance.jl
````julia
"""
    aerodynamic_conductance_jl(canopy_height_o::FT, canopy_height_u::FT,
        z_wind::FT, clumping::FT,
        Tair::FT, wind_sp::FT, SH_o_p::FT, lai_o::FT, lai_u::FT=0.0)

# Examples
```julia
canopyh_o = 2.0
canopyh_u = 0.2
height_wind_sp = 2.0
clumping = 0.8
Ta = 20.0
wind_sp = 2.
GH_o = 100.0
lai_o = 4.0
lai_u = 2.0

ra_o, ra_u, ra_g, Ga_o, Gb_o, Ga_u, Gb_u =
  aerodynamic_conductance_jl(canopyh_o, canopyh_u, height_wind_sp, clumping, Ta, wind_sp, GH_o,
    lai_o, lai_u)
r1 = (; ra_o, ra_u, ra_g, Ga_o, Gb_o, Ga_u, Gb_u)
```
"""
function aerodynamic_conductance_jl(canopy_height_o::FT, canopy_height_u::FT,
  z_wind::FT, clumping::FT,
  Tair::FT, wind_sp::FT, SH_o_p::FT, lai_o::FT, lai_u::FT=0.0)

  # beta::FT = 0.5 # Bowen's ratio
  k::FT = 0.4   # von Karman's constant
  cp::FT = 1010 # specific heat of air (J/kg/K)
  density_air::FT = 1.225 # density of air at 15 C (kg/m3)
  gg::FT = 9.8 # gravitational acceleration (m/s2)
  n::FT = 5.0
  nu_lower::FT = (13.3 + Tair * 0.07) / 1000000  # viscosity (cm2/s)
  alfaw::FT = (18.9 + Tair * 0.07) / 1000000

  @fastmath if wind_sp == 0
    G_o_a = 1 / 200.0
    G_o_b = 1 / 200.0
    G_u_a = 1 / 200.0
    G_u_b = 1 / 200.0
    ra_g = 300.0
    ra_u = 0.0
    ra_o = 0.0
  else
    d::FT = 0.8 * canopy_height_o  # displacement height (m)
    z0::FT = 0.08 * canopy_height_o # roughness length (m)

    ustar::FT = wind_sp * k / log((z_wind - d) / z0) # friction velocity (m/s)
    L::FT = -(k * gg * SH_o_p) / (density_air * cp * (Tair + 273.3) * ustar^3)
    L = max(-2.0, L)

    ra_o::FT = 1 / (k * ustar) * (log((z_wind - d) / z0) + (n * (z_wind - d) * L))
    ra_o = clamp(ra_o, 2, 100)
    
    if L > 0
      ψ = 1 + 5 * (z_wind - d) * L
    else
      ψ = (1 - 16 * (z_wind - d) * L)^(-0.5)
    end
    ψ = min(10.0, ψ)

    #******** Leaf boundary layer resistance ******************/
    # Wind speed at tree top */
    uh::FT = 1.1 * ustar / k  # wind speed at height h
    Le = lai_o * clumping
    gamma = (0.167 + 0.179 * uh) * Le^(1.0 / 3.0)

    # Wind speed at d, taking as the mean wind speed inside a stand */
    ud = uh * exp(-gamma * (1 - d / canopy_height_o))

    Nu = cal_Nu(ud, nu_lower)
    rb_o = min(40, 0.5 * 0.1 / (alfaw * Nu)) # leaf boundary resistance

    # uf = ustar
    G_o_a = 1.0 / ra_o
    G_o_b = 1.0 / rb_o

    gamma = 0.1 + lai_o^0.75
    kh_o = 0.41 * ustar * (canopy_height_o - canopy_height_o * 0.8) / ψ

    # wind speed at the zero displacement of canopy
    un_d = uh * exp(-gamma * (1 - canopy_height_u * 0.8 / canopy_height_o))
    # # wind speed at the zero displacement of canopy
    # un_t = uh * exp(-gamma * (1 - canopy_height_u / canopy_height_o))
    Nu = cal_Nu(un_d, nu_lower)
    rb_u = min(40, 0.5 * 0.1 / (alfaw * Nu)) # leaf boundary resistance
    G_u_b = 1.0 / rb_u

    ra_u = canopy_height_o / (gamma * kh_o) * (exp(gamma * (1 - canopy_height_u / canopy_height_o)) - 1)
    G_u_a = 1.0 / (ra_o + ra_u)

    gamma = 4.0
    # kh_u = kh_o * exp(-gamma * (1 - canopy_height_u / canopy_height_o))
    ra_g = canopy_height_o / (gamma * kh_o) * (exp(gamma * (1 - 0 / canopy_height_o)) -
                                               exp(gamma * (1 - canopy_height_u / canopy_height_o)))
    ra_g = ra_g + ra_u + ra_o
    ra_g = max(120, ra_g)
  end

  return ra_o, ra_u, ra_g, G_o_a, G_o_b, G_u_a, G_u_b
end

# function windProfile_factor(canopy_height_u, canopy_height_o, gamma, k=1.0)
#   exp(gamma * (1 - canopy_height_u * k / canopy_height_o))
# end

function cal_Nu(u::FT, nu_lower::FT)::FT
  # lw::T = 0.3 # leaf characteristic width =0.3 for BS
  # sigma::T = 5 # shelter factor =5 for BS
  # Re = (ud * lw / sigma) / nu_lower
  Re::FT = (u * 0.1) / nu_lower # Reynold's number
  Nu::FT = 1.0 * Re^0.5 # Nusselt number
  Nu
end
````

## File: beps_main.jl
````julia
# see `VARS_SCALAR` and `VARS_VECTOR` for details
const DEFAULT_STATE_EXPORT = [
  :z_water, :ρ_snow, :z_snow, :r_rain_g, :f_soilwater,
  :θ, :Tsoil_c, :ETi]

# Please use `beps_modern` instead
# This function is only for testing the consistency between C and Julia versions,
# and will be deprecated in the future.
function beps_main(forcing::MetSeries, lai::Vector, dates;
  lon::FT=120.0, lat::FT=20.0,
  VegType::Int=25, SoilType::Int=8, clumping::FT=0.85,
  Tsoil0::FT=2.2, θ0::FT=0.4115, z_snow0::FT=0.0,
  r_drainage::FT=0.5, r_root_decay::FT=0.95,
  VARS_STATE::Vector{Symbol}=DEFAULT_STATE_EXPORT,
  version="julia", fix_snowpack=true, fix_Ta_annual=true,
  kw...) where {FT<:AbstractFloat}

  ntime = forcing.ntime
  met = Met()
  mid_flux = Flux()
  mid_ET = ETFlux()
  cache = LeafCache()

  fluxes = FluxSeries(; ntime)
  fluxes_ET = ETSeries(; ntime)
  SF, VF = split_vars(VARS_STATE)
  states = StateSeries(SF, VF, layer, ntime)
  # states = nothing

  ## 初始化参数和状态变量
  Ta = forcing.Tair[1]

  # 使用统一的 setup 函数初始化
  soil, state, params = setup_model(VegType, SoilType;
    version, Ta, Tsoil=Tsoil0, θ0, z_snow=z_snow0, r_drainage, r_root_decay, FT)
  state_n = deepcopy(state)

  theta = par2theta(params.veg; clumping, VegType)

  Ta_annual = mean(forcing.Tair)
  jdays = dayofyear.(dates)
  hours = hour.(dates) .+ 1  # 转为1-based (1:24)

  for i = 1:ntime
    # add a progress
    jday = jdays[i]
    hour = hours[i]

    fill_met!(met, forcing, i) # 驱动数据
    k = ceil(Int, i / 24)
    _lai = lai[k]

    # /***** start simulation modules *****/
    if version == "julia"
      inter_prg_jl(jday, hour, lon, lat, _lai, clumping,
        met, params, state, mid_flux, mid_ET, cache; fix_Ta_annual, fix_snowpack, Ta_annual)
      save_state!(states, state, i, SF, VF)
    elseif version == "c"
      inter_prg_c(jday, hour, lon, lat, _lai, clumping,
        met, theta, state, state_n, soil, mid_flux, mid_ET, cache;)
      state .= state_n # state variables
    end

    fluxes[i] = mid_flux
    fluxes_ET[i] = mid_ET
  end
  DataFrame(fluxes), DataFrame(fluxes_ET), states
end
````

## File: beps_modern.jl
````julia
"""
    beps_modern(forcing, lai, dates; ps, state, ...)

Run BEPS simulation using the modern `ParamBEPS + StateBEPS` API.

# Arguments
- `forcing`     : `MetSeries` with hourly meteorological data
- `lai`         : daily LAI vector (length = number of days)
- `dates`       : `DateTime` vector matching `forcing` length
- `ps`          : `ParamBEPS` model parameters
- `state`       : `StateBEPS` initial state (copied internally, external value unchanged)
- `lon`, `lat`  : longitude and latitude [°]
- `clumping`    : canopy clumping index (default 0.85)
- `sm_obs`      : observed soil moisture [m³/m³], `nlayer × ntime` matrix; when provided,
                  `UpdateSoilMoisture` is skipped and each hourly θ is prescribed from data
- `Tsoil_obs`   : observed soil temperature [°C], `nlayer × ntime` matrix; when provided,
                  `UpdateHeatFlux` skips Tsoil update, ice_ratio still updated from obs temps
- `VARS_STATE` : state variables to save (default `DEFAULT_STATE_EXPORT`)
- `VARS_CACHE` : `LeafCache` variables to save (default `DEFAULT_CACHE_EXPORT`)

# Returns
`(df_flux, df_ET, states, caches)` — hourly flux DataFrames, a `StateSeries`,
and a `CacheSeries`
"""
function beps_modern(forcing::MetSeries, lai::Vector, dates::AbstractVector;
  ps::ParamBEPS, state::StateBEPS,
  lon::FT=120.0, lat::FT=20.0, clumping::FT=0.85,
  kstep::Float64=360.0,
  fix_snowpack=true, fix_annual_Ta=true,
  sm_obs::Union{Nothing, AbstractMatrix}=nothing,
  Tsoil_obs::Union{Nothing, AbstractMatrix}=nothing,
  VARS_STATE::Vector{Symbol}=DEFAULT_STATE_EXPORT,
  VARS_CACHE::Vector{Symbol}=DEFAULT_CACHE_EXPORT, kw...) where {FT<:AbstractFloat}

  state = deepcopy(state) # 避免外部状态被修改
  met = Met()
  mid_flux = Flux()
  mid_ET = ETFlux()
  cache = LeafCache()

  ntime = forcing.ntime
  fluxes = FluxSeries(; ntime)
  fluxes_ET = ETSeries(; ntime)

  SF, VF = split_vars(VARS_STATE)
  states = StateSeries(SF, VF, layer, ntime)

  CF = split_cache_vars(VARS_CACHE)
  caches = CacheSeries(CF, 4, ntime)

  Ta_annual = mean(forcing.Tair)
  jdays = dayofyear.(dates)
  hours = hour.(dates)

  fix_sm = sm_obs !== nothing
  fix_Tsoil = Tsoil_obs !== nothing

  for i = 1:ntime
    jday = jdays[i]
    hour = hours[i]

    if fix_sm
      state.θ_prev .= state.θ
      state.θ[1:5] .= @view sm_obs[:, i]
    end
    if fix_Tsoil
      state.Tsoil_p .= state.Tsoil_c
      state.Tsoil_c[1:5] .= @view Tsoil_obs[:, i]
    end

    fill_met!(met, forcing, i) # 驱动数据
    k = ceil(Int, i / 24)
    _lai = lai[k]

    inter_prg_jl(jday, hour, lon, lat, _lai, clumping,
      met, ps, state, mid_flux, mid_ET, cache; kstep,
      fix_snowpack, fix_annual_Ta, Ta_annual, fix_sm, fix_Tsoil)

    fluxes[i] = mid_flux
    fluxes_ET[i] = mid_ET
    save_state!(states, state, i, SF, VF)
    save_cache!(caches, cache, i, CF)
  end
  DataFrame(fluxes), DataFrame(fluxes_ET), states, caches
end
````

## File: BEPS_modules.jl
````julia
export s_coszs, lai2, ReadParamVeg,
  rainfall_stage1_jl, rainfall_stage2_jl,
  snowpack_stage1_jl, snowpack_stage2_jl, snowpack_stage3_jl

export aerodynamic_conductance_jl,
  sensible_heat_jl,
  latent_heat!,
  Leaf_Temperatures_jl,
  surface_temperature_jl,
  transpiration_jl,
  evaporation_canopy_jl,
  evaporation_soil_jl,
  netRadiation_jl,
  photosynthesis_jl

# 独立光合作用模块导出
export ParamPhoto_Farquhar, InitParam_Photo_Farquhar
export LeafPhoto, PhotoResult
export photosynthesis


# include("Base/Base.jl")
# include("Param/Parameters.jl")

include("SoilPhysics/SoilPhysics.jl")
# include("soil_thermal_regime.jl")

include("aerodynamic_conductance.jl")
# include("latent_heat.jl")
# include("sensible_heat.jl")
include("heat_H_and_LE.jl")

# include("Leaf_Temperature.jl")
include("surface_temperature.jl")
# include("transpiration.jl")
include("evaporation_soil.jl")
include("evaporation_canopy.jl")

include("rainfall_stage.jl")
include("snowpack.jl")

include("netRadiation.jl")
include("photosynthesis.jl")
include("photosynthesis_helper.jl")

include("inter_prg.jl")
include("standalone/Photosynthesis/photosynthesis.jl")


# 25: C3 农作物 (C3 Crops)
# 40: C4 农作物/草地 (C4 Crops/Grass)
function lai2!(veg::ParamVeg{T}, Ω::T, CosZs::T, lai::T,
  LAI::Leaf, PAI::Leaf) where {T<:AbstractFloat}

  lai_o = lai < 0.1 ? 0.1 : lai
  lai_u = !veg.has_understory ? 0.01 : 1.18 * exp(-0.99 * lai_o)
  lai_u > lai_o && (lai_u = 0.01)

  stem_o = veg.LAI_max_o * 0.2 #
  stem_u = veg.LAI_max_u * 0.2
  lai2!(Ω, CosZs, stem_o, stem_u, lai_o, lai_u, LAI, PAI)
  lai_o, lai_u, stem_o, stem_u
end
````

## File: beps_optimize.jl
````julia
function beps_optimize(forcing::MetSeries, lai::Vector, dates::AbstractVector,
  model::ParamBEPS, obs::AbstractVector;
  col_sim::Symbol=:ET,
  # SCE-UA 优化器参数
  maxn=2000, kstop=5, f_reltol=0.0001, x_reltol=0.0001, seed=1,
  n_complex=5, size_complex=nothing, size_simplex=nothing, n_evolu=nothing,
  n_pop=nothing, verbose=false, parallel=true,
  kwargs...)

  # state0 初始条件与优化参数无关，只初始化一次；beps_modern 内部会 deepcopy
  Ta = Float64(forcing.Tair[1])
  state0, _ = setup(model; Ta)
  x0, lb, ub, paths = get_opt_info(model)

  function cal_func(x)
    m = deepcopy(model)
    update!(m, paths, x)
    try
      df_out, df_ET, _, _ = beps_modern(forcing, lai, dates; ps=m, state=state0, kwargs...)
      sim = col_sim ∈ propertynames(df_out) ? df_out[!, col_sim] : df_ET[!, col_sim]
      return of_RMSE(obs, sim)
    catch e
      e isa DomainError || @warn "beps_optimize: unexpected error" exception=e
      return Inf  # 参数违反物理约束时返回大值
    end
  end

  sceua_kw = (; maxn, kstop, f_reltol, x_reltol, seed, n_complex, verbose, parallel)
  opt_extras = (; size_complex, size_simplex, n_evolu, n_pop)
  sceua_kw = merge(sceua_kw,
    NamedTuple(k => v for (k, v) in pairs(opt_extras) if !isnothing(v)))
  bestx, bestf, exitflag = sceua(cal_func, x0, lb, ub; sceua_kw...)

  update!(model, paths, bestx)
  return model, bestf
end
````

## File: BEPS.jl
````julia
module BEPS
# using BEPS

using DocStringExtensions
using UnPack
import Parameters: @with_kw, @with_kw_noshow
using Printf
using Reexport
using Dates
import DataFrames: DataFrame

using StaticArrays
using Statistics
using ModelParams
using ModelParams: of_RMSE

@reexport using Serialization: deserialize, serialize
@reexport using DelimitedFiles: readdlm
export beps_main
export beps_modern
export beps_optimize
export Soil_c

export path_proj
path_proj(f...) = normpath(joinpath(@__DIR__, "..", f...))

using LazyArtifacts
using Libdl: dlext
using Base.BinaryPlatforms: HostPlatform, os, arch

const libbeps = let
  _ext  = dlext
  _os   = os(HostPlatform())
  _ar   = arch(HostPlatform()) == "aarch64" ? "arm64" : "x86_64"

  fname = "libbeps-$_os-$_ar.$_ext"
  local_lib = path_proj("deps", fname)
  isfile(local_lib) ? local_lib : joinpath(artifact"libbeps", fname)
end

# import Statistics: mean, std
# include("DataFrames.jl")
# include("Ipaper.jl")
# include("c2julia.jl")
include("SPAC/SPAC.jl")
include("DataType/DataType.jl")
include("BEPS_modules.jl")

include("clang/BEPS_c.jl")
@reexport import BEPS.clang;
import BEPS.clang: inter_prg_c, photosynthesis_c, Soil_c,
  snowpack_stage1, snowpack_stage2, snowpack_stage3
using BEPS.clang

# include("beps_inter_prg.jl")
include("beps_main.jl")
include("beps_modern.jl")
include("beps_optimize.jl")

end # module BEPS
````

## File: DataType/AeroConsts.jl
````julia
# 附属于`aerodynamic_conductance.jl`而生
@with_kw mutable struct AeroConsts{T}
  ustar::T = 0.0         # friction velocity at reference height [m s-1]
  coef_L::T = 0.0        # coefficient in Monin-Obukhov length: L = coef_L * SH_o_p
  rb_o::T = 200.0        # overstory leaf boundary layer resistance [s m-1]
  rb_u::T = 200.0        # understory leaf boundary layer resistance [s m-1]
  gamma_u::T = 1.0       # attenuation factor for understory wind profile [-]
  exp_u::T = 1.0         # exp(gamma_u * (1 - h_u / h_o)) for ra_u
  exp_g_u::T = 1.0       # exp(4 * (1 - h_u / h_o)) for ground-air resistance
  lai_o_pow075::T = 1.0  # cached lai_o^0.75 term used in gamma_u
  Le_cuberoot::T = 1.0   # cached (lai_o * clumping)^(1/3) for overstory attenuation
end

pow_075(x::T) where {T<:Real} = x^0.75
cuberoot(x::T) where {T<:Real} = x^(1.0 / 3.0)

exp_u_terms(canopy_height_o::T, canopy_height_u::T, gamma_u::T) where {T<:Real} =
  exp(gamma_u * (1 - canopy_height_u / canopy_height_o))

exp_g_terms(canopy_height_o::T, canopy_height_u::T) where {T<:Real} =
  exp(4.0 * (1 - canopy_height_u / canopy_height_o))

"""
    aero_exp_terms(canopy_height_o, canopy_height_u, z_wind, clumping, Tair, wind_sp, lai_o)

Precompute the aerodynamic terms that are independent of the canopy-energy
iteration state (e.g., `SH_o_p` and `L`-dependent stability correction).

Workflow:
1. Compute geometric/wind primitives (`d`, `z0`, `ustar`) from canopy height and wind forcing.
2. Build `coef_L`, which linearly maps sensible heat to Monin-Obukhov length:
   `L = coef_L * SH_o_p`.
3. Precompute expensive nonlinear terms (`lai_o^0.75`, `(lai_o*clumping)^(1/3)`,
   and several `exp(...)` factors) used repeatedly in resistance formulas.
4. Estimate overstory/understory boundary-layer resistances (`rb_o`, `rb_u`)
   from wind profile and Reynolds/Nusselt relationships.

The returned tuple is designed to be cached in `AeroConsts` and reused across
sub-iterations, minimizing repeated `^`/`exp` work while keeping the runtime
path in `aerodynamic_conductance_jl` compact.
"""
function aero_exp_terms(canopy_height_o::T, canopy_height_u::T, z_wind::T, clumping::T,
  Tair::T, wind_sp::T, lai_o::T) where {T<:Real}
  k = 0.4
  cp = 1010.0
  density_air = 1.225
  g = 9.8

  # displacement height (m)
  d = 0.8 * canopy_height_o
  # roughness length (m)
  z0 = 0.08 * canopy_height_o
  log_zh_z0 = log((z_wind - d) / z0)
  ustar = wind_sp * k / log_zh_z0 # friction velocity (m/s)
  coef_L = -(k * g) / (density_air * cp * (Tair + 273.3) * ustar^3)

  lai_o_pow075 = pow_075(lai_o)
  gamma_u = 0.1 + lai_o_pow075
  exp_u = exp_u_terms(canopy_height_o, canopy_height_u, gamma_u)
  exp_g_u = exp_g_terms(canopy_height_o, canopy_height_u)

  nu_lower = (13.3 + Tair * 0.07) / 1000000
  alfaw = (18.9 + Tair * 0.07) / 1000000
  uh = 1.1 * ustar / k

  Le = lai_o * clumping
  Le_cuberoot = cuberoot(Le)
  gamma_o = (0.167 + 0.179 * uh) * Le_cuberoot
  ud = uh * exp(-gamma_o * (1 - d / canopy_height_o))
  Nu_o = cal_Nu(ud, nu_lower)
  rb_o = min(40.0, 0.5 * 0.1 / (alfaw * Nu_o))

  un_d = uh * exp(-gamma_u * (1 - canopy_height_u * 0.8 / canopy_height_o))
  Nu_u = cal_Nu(un_d, nu_lower)
  rb_u = min(40.0, 0.5 * 0.1 / (alfaw * Nu_u))

  return ustar, coef_L, rb_o, rb_u, lai_o_pow075, Le_cuberoot, gamma_u, exp_u, exp_g_u
end


function AeroConsts!(ac::AeroConsts{T},
  canopy_height_o::T, canopy_height_u::T, z_wind::T, clumping::T,
  Tair::T, wind_sp::T, lai_o::T) where {T<:Real}

  ustar, coef_L, rb_o, rb_u, lai_o_pow075, Le_cuberoot, gamma_u, exp_u, exp_g_u =
    aero_exp_terms(canopy_height_o, canopy_height_u, z_wind, clumping, Tair, wind_sp, lai_o)

  @pack! ac = ustar, coef_L, rb_o, rb_u, lai_o_pow075, Le_cuberoot, gamma_u, exp_u, exp_g_u
  nothing
end



"""
    ra_updateH(canopy_height_o, canopy_height_u, zh, log_zh_z0, inv_k_ustar, ustar,
      SH_o_p, n, coef_L, gamma_u, exp_u, exp_g_u)

Update aerodynamic resistances (`ra_o`, `ra_u`, `ra_g`) for current sensible
heat flux `SH_o_p`. This function isolates the iteration-dependent stability
part so the main aerodynamic function stays easier to read.
"""
function ra_updateH(SH_o_p::FT, z_wind, canopy_height_o::FT, canopy_height_u::FT,
  ustar::FT, coef_L::FT, gamma_u::FT, exp_u::FT, exp_g_u::FT)

  n = FT(5.0)
  d = 0.8 * canopy_height_o
  z0 = 0.08 * canopy_height_o
  zh = z_wind - d
  log_zh_z0 = log(zh / z0)

  k = 0.4
  inv_k_ustar = 1.0 / (k * ustar)

  L::FT = coef_L * SH_o_p
  L = max(-2.0, L)

  ra_o::FT = inv_k_ustar * (log_zh_z0 + (n * zh * L))
  ra_o = clamp(ra_o, 2, 100)

  if L > 0
    ψ = 1 + 5 * zh * L
  else
    ψ = (1 - 16 * zh * L)^(-0.5)
  end
  ψ = min(10.0, ψ)

  kh_o = 0.41 * ustar * (canopy_height_o - canopy_height_o * 0.8) / ψ
  ra_u = canopy_height_o / (gamma_u * kh_o) * (exp_u - 1)

  # kh_u = kh_o * exp(-4 * (1 - canopy_height_u / canopy_height_o))
  ra_g = canopy_height_o / (4.0 * kh_o) * (exp(4.0) - exp_g_u)
  ra_g = ra_g + ra_u + ra_o
  ra_g = max(120, ra_g)
  return ra_o, ra_u, ra_g
end
````

## File: DataType/BEPS_State.jl
````julia
export SnowLand

@with_kw mutable struct SnowLand{FT<:AbstractFloat} <: FieldVector{5,FT}
  T_surf::FT = 0.0      # 雪表面温度, 裸土地表温度
  T_snow0::FT = 0.0     # 雪表温度, !注意是雪表, 不是地表
  T_snow1::FT = 0.0     # 雪层1温度
  T_snow2::FT = 0.0     # 雪层2温度
  T_mix0::FT = 0.0      # !mixed
  # T_soil0::FT = 0.0     # !裸土部分
end

function clamp!(des::SnowLand{FT}, src::SnowLand{FT}, Tair::FT) where {FT<:AbstractFloat}
  lower = Tair - FT(2.0)
  upper = Tair + FT(2.0)

  des.T_surf = clamp(src.T_surf, lower, upper)
  des.T_snow0 = clamp(src.T_snow0, lower, upper)
  des.T_snow1 = clamp(src.T_snow1, lower, upper)
  des.T_snow2 = clamp(src.T_snow2, lower, upper)
  des.T_mix0 = clamp(src.T_mix0, lower, upper)
end
clamp!(land::SnowLand{FT}, Tair::FT) where {FT<:AbstractFloat} = clamp!(land, land, Tair)


abstract type AbstractSoil end

# ?     : 需要优化的参数
# state : 状态变量
# //    : 未使用的参数
@with_kw mutable struct Soil <: AbstractSoil
  flag        ::Cint    = Cint(0) # // not used
  n_layer     ::Cint    = Cint(5) # 土壤层数
  step_period ::Cint    = Cint(1) # // not used

  z_water ::Cdouble = Cdouble(0) # [state]
  z_snow  ::Cdouble = Cdouble(0) # [state]

  # the rainfall rate, un--on understory on ground surface  m/s
  r_rain_g    ::Cdouble = Cdouble(0)        # [state], 达到地地表降水, PE, [m/s]

  soil_r      ::Cdouble = Cdouble(0)        # // not used, soil surface resistance for water
  r_drainage  ::Cdouble = Cdouble(0)        # ? 地表排水速率（地表汇流）
  r_root_decay::Cdouble = Cdouble(0)        # ? 根系分布衰减率, decay_rate_of_root_distribution
  ψ_min       ::Cdouble = Cdouble(0)        # ? 开始胁迫，33[m] = 0.33[MPa]
  alpha       ::Cdouble = Cdouble(0)        # ? 土壤水限制因子参数，He 2017 JGR-B, Eq. 4
  f_soilwater ::Cdouble = Cdouble(0)        # [state], 总体的土壤水限制因子

  dz          ::Vector{Float64} = zeros(10) # 土壤厚度
  f_root      ::Vector{Float64} = zeros(10) # [state], 根系比例，root fraction
  w_norm      ::Vector{Float64} = zeros(10) # [state], 每层的土壤水限制因子，已归一化

  κ_dry       ::Vector{Float64} = zeros(10) # ? thermal conductivity
  θ_vfc       ::Vector{Float64} = zeros(10) # ? volumetric field capacity
  θ_vwp       ::Vector{Float64} = zeros(10) # ? volumetric wilting point
  θ_sat       ::Vector{Float64} = zeros(10) # ? volumetric saturation
  K_sat       ::Vector{Float64} = zeros(10) # ? saturated hydraulic conductivity
  ψ_sat       ::Vector{Float64} = zeros(10) # ? soil matric potential at saturation
  b           ::Vector{Float64} = zeros(10) # ? Cambell parameter b
  ρ_soil      ::Vector{Float64} = zeros(10) # ? 土壤容重，soil density, for volume heat capacity
  V_SOM       ::Vector{Float64} = zeros(10) # ? 有机质含量，organic matter, for volume heat capacity

  ice_ratio   ::Vector{Float64} = zeros(10) # [state]，ice ratio，
  θ           ::Vector{Float64} = zeros(10) # [state], soil moisture
  θ_prev      ::Vector{Float64} = zeros(10) # [state], soil moisture in previous time
  Tsoil_p     ::Vector{Float64} = zeros(10) # [state], soil temperature in previous time
  Tsoil_c     ::Vector{Float64} = zeros(10) # [state], soil temperature in current time

  f_water     ::Vector{Float64} = zeros(10) # [state], 冻结因子，用于 UpdateSoilMoisture
  ψ           ::Vector{Float64} = zeros(10) # [state], soil matric potential
  θb          ::Vector{Float64} = zeros(10) # // not used, θ at the bottom of each layer
  ψb          ::Vector{Float64} = zeros(10) # // not used
  r_waterflow ::Vector{Float64} = zeros(10) # [state], vertical water flow rate
  Kmid        ::Vector{Float64} = zeros(10) # [state], hydraulic conductivity at middle point
  Kb          ::Vector{Float64} = zeros(10) # // not used
  Kavg        ::Vector{Float64} = zeros(10) # [state], average conductivity of two soil layers
  Cv          ::Vector{Float64} = zeros(10) # [state], volume heat capacity
  κ           ::Vector{Float64} = zeros(10) # [state]
  ETi         ::Vector{Float64} = zeros(10) # [state], 每层蒸发量ET in each layer
  G           ::Vector{Float64} = zeros(10) # [state], 土壤热通量

  ## temporary variables in soil_water_factor_v2
  f_temp      ::Vector{Float64} = zeros(10) # [state], f_i(Tsoil_i), 温度对水分限制影响, Eq. 5
  w_root      ::Vector{Float64} = zeros(10) # [state], 叠加根系分布比例，f_root[i] * f_stress[i]
  f_stress    ::Vector{Float64} = zeros(10) # [state], f_{w,i}, He et al., 2017, Eq. 3, (水分 + 温度)
end


## 设计哲学: 这里把状态变量与模型参数分隔开
# state, params = setup(model)
# st = StateBEPS, ps = ParamBEPS

# 拖着`ρ_snow`，`ρ_snow`也是一个状态连续的变量
# https://www.eoas.ubc.ca/courses/atsc113/snow/met_concepts/07-met_concepts/07b-newly-fallen-snow-density/
@with_kw mutable struct StateBEPS <: AbstractSoil
  n_layer    ::Cint = Cint(5) # 土壤层数
  dz         ::Vector{Float64} = zeros(10) # 土壤厚度（从 ps 复制，方便计算）

  Tsnow_c::SnowLand{FT} = SnowLand{FT}() # [inter_prg], 4:8
  Tsnow_p::SnowLand{FT} = SnowLand{FT}() # [inter_prg], 10:15

  Qhc_o  ::FT = 0.0                      # [inter_prg], [11] sensible heat flux

  m_water::Layer2 = Layer2{FT}()         # [inter_prg], [15, 18] + 1
  m_snow ::Layer3 = Layer3{FT}()         # [inter_prg], [16, 19, 20] + 1
  ρ_snow ::FT = 250.0                    # [inter_prg], [kg m-3] snow density

  z_water    ::Cdouble = Cdouble(0)        # [state]
  z_snow     ::Cdouble = Cdouble(0)        # [state]

  # the rainfall rate, un--on understory on ground surface  m/s
  r_rain_g   ::Cdouble = Cdouble(0)        # [state], 达到地地表降水, PE, [m/s]
  f_soilwater::Cdouble = Cdouble(0)        # [state], 总体的土壤水限制因子

  f_root     ::Vector{Float64} = zeros(10) # [state], 根系比例，root fraction

  ice_ratio  ::Vector{Float64} = zeros(10) # [state]，ice ratio，
  θ          ::Vector{Float64} = zeros(10) # [state], soil moisture
  θ_prev     ::Vector{Float64} = zeros(10) # [state], soil moisture in previous time
  Tsoil_p    ::Vector{Float64} = zeros(10) # [state], soil temperature in previous time
  Tsoil_c    ::Vector{Float64} = zeros(10) # [state], soil temperature in current time

  f_water    ::Vector{Float64} = zeros(10) # [state], 冻结因子，用于 UpdateSoilMoisture
  ψ          ::Vector{Float64} = zeros(10) # [state], soil matric potential
  r_waterflow::Vector{Float64} = zeros(10) # [state], vertical water flow rate
  Kmid       ::Vector{Float64} = zeros(10) # [state], hydraulic conductivity at middle point
  Kavg       ::Vector{Float64} = zeros(10) # [state], average conductivity of two soil layers
  Cv         ::Vector{Float64} = zeros(10) # [state], volume heat capacity
  κ          ::Vector{Float64} = zeros(10) # [state]
  ETi        ::Vector{Float64} = zeros(10) # [state], 每层蒸发量ET in each layer
  G          ::Vector{Float64} = zeros(10) # [state], 土壤热通量

  ## temporary variables in soil_water_factor_v2
  f_temp     ::Vector{Float64} = zeros(10) # [state], f_i(Tsoil_i), 温度对水分限制影响, Eq. 5
  w_root     ::Vector{Float64} = zeros(10) # [state], 叠加根系分布比例，f_root[i] * f_stress[i]
  w_norm     ::Vector{Float64} = zeros(10) # [state], 每层的土壤水限制因子，已归一化
  f_stress   ::Vector{Float64} = zeros(10) # [state], f_{w,i}, He et al., 2017, Eq. 3
end


const VARS_SCALAR = Tuple(
    f for (f, T) in zip(fieldnames(StateBEPS), fieldtypes(StateBEPS))
    if T <: AbstractFloat && f ∉ (:Qhc_o,)
)

const VARS_VECTOR = Tuple(
    f for (f, T) in zip(fieldnames(StateBEPS), fieldtypes(StateBEPS))
    if T == Vector{Float64} && f ∉ (:dz, :f_root)
)
# :θ_prev, :Tsoil_p
const ALL_VARS_STATE = (VARS_SCALAR..., VARS_VECTOR...)

# 从 Soil 构造 SoilState（兼容旧代码）
function StateBEPS(soil::Soil)
  @unpack n_layer, dz, z_water, z_snow, r_rain_g, f_soilwater,
          f_root, w_norm, ice_ratio, θ, θ_prev, Tsoil_p, Tsoil_c,
          f_water, ψ, r_waterflow, Kmid, Kavg, Cv, κ, ETi, G,
          f_temp, w_root, f_stress = soil

  StateBEPS(; 
    n_layer, dz, z_water, z_snow, 
    r_rain_g, f_soilwater,
    f_root, w_norm, ice_ratio, θ, θ_prev,
    Tsoil_p, Tsoil_c, f_water, ψ,
    r_waterflow, Kmid, Kavg, Cv, κ,
    ETi, G, f_temp, w_root, f_stress
  )
end

# 将 StateBEPS 同步回 Soil（兼容旧代码）
function State2Soil!(soil::Soil, st::StateBEPS)
  @unpack z_water, z_snow, r_rain_g, f_soilwater,
          f_root, w_norm, ice_ratio, θ, θ_prev, Tsoil_p, Tsoil_c,
          f_water, ψ, r_waterflow, Kmid, Kavg, Cv, κ, ETi, G,
          f_temp, w_root, f_stress = st

  @pack! soil = z_water, z_snow, r_rain_g, f_soilwater,
                f_root, w_norm, ice_ratio, θ, θ_prev, Tsoil_p, Tsoil_c,
                f_water, ψ, r_waterflow, Kmid, Kavg, Cv, κ, ETi, G,
                f_temp, w_root, f_stress
  return soil
end


export Soil, StateBEPS, State2Soil!
export VARS_SCALAR, VARS_VECTOR, ALL_VARS_STATE
````

## File: DataType/CanopyLayer.jl
````julia
import Base.show

## Layer3
"""
x = Layer3{Float64}()
x = Layer3{Ref{Float64}}()
"""
@with_kw_noshow mutable struct Layer3{FT} <: FieldVector{3,FT}
  o::FT = FT(0.0) # overlayer
  u::FT = FT(0.0) # underlayer
  g::FT = FT(0.0) # ground
end

## Layer2
@with_kw_noshow mutable struct Layer2{FT} <: FieldVector{2,FT}
  o::FT = FT(0.0) # overlayer
  u::FT = FT(0.0) # underlayer
end

const AbstractLayer{FT} = Union{Layer2{FT}, Layer3{FT}}


# 注意，如果是Ref，将共用相同的地址
Layer3(o::FT) where {FT} = Layer3{FT}(o, o, o)

Layer3(o::FT, u::FT) where {FT} = Layer3{FT}(; o, u, g = 0.0)

# 注意，如果是Ref，将共用相同的地址
Layer2(o::FT) where {FT} = Layer2{FT}(o, o)


function Base.show(io::IO, x::AbstractLayer{FT}) where {FT}
  println(io, typeof(x))
  names = fieldnames(typeof(x))
  for i in 1:nfields(x)
    name = names[i]
    value = getfield(x, name)
    T = typeof(value)
    isa(value, Ref) && (value = value[])
    println(io, "$name: $T $(value)")
  end
end


export Layer3, Layer2
````

## File: DataType/Constant.jl
````julia
const FW_VERSION = 1

const MAX_LAYERS = 10

# 8m的振幅残余约3%，年均温假设基本成立，物理上合理。
# CLM 等大模型用10–40m，DEPTH_F=6 偏保守但可接受。
const DEPTH_F = 6.0 # [m], 锚点（中心）距最深层底部6m，锚点采用T_air_annual

# const zero::Float64 = 1.0e-10

const RTIMES = 24

const step::Float64 = 3600.0

const layer = 5

const CO2_air::Float64 = 380.0    # ppm

const ρₐ::Float64 = 1.292    # density of air, kg m-3

const ρ_w::Float64 = 1025.0;  # density of water, kg m-3

const λ_snow::Float64 = 2.83 * 1e6 # J/kg

# the latent heat of evaporation from solid (snow/ice) at air temperature=Ta, in j+kkk/kg
const Lv_solid::Float64 = 2.83 * 1000000;


## DB ----------------

###
const rugc::Float64 = 8.314  # J mole-1 K-1
# const vcopt = 73.0   # carboxylation rate at optimal temperature, umol m-2 s-1
# const jmopt = 170.0  # electron transport rate at optimal temperature, umol m-2 s-1
const rd25::Float64 = 0.34  # dark respiration at 25 C, rd25= 0.34 umol m-2 s-1

# Universal gas constant
const rgc1000::Float64 = 8314.0  # gas constant times 1000.

# Consts for Photosynthesis model and kinetic equations.
# for Vcmax and Jmax.  Taken from Harley and Baldocchi (1995, PCE)
# const hkin::Float64 = 200000.0  # enthalpy term, J mol-1
const skin::Float64 = 710.0     # entropy term, J K-1 mol-1
const ejm::Float64 = 55000.0    # activation energy for electron transport, J mol-1
const evc::Float64 = 55000.0    # activation energy for carboxylation, J mol-1

# Enzyme constants & partial pressure of O2 and CO2
# Michaelis-Menten K values. From survey of literature.

const kc25::Float64 = 274.6  # kinetic coef for CO2 at 25 C, microbars
const ko25::Float64 = 419.8  # kinetic coef for O2 at 25C,  millibars
const o2::Float64 = 210.0    # oxygen concentration  mmol mol-1

# tau is computed on the basis of the Specificity factor (102.33)
# times Kco2/Kh2o (28.38) to convert for value in solution
# to that based in air/
# The old value was 2321.1.

# New value for Quercus robor from Balaguer et al. 1996
# Similar number from Dreyer et al. 2001, Tree Physiol, tau= 2710

const tau25::Float64 = 2904.12   #  tau coefficient
#  Arrhenius constants
#  Eact for Michaelis-Menten const. for KC, KO and dark respiration
#  These values are from Harley
const ekc::Float64 = 80500.0     # Activation energy for K of CO2; J mol-1
const eko::Float64 = 14500.0     # Activation energy for K of O2, J mol-1
const erd::Float64 = 38000.0     # activation energy for dark respiration, eg Q10=2
const ektau::Float64 = -29000.0  # J mol-1 (Jordan and Ogren, 1984)
const TK25::Float64 = 298.16    # absolute temperature at 25 C
const toptvc::Float64 = 301.0    # optimum temperature for maximum carboxylation
const toptjm::Float64 = 301.0    # optimum temperature for maximum electron transport
const eabole::Float64 = 45162.0    # activation energy for bole respiration for Q10 = 2.02
````

## File: DataType/DataType.jl
````julia
import Parameters: @with_kw, @with_kw_noshow
const FT = Cdouble

Value = getindex
Value! = setindex!

# dbl() = Cdouble(0)
init_dbl() = Ref(0.0)
init_dbl(x::T) where {T<:Real} = Ref(x)
nzero(n) = tuple(zeros(n)...) # n double zero


include("Constant.jl")
# include("Leaf.jl")
include("CanopyLayer.jl")
include("BEPS_State.jl")
include("Params/Params.jl")

include("macro.jl")
include("Met.jl")
include("OUTPUT.jl")
include("PhotoConsts.jl")
include("AeroConsts.jl")
include("LeafCache.jl")
include("setup.jl")
include("StateSeries.jl")


# # current not used
# @with_kw mutable struct TSoil
#   T_ground::Cdouble = 0.0
#   T_any0::Cdouble = 0.0
#   T_soil0::Cdouble = 0.0
#   T_snow::Cdouble = 0.0
#   T_snow1::Cdouble = 0.0
#   T_snow2::Cdouble = 0.0
#   G::Cdouble = 0.0
# end
# export TSoil


## fill valuesFlux
const TypeDF = Union{Flux,ETFlux,Met}

## put struct into a data.frame
# function Base.getindex(x::T, i::Int)::FT where {T<:TypeDF}
#   # key = fieldnames(T)[i]
#   getfield(x, i)
# end
# Base.length(x::T) where {T<:TypeDF} = fieldcount(T)

# @generated function fill_res!(df::DataFrame, res::T, k::Int) where {T<:TypeDF}
#   fs = fieldnames(T)
#   assigns = Vector{Any}(undef, length(fs))
#   for (i, f) in pairs(fs)
#     # QuoteNode 让字段名作为常量符号 → DataFrames 列直接定位 + 静态 getfield
#     assigns[i] = :(@inbounds df[!, $(QuoteNode(f))][k] = getfield(res, $(QuoteNode(f))))
#   end
#   return Expr(:block, assigns..., :(return nothing))
# end


export Leaf, Soil, AbstractSoil,
  Met, Flux, Cpools, ETFlux, Radiation

export FT, init_dbl, set!
````

## File: DataType/LeafCache.jl
````julia
export LeafCache, CacheSeries, save_cache!, split_cache_vars
export ALL_VARS_CACHE

@with_kw mutable struct LeafCache
  init::Float64 = 0.0
  pc::PhotoConsts{Float64} = PhotoConsts(10.0 + 273.15) # 默认10°, 计算光合常量
  ac::AeroConsts{Float64} = AeroConsts()
  Ra::Radiation = Radiation()
  # Cc_new::Leaf = Leaf(init)
  Cs_old::Leaf = Leaf(init)
  Cs_new::Leaf = Leaf(init)
  Ci_old::Leaf = Leaf(init)
  Ci_new::Leaf = Leaf(init)

  Tc_old::Leaf = Leaf(init)
  Tc_new::Leaf = Leaf(init)
  Gs_old::Leaf = Leaf(init)
  Gs_new::Leaf = Leaf(init)  # H2O 气孔导度 : [leaf intercellular]  -> [leaf surface]

  # to the reference height above the canopy
  Gc::Leaf = Leaf(init)      # CO2 总导度   : [leaf intercellular] -> [canopy reference height]
  Gh::Leaf = Leaf(init)      # heat 总导度  : [leaf surface]       -> [canopy reference height]
  Gw::Leaf = Leaf(init)      # H2O 总导度   : [leaf intercellular] -> [canopy reference height]
  Gw_wet::Leaf = Leaf(init)  # H2O 边界层导度: [wet leaf surface]   -> [canopy reference height]

  Ac::Leaf = Leaf(init)

  Rn::Leaf = Leaf(init)
  Rns::Leaf = Leaf(init)
  Rnl::Leaf = Leaf(init)

  leleaf::Leaf = Leaf(init)
  GPP::Leaf = Leaf(init)
  LAI::Leaf = Leaf(init)
  PAI::Leaf = Leaf(init)
end

LeafCache(init) = LeafCache(; init)

const ALL_VARS_CACHE = Tuple(
  f for (f, T) in zip(fieldnames(LeafCache), fieldtypes(LeafCache))
  if T == Leaf
)

const DEFAULT_CACHE_EXPORT = [:Tc_new, :Gs_new]

# function reset!(l::LeafCache)
#   names = fieldnames(LeafCache)[2:end]
#   for name in names
#     x = getfield(l, name)
#     reset!(x)
#   end
# end

function CacheSeries(::Val{VAR}, n_layer::Int, n_time::Int) where {VAR}
  bad = filter(v -> v ∉ ALL_VARS_CACHE, VAR)
  isempty(bad) || error("CacheSeries only supports Leaf fields: $bad")

  Ns = length(VAR)
  NamedTuple{VAR}(ntuple(_ -> Matrix{Float64}(undef, n_time, n_layer), Ns))
end

@generated function save_cache!(out::NamedTuple{VAR}, st::LeafCache, t::Int, ::Val{VAR}) where {VAR}
  bad = filter(v -> v ∉ ALL_VARS_CACHE, VAR)
  isempty(bad) || error("save_cache! only supports Leaf fields: $bad")

  v_ex = [:(copyto!(view(out.$(VAR[i]), t, :), st.$(VAR[i]))) for i in eachindex(VAR)]
  quote
    $(v_ex...)
    nothing
  end
end

function split_cache_vars(vars)
  vars = Symbol.(vars)
  known = Set(fieldnames(LeafCache))
  unknown = filter(v -> v ∉ known, vars)
  isempty(unknown) || error("字段不存在于 LeafCache: $unknown")

  exportable = Set(ALL_VARS_CACHE)
  excluded = filter(v -> v ∉ exportable, vars)
  isempty(excluded) || @warn "字段无法导出为 CacheSeries: $excluded"

  Val(Tuple(v for v in vars if v ∈ exportable))
end
````

## File: DataType/macro.jl
````julia
abstract type AbstractState{FT} end
abstract type AbstractFlux end

abstract type AbstractSeries{FT} end
abstract type AbstractFluxSeries{FT} <: AbstractSeries{FT} end
abstract type AbstractStateSeries{FT} <: AbstractSeries{FT} end


# ── 通用写入：series[i] = struct，按字段名静态展开 ─────────────────────────────
# 仿 setindex! 模式：编译期取两侧字段交集 → 内联赋值
@generated function Base.setindex!(series::SR, r::S, i::Int) where {FT<:AbstractFloat,
  SR<:AbstractSeries{FT}, S<:Union{AbstractFlux, AbstractState{FT}}}
  fs = intersect(fieldnames(SR), fieldnames(S))
  assigns = [:(@inbounds getfield(series, $(QuoteNode(f)))[i] = getfield(r, $(QuoteNode(f)))) for f in fs]
  return Expr(:block, assigns..., :(series))
end

# ── Series 定义宏 ─────────────────────────────────────────────────────────────
# 用法:
#   @DefFluxSeries FluxBEPS                         # 自动按命名约定 → FluxSeriesBEPS
#   @DefFluxSeries FluxSeries = Flux           # 显式指定 Series 名
#   @DefFluxSeries ETSeries = ETFlux extra1 extra2

macro DefFluxSeries(arg, extra_fields...)
  state_name, series_name = _parse_series_arg(arg)
  _def_series(__module__, state_name, extra_fields...; series_name, super_type=AbstractFluxSeries)
end

macro DefStateSeries(arg, extra_fields...)
  state_name, series_name = _parse_series_arg(arg)
  _def_series(__module__, state_name, extra_fields...; series_name, super_type=AbstractStateSeries)
end

# 解析: `Foo`              → (Foo, nothing)   走自动命名约定
#       `SeriesName = Foo` → (Foo, SeriesName)
function _parse_series_arg(arg)
  if isa(arg, Expr) && arg.head === :(=)
    return arg.args[2], arg.args[1]
  else
    return arg, nothing
  end
end

function _def_series(mod, StateStruct, extra_fields...; super_type, series_name=nothing)
  state_name = StateStruct
  output_name = something(series_name,
    Symbol(replace(string(state_name), r"^(Flux|State)" => s"\1Series")))

  state_type = getfield(mod, state_name)
  fieldnames_list = collect(fieldnames(state_type))
  field_types = fieldtypes(state_type)

  field_expressions = []

  # 1. ntime 字段（必须第一个）
  push!(field_expressions, :(ntime::Int = 100))

  # 2. 从源结构复制所有字段 → 转为 Vector{FT}（自动跳过 Vector 字段）
  for (i, fname) in enumerate(fieldnames_list)
    ftype = field_types[i]
    ftype <: AbstractVector && continue
    push!(field_expressions, :($fname::Vector{FT} = zeros(FT, ntime)))
  end

  # 3. 额外字段
  for extra in extra_fields
    if isa(extra, Symbol)
      push!(field_expressions, :($extra::Vector{FT} = zeros(FT, ntime)))
    elseif isa(extra, Expr) && extra.head === :(=)
      push!(field_expressions, extra)
    else
      error("额外字段格式错误：$(extra)")
    end
  end

  # State Series 提供 getindex 反向重建 State 结构
  scalar_fields = [fieldnames_list[i] for i in eachindex(fieldnames_list)
                   if !(field_types[i] <: AbstractVector)]

  getindex_expr = if super_type == AbstractStateSeries
    kw_args = [Expr(:kw, f, :(series.$f[i])) for f in scalar_fields]
    quote
      function Base.getindex(series::$output_name{FT}, i::Int) where {FT}
        $state_name{FT}($(kw_args...))
      end
    end
  else
    :()
  end

  return esc(quote
    @with_kw mutable struct $output_name{FT} <: $super_type{FT}
      $(field_expressions...)
    end
    $getindex_expr
  end)
end


# ── 单时刻结构定义宏（State / Flux）─────────────────────────────────────────
macro DefState(Struct, fields)
  field_syms = [f.value for f in fields.args if isa(f, QuoteNode)]
  field_expressions = [:($f::FT = 0.0) for f in field_syms]
  return esc(quote
    @with_kw mutable struct $Struct{FT<:AbstractFloat} <: AbstractState{FT}
      $(field_expressions...)
    end
  end)
end

macro DefFlux(Struct, fields)
  field_syms = [f.value for f in fields.args if isa(f, QuoteNode)]
  field_expressions = [:($f::FT = 0.0) for f in field_syms]
  return esc(quote
    @with_kw mutable struct $Struct{FT<:AbstractFloat} <: AbstractFlux
      $(field_expressions...)
    end
  end)
end

export AbstractFlux, AbstractState, AbstractFluxSeries, AbstractStateSeries, AbstractSeries
export @DefFluxSeries, @DefStateSeries, @DefState, @DefFlux


function Base.getindex(s::T, r::AbstractUnitRange{Int}) where {FT, T<:AbstractSeries{FT}}
  T(; ntime=length(r), (f => getfield(s, f)[r] for f in fieldnames(T) if f !== :ntime)...)
end

function Base.Matrix(res::AbstractSeries{T}) where {T<:Real}
  TYPE = typeof(res)
  names = fieldnames(TYPE)[2:end] |> collect
  data = map(i -> getfield(res, i), names)
  data = cat(data..., dims=2)
  data
end

function DataFrame(res::AbstractSeries{T}) where {T<:Real}
  TYPE = typeof(res)
  names = fieldnames(TYPE)[2:end] |> collect
  data = Matrix(res)
  DataFrame(data, names)
end
````

## File: DataType/Met.jl
````julia
export Met, MetSeries, fill_met!

"""
# Fields
$(TYPEDFIELDS)
"""
@with_kw mutable struct Met <: AbstractFlux # 为套用相同结构
  "Inward shortwave radiation, `[W m⁻²]`"
  Rs::Cdouble = 0.0

  "(optional) Inward longwave radiation, `[W m⁻²]`"
  Rln_in::Cdouble = NaN

  "2m air temperature, `[°C]`"
  Tair::Cdouble = 0.0

  "Relative Humidity, `[%]`"
  RH::Cdouble = 0.0

  "precipitation, `[mm/h]`"
  Prcp::Cdouble = 0.0

  "Wind speed at measurement height z, `[m/s]`"
  Uz::Cdouble = 0.0
end
@DefFluxSeries MetSeries = Met

# Met(Rs, Rln_in, Tair, RH, Prcp, Uz) =
#   Met(; Rs, Rln_in, Tair, RH, Prcp, Uz)
function fill_met!(met::Met, forcing::MetSeries, i::Int)
    met.Rs = forcing.Rs[i]
    met.Tair = forcing.Tair[i]
    met.Prcp = forcing.Prcp[i]
    met.Uz = forcing.Uz[i]
    met.Rln_in = forcing.Rln_in[i]
    met.RH = forcing.RH[i]
end

# """
# - `Rs`: W m-2
# - `Tair`: degC
# - `Prcp`: mm
# - `Uz`: m/s
# - `RH`: relative humidity, %
# """
# function fill_met!(met::Met, Rs::FT, Tair::FT, Prcp::FT, Uz::FT, RH::FT)
#   met.Rs = Rs
#   met.Tair = Tair
#   met.Prcp = Prcp / 1000 # mm to m
#   met.Uz = Uz
#   met.Rln_in = NaN # use model longwave estimation unless overridden
#   met.RH = RH
# end

# function fill_met!(met::Met, d::DataFrame, k::Int=1; use_lrad::Bool=false)
#   RH = hasproperty(d, :RH) ? d.RH[k] : q2RH(d.qair[k], d.Tair[k])
#   fill_met!(met, d.Rs[k], d.Tair[k], d.Prcp[k], d.Uz[k], RH)
#   use_lrad && isfinite(d.Rln_in[k]) && (met.Rln_in = d.Rln_in[k])
# end

"""
    AirLayer{FT}

Struct to store environmental conditions in each air layer corresponds to one canopy layer.

# Fields
$(TYPEDFIELDS)

> Copied from Land.jl
"""
@with_kw mutable struct AirLayer{FT<:AbstractFloat}
  "Air temperature `[K]`"
  Tair::FT
  "Air density `[kg m⁻³]`"
  ρₐ::FT
  "Specific heat of air `[J kg⁻¹ K⁻¹]`"
  Cp_ca::FT
  "Vapor pressure deficit `[Pa]`"
  VPD::FT
  "Psychrometric constant `[Pa K⁻¹]`"
  γ::FT
  "Slope of Saturation vapor pressure es `[Pa K⁻¹]`"
  Δ::FT
  "Relative humility `[%]`"
  RH::FT
  "Wind speed `[m s⁻¹]`"
  wind::FT = FT(2)
end
````

## File: DataType/OUTPUT.jl
````julia
@with_kw mutable struct Flux <: AbstractFlux
  gpp_o_sunlit::Cdouble = 0.0
  gpp_u_sunlit::Cdouble = 0.0
  gpp_o_shaded::Cdouble = 0.0
  gpp_u_shaded::Cdouble = 0.0

  plant_resp::Cdouble = 0.0
  npp_o::Cdouble = 0.0
  npp_u::Cdouble = 0.0
  GPP::Cdouble = 0.0
  NPP::Cdouble = 0.0
  NEP::Cdouble = 0.0
  soil_resp::Cdouble = 0.0
  Net_Rad::Cdouble = 0.0

  SH::Cdouble = 0.0
  LH::Cdouble = 0.0
  Trans::Cdouble = 0.0
  Evap::Cdouble = 0.0

  z_water::Cdouble = 0.0
  z_snow::Cdouble = 0.0
  ρ_snow::Cdouble = 0.0
end


@with_kw mutable struct ETFlux <: AbstractFlux
  Trans_o::Cdouble = 0.0
  Trans_u::Cdouble = 0.0
  Eil_o::Cdouble = 0.0     # Ei of liquid
  Eil_u::Cdouble = 0.0
  EiS_o::Cdouble = 0.0     # Ei of solid
  EiS_u::Cdouble = 0.0
  Evap_soil::Cdouble = 0.0
  Evap_SW::Cdouble = 0.0   # evaporation from water pond
  Evap_SS::Cdouble = 0.0   # evaporation from snow pack
  Qhc_o::Cdouble = 0.0
  Qhc_u::Cdouble = 0.0
  Qhg::Cdouble = 0.0

  # Result part
  Trans::Cdouble = 0.0
  Evap::Cdouble = 0.0
  SH::Cdouble = 0.0
  LH::Cdouble = 0.0
end


function update_ET!(x::ETFlux, mid_res::Flux, Ta)
  Lv_liquid = (2.501 - 0.00237 * Ta) * 1000000  # The latent heat of water vaporization in j/kg

  x.Trans = (x.Trans_o + x.Trans_u) * step

  x.Evap = (x.Eil_o + x.Eil_u +
            x.EiS_o + x.EiS_u +
            x.Evap_soil +
            x.Evap_SW +
            x.Evap_SS) * step
  x.LH = Lv_liquid * (x.Trans_o + x.Trans_u + x.Eil_o + +
                      x.Eil_u + x.Evap_soil + x.Evap_SW) +
         Lv_solid * (x.EiS_o + x.EiS_u + x.Evap_SS)

  x.SH = (x.Qhc_o + x.Qhc_u + x.Qhg)

  # fill values to res
  mid_res.Trans = x.Trans
  mid_res.Evap = x.Evap
  mid_res.LH = x.LH
  mid_res.SH = x.SH
end

@with_kw mutable struct Radiation <: AbstractFlux
  Rs_o_df::Cdouble = 0.0
  Rs_u_df::Cdouble = 0.0

  Rs_o_dir::Cdouble = 0.0
  Rs_u_dir::Cdouble = 0.0

  Rns_o_df::Cdouble = 0.0
  Rns_u_df::Cdouble = 0.0
  Rns_g_df::Cdouble = 0.0

  Rns_o_dir::Cdouble = 0.0
  Rns_u_dir::Cdouble = 0.0
  Rns_g_dir::Cdouble = 0.0

  Rs_df::Cdouble = 0.0
  Rs_dir::Cdouble = 0.0
end

@with_kw mutable struct Cpools
  Ccd::NTuple{3,Cdouble} = nzero(3)
  Cssd::NTuple{3,Cdouble} = nzero(3)
  Csmd::NTuple{3,Cdouble} = nzero(3)
  Cfsd::NTuple{3,Cdouble} = nzero(3)
  Cfmd::NTuple{3,Cdouble} = nzero(3)
  Csm::NTuple{3,Cdouble} = nzero(3)
  Cm::NTuple{3,Cdouble} = nzero(3)
  Cs::NTuple{3,Cdouble} = nzero(3)
  Cp::NTuple{3,Cdouble} = nzero(3)
end


# ── 时间序列容器（用 @DefFluxSeries 自动展开为 Vector{FT} 字段）──────────────
@DefFluxSeries FluxSeries = Flux
@DefFluxSeries ETSeries = ETFlux
@DefFluxSeries RadSeries = Radiation

export FluxSeries, ETSeries, RadSeries
````

## File: DataType/Params/BEPS_Param.jl
````julia
@bounds @with_kw_noshow mutable struct ParamBEPS{FT<:AbstractFloat}
  N::Int = 5
  dz::Vector{FT} = FT[0.05, 0.10, 0.20, 0.40, 1.25]  # 土壤层厚度 [m], BEPS V2023
  r_drainage::FT = Cdouble(0.50) | (0.2, 0.7)  # ? 地表排水速率（地表汇流），可考虑采用曼宁公式

  ψ_min::FT = Cdouble(33.0)  # [m], about 0.10~0.33 MPa开始胁迫点
  alpha::FT = Cdouble(0.4)   # [-], 土壤水限制因子参数，He 2017 JGR-B, Eq. 4

  hydraulic::ParamSoilHydraulicLayers{FT} = ParamSoilHydraulicLayers{FT,N}()
  thermal::ParamSoilThermalLayers{FT} = ParamSoilThermalLayers{FT,N}()

  veg::ParamVeg{FT} = ParamVeg{FT}()
end

# `kw...`: other params like, `r_drainage`
function ParamBEPS(VegType::Int, SoilType::Int; N::Int=5, FT=Float64, kw...)
  veg = InitParam_Veg(VegType; FT)
  hydraulic, thermal = InitParam_Soil(SoilType, N, FT)

  ψ_min = veg.is_bforest ? FT(10.0) : FT(33.0) # 开始胁迫点
  alpha = veg.is_bforest ? FT(1.5) : FT(0.4)   # 土壤水限制因子参数，He 2017 JGR-B, Eq. 4

  ParamBEPS{FT}(;
    N, kw..., ψ_min, alpha,
    hydraulic, thermal, veg
  )
end


# 这里应该加一个show function，打印模型参数信息
function Base.show(io::IO, model::M) where {M<:ParamBEPS}
  printstyled(io, "$M, N = $(model.N)\n", color=:blue, bold=true)

  fields_all = fieldnames(M)
  fields = setdiff(fields_all, [:N, :hydraulic, :thermal, :veg])

  n = length(fields)
  for i = 1:n
    field = fields[i]
    value = getfield(model, field)
    type = typeof(value)
    isa(value, Function) && (type = Function)
    println(io, "  $field\t: {$type} $value")
    # (i != n) && print(io, "\n")
  end

  ss = 60
  println(io, "-"^ss)
  printstyled(io, "Hydraulic: ", color=:blue, bold=true)
  print(io, model.hydraulic)

  println(io, "-"^ss)
  printstyled(io, "Thermal: ", color=:blue, bold=true)
  print(io, model.thermal)

  println(io, "-"^ss)
  printstyled(io, "Veg: ", color=:blue, bold=true)
  print(io, model.veg)
  print("-"^ss)
  return nothing
end


# DBF or EBF, low constaint threshold
function Params2Soil!(soil::Soil, params::ParamBEPS{FT}; BF=false) where {FT}
  soil.ψ_min = BF ? 10.0 : 33.0 # [m], about 0.10~0.33 MPa开始胁迫点
  soil.alpha = BF ? 1.5 : 0.4   # He 2017 JGR-B, Eq. 4

  (; hydraulic, thermal, N) = params
  soil.n_layer = Cint(N)
  soil.dz[1:5] .= [0.05, 0.10, 0.20, 0.40, 1.25] # BEPS V2023, 土壤层厚度[m]

  soil.r_drainage = Cdouble(params.r_drainage)
  soil.r_root_decay = Cdouble(params.veg.r_root_decay)
  UpdateRootFraction!(soil) # 更新根系分布

  soil.ψ_min = Cdouble(params.ψ_min)
  soil.alpha = Cdouble(params.alpha)

  soil.θ_vfc[1:N] .= Cdouble.(hydraulic.θ_vfc)
  soil.θ_vwp[1:N] .= Cdouble.(hydraulic.θ_vwp)
  soil.θ_sat[1:N] .= Cdouble.(hydraulic.θ_sat)
  soil.K_sat[1:N] .= Cdouble.(hydraulic.K_sat)
  soil.ψ_sat[1:N] .= Cdouble.(hydraulic.ψ_sat)
  soil.b[1:N] .= Cdouble.(hydraulic.b)

  soil.κ_dry[1:N] .= Cdouble.(thermal.κ_dry)
  soil.ρ_soil[1:N] .= Cdouble.(thermal.ρ_soil)
  soil.V_SOM[1:N] .= Cdouble.(thermal.V_SOM)
end
Params2Soil!(soil::AbstractSoil, params::Nothing) = nothing


function Soil2Params!(params::ParamBEPS{FT}, soil::Soil) where {FT}
  N = Int(soil.n_layer)
  params.N = N

  params.r_drainage = FT(soil.r_drainage)
  params.veg.r_root_decay = FT(soil.r_root_decay)
  params.ψ_min = FT(soil.ψ_min)
  params.alpha = FT(soil.alpha)

  if length(params.dz) != N
    resize!(params.dz, N)
  end
  params.dz .= FT.(soil.dz[1:N])

  (; hydraulic, thermal) = params

  for field in (:θ_vfc, :θ_vwp, :θ_sat, :K_sat, :ψ_sat, :b)
    dest = getfield(hydraulic, field)
    src = getfield(soil, field)
    if length(dest) != N
      resize!(dest, N)
    end
    dest .= FT.(src[1:N])
  end

  for field in (:κ_dry, :ρ_soil, :V_SOM)
    dest = getfield(thermal, field)
    src = getfield(soil, field)
    if length(dest) != N
      resize!(dest, N)
    end
    dest .= FT.(src[1:N])
  end
  return params
end
````

## File: DataType/Params/GlobalData.jl
````julia
using JSON

const PATH_VEG = joinpath(@__DIR__, "data", "ParamVeg.json")
const PATH_GEN = joinpath(@__DIR__, "data", "ParamGeneral.json")

_types = ["ENF", "DNF", "DBF", "EBF", "Shrub-SH", "C4", "default"]
_codes = [1, 2, 6, 9, 13, 40, -1]

readGeneralParam() = JSON.parsefile(PATH_GEN)

function readVegRaw(lc::Int=1)
  veg_data = JSON.parsefile(PATH_VEG)
  type_idx = findfirst(x -> x == lc, _codes)
  type_str = type_idx !== nothing ? _types[type_idx] : "default"
  return veg_data[type_str]
end


const SOIL_PARAMS = [
  (name="sand",
    b=[1.7, 1.9, 2.1, 2.3, 2.5],
    K_sat=[0.000058, 0.000052, 0.000046, 0.000035, 0.000010],
    θ_sat=0.437, θ_vfc=0.09, θ_vwp=0.03,
    ψ_sat=[0.07, 0.08, 0.09, 0.10, 0.12],
    κ_dry=8.6),
  (name="loamy_sand",
    b=[2.1, 2.3, 2.5, 2.7, 2.9],
    K_sat=[0.000017, 0.000015, 0.000014, 0.000010, 0.000003],
    θ_sat=0.437, θ_vfc=0.21, θ_vwp=0.06,
    ψ_sat=[0.09, 0.10, 0.11, 0.12, 0.14],
    κ_dry=8.3),
  (name="sandy_loam",
    b=[3.1, 3.3, 3.5, 3.7, 3.9],
    K_sat=[0.0000072, 0.00000648, 0.00000576, 0.00000432, 0.00000144],
    θ_sat=0.453, θ_vfc=0.21, θ_vwp=0.10,
    ψ_sat=[0.15, 0.16, 0.17, 0.18, 0.20],
    κ_dry=8.0),
  (name="loam",
    b=[4.5, 4.7, 4.9, 5.1, 5.3],
    K_sat=[0.0000037, 0.0000033, 0.00000296, 0.00000222, 0.00000074],
    θ_sat=0.463, θ_vfc=0.27, θ_vwp=0.12,
    ψ_sat=[0.11, 0.12, 0.13, 0.14, 0.16],
    κ_dry=7.0),
  (name="silty_loam",
    b=[4.7, 4.9, 5.1, 5.3, 5.5],
    K_sat=[0.0000019, 0.0000017, 0.00000152, 0.00000114, 0.00000038],
    θ_sat=0.501, θ_vfc=0.33, θ_vwp=0.13,
    ψ_sat=[0.21, 0.22, 0.23, 0.24, 0.26],
    κ_dry=6.3),
  (name="sandy_clay_loam",
    b=[4.0, 4.2, 4.4, 4.6, 4.8],
    K_sat=[0.0000012, 0.00000108, 0.00000096, 0.00000072, 0.00000024],
    θ_sat=0.398, θ_vfc=0.26, θ_vwp=0.15,
    ψ_sat=[0.28, 0.29, 0.30, 0.31, 0.33],
    κ_dry=7.0),
  (name="clay_loam", # 7
    b=[5.2, 5.4, 5.6, 5.8, 6.0],
    K_sat=[0.00000064, 0.00000058, 0.00000051, 0.00000038, 0.00000013],
    θ_sat=0.464, θ_vfc=0.32, θ_vwp=0.20,
    ψ_sat=[0.26, 0.27, 0.28, 0.29, 0.31],
    κ_dry=5.8),
  (name="silty_clay_loam",
    b=[6.6, 6.8, 7.0, 7.2, 7.4],
    K_sat=[0.00000042, 0.00000038, 0.00000034, 0.000000252, 0.000000084],
    θ_sat=0.471, θ_vfc=0.37, θ_vwp=0.32,
    ψ_sat=[0.33, 0.34, 0.35, 0.36, 0.38],
    κ_dry=4.2),
  (name="sandy_clay",
    b=[6.0, 6.2, 6.4, 6.6, 6.8],
    K_sat=[0.00000033, 0.0000003, 0.000000264, 0.000000198, 0.000000066],
    θ_sat=0.430, θ_vfc=0.34, θ_vwp=0.24,
    ψ_sat=[0.29, 0.30, 0.31, 0.32, 0.34],
    κ_dry=6.3),
  (name="silty_clay",
    b=[7.9, 8.1, 8.3, 8.5, 8.7],
    K_sat=[0.00000025, 0.000000225, 0.0000002, 0.00000015, 0.00000005],
    θ_sat=0.479, θ_vfc=0.39, θ_vwp=0.25,
    ψ_sat=[0.34, 0.35, 0.36, 0.37, 0.39],
    κ_dry=4.0),
  (name="clay",
    b=[7.6, 7.8, 8.0, 8.2, 8.4],
    K_sat=[0.00000017, 0.000000153, 0.000000136, 0.000000102, 0.000000034],
    θ_sat=0.475, θ_vfc=0.40, θ_vwp=0.27,
    ψ_sat=[0.37, 0.38, 0.39, 0.40, 0.42],
    κ_dry=4.4)
]

export SOIL_PARAMS
````

## File: DataType/Params/macro.jl
````julia
export parameters, update!

using DataFrames

abstract type AbstractLayers{FT} end
abstract type AbstractModel{FT} end
abstract type AbstractBEPSmodel{FT} <: AbstractModel{FT} end

macro make_layers_struct(sname, sname_new=nothing)
  isnothing(sname_new) && (sname_new = Symbol(sname, :Layers))

  stype = getfield(__module__, sname)
  names_list = collect(fieldnames(stype))
  types_list = fieldtypes(stype)
  
  x = stype() # for default values
  values = map(fname -> getfield(x, fname), names_list)

  field_expressions = []
  # push!(field_expressions, :(ntime::Int = 100))
  for (i, fname) in enumerate(names_list)
    ftype = types_list[i]
    value = values[i]
    ftype <: AbstractVector && continue
    push!(field_expressions, :($fname::Vector{FT} = fill($value, N)))
  end

  quote
    @with_kw mutable struct $sname_new{FT,N} <: AbstractLayers{FT}
      $(field_expressions...)
    end
    has_definedbounds(x::$sname) = true
    has_definedbounds(x::$sname_new) = true

    function get_params(x::$sname_new{FT,N}; path=[]) where {FT,N}
      subtype = $sname
      # fields = fieldnames(Type)
      res = map(field -> begin
          value = getfield(x, field)
          _path = [path..., field]
          bound = bounds(subtype, field)
          map(i -> (; path=[_path..., i], name=field,
              value=value[i], type = eltype(value), bound=bound), 1:N)
        end, $names_list)
      vcat(res...)
    end
  end |> esc
end

has_definedbounds(x) = false


## 把 bounds 分解成字段路径和对应的约束
function split_bounds(x::S) where {S}
  function use_predef(field)
    # 如果是一个结构体，则采用递归的方式
    value = getfield(x, field)
    has_definedbounds(value) || isstructtype(typeof(value))
  end
  fields = fieldnames(S)
  (filter(use_predef, fields), filter(!use_predef, fields))
end


function get_params(x::S; path=[]) where {S}
  fs_predef, fs_macro = split_bounds(x)

  res_predef = map(field -> begin
      value = getfield(x, field)
      get_params(value; path=[path..., field])
    end, fs_predef)

  res_macro = map(field -> begin
      # @show bounds(x, field)
      value = getfield(x, field)
      (; path=[path..., field], name=field,
        value, type=eltype(value), bound=bounds(x, field))
    end, fs_macro)
  res = vcat(res_macro..., res_predef...)
  filter(x -> !isnothing(x.bound), res)
end


function update!(model::S, paths::Vector, values::Vector{FT},
  ; params::Union{Nothing,DataFrame}=nothing) where {S,FT}
  isnothing(params) && (params = parameters(model))

  for (path, value) in zip(paths, values)
    rows = filter(row -> row.path == path, params)
    if isempty(rows)
      error("Parameter path $(path) not found in model!")
    elseif size(rows, 1) > 1
      error("Duplicated parameters found for path $(path)!")
    end
    update!(model, rows.path[1], value; type=rows.type[1])
  end
end

function update!(model::S, path::Vector, value::FT; type::Type) where {S,FT}
  if length(path) == 1
    # @show model, path[1], value
    setfield!(model, path[1], type(value))
  elseif length(path) > 1
    submodel = getfield(model, path[1]) # 

    if isa(submodel, Vector) # 如果是多模型
      models = submodel
      i = path[2]
      
      if typeof(models[i]) == FT
        models[i] = type(value)
        return
      end
      # 下面是应对Struct Vector
      update!(models[i], path[3:end], value; type)
    else
      update!(submodel, path[2:end], value; type)
    end
  end
end

parameters(model) = get_params(model) |> DataFrame

function get_opt_info(model)
  df = parameters(model)
  x0 = Float64.(df.value)
  lb = Float64[b[1] for b in df.bound]
  ub = Float64[b[2] for b in df.bound]
  paths = df.path
  return x0, lb, ub, paths
end
````

## File: DataType/Params/Param_Init.jl
````julia
# const RTIMES = 24.0 # 呼吸作用系数转换常数 (day -> hour)

"""
    InitParam_Veg(lc::Int=1; FT=Float64)

读取 JSON 配置文件并返回 ParamVeg 结构体。
"""
function InitParam_Veg(lc::Int=1; FT=Float64)
  veg_data = JSON.parsefile(PATH_VEG)
  gen_data = JSON.parsefile(PATH_GEN)

  type_idx = findfirst(x -> x == lc, _codes)
  type_str = type_idx !== nothing ? _types[type_idx] : "default"
  v = veg_data[type_str]

  return ParamVeg{FT}(
    has_understory = !(lc == 25 || lc == 40),
    LAI_max_o    = FT(v["LAI_max_o"]),
    LAI_max_u    = FT(v["LAI_max_u"]),
    α_canopy_vis = FT(v["albedo_canopy_vis"]),
    α_canopy_nir = FT(v["albedo_canopy_nir"]),
    α_soil_sat   = FT(gen_data["albedo_saturated_soil"]),
    α_soil_dry   = FT(gen_data["albedo_dry_soil"]),
    z_canopy_o   = FT(v["z_canopy_o"]),
    z_canopy_u   = FT(v["z_canopy_u"]),
    z_wind       = FT(gen_data["the_height_to_measure_wind_speed"]),
    g1_w         = FT(v["g1_w"]),
    g0_w         = FT(gen_data["intercept_for_H2O_ball_berry"]),
    VCmax25      = FT(v["VCmax25"]),
    N_leaf       = FT(v["N_leaf"]),
    slope_Vc     = FT(v["slope_Vc"])
  )
end


"""
    InitParam_Soil(SoilType::Int, N::Int, FT::Type)

Initialize soil hydraulic and thermal parameters.
SoilType: 1=sand, 2=loamy sand, 3=sandy loam, 4=loam, 5=silty loam,
          6=sandy clay loam, 7=clay loam, 8=silty clay loam,
          9=sandy clay, 10=silty clay, 11=clay
"""
function InitParam_Soil(SoilType::Int, N::Int, FT::Type)
  idx = (1 <= SoilType <= 11) ? SoilType : 11
  p = SOIL_PARAMS[idx]

  n = min(N, 5)
  b = FT.(p.b[1:n])            # [-], campbell's b parameter

  K_sat = FT.(p.K_sat[1:n])    # [m s-1], 应该把它转为[cm h-1]
  θ_sat = fill(FT(p.θ_sat), n) # [%]
  θ_vfc = fill(FT(p.θ_vfc), n) # [%]
  θ_vwp = fill(FT(p.θ_vwp), n) # [%]
  ψ_sat = FT.(p.ψ_sat[1:n])    # [m], positive suction at saturation (Campbell 1974 convention)

  SOIL_THERMAL_DENSITY = [1300.0, 1500.0, 1517.0, 1517.0, 1517.0] # [kg m-3]
  SOIL_ORGANIC_MATTER = [0.05, 0.02, 0.01, 0.01, 0.003]           # volume fraction, 0-1

  κ_dry = fill(FT(p.κ_dry), n) # [W m-1 K-1]
  ρ_soil = FT.(SOIL_THERMAL_DENSITY[1:n]) # [kg m-3]
  V_SOM = FT.(SOIL_ORGANIC_MATTER[1:n])   # [volume fraction], 0-1

  hydraulic = ParamSoilHydraulicLayers{FT,N}(; θ_vfc, θ_vwp, θ_sat, K_sat, ψ_sat, b)
  thermal = ParamSoilThermalLayers{FT,N}(; κ_dry, ρ_soil, V_SOM)
  return hydraulic, thermal
end

# if VegType == 6 || VegType == 9 # DBF or EBF, low constaint threshold
#   p.ψ_min = 10.0 # ψ_min
#   p.alpha = 1.5
# else
#   p.ψ_min = 33.0 # ψ_min
#   p.alpha = 0.4
# end
````

## File: DataType/Params/ParamPhoto.jl
````julia
"""
    InitParam_Photo_Farquhar(VegType::Int=1; FT=Float64)

初始化 Farquhar 光合作用参数（使用硬编码默认值）

# Arguments
- `VegType::Int=1`: 植被类型代码（用于未来扩展，当前使用通用默认值）
- `FT::Type=Float64`: 浮点类型

# Returns
- `ParamPhoto_Farquhar{FT}`: 光合作用参数结构体

# Examples
```julia
params = InitParam_Photo_Farquhar(6)  # DBF（当前使用通用默认值）
```
"""
function InitParam_Photo_Farquhar(VegType::Int=1; FT=Float64)
  # 当前版本使用硬编码默认值
  # 未来可以根据 VegType 从 JSON 加载不同参数
  return ParamPhoto_Farquhar{FT}()
end


# ===== 光合作用模块参数 =====

"""
    ParamPhoto_Farquhar{FT<:AbstractFloat}

Farquhar 光合作用模型参数

# Fields
- **Vcmax25**: 25°C 时的最大羧化速率 [μmol m-2 s-1]
- **Jmax25**: 25°C 时的最大电子传递速率 [μmol m-2 s-1]
- **Rd25_ratio**: 暗呼吸与 Vcmax25 的比率 [-]
- **evc**: Vcmax 活化能 [J mol-1]
- **ejm**: Jmax 活化能 [J mol-1]
- **erd**: 暗呼吸活化能 [J mol-1]
- **toptvc**: Vcmax 最适温度 [K]
- **toptjm**: Jmax 最适温度 [K]
- **kc25**: CO2 Michaelis 常数 [μmol mol-1]
- **ko25**: O2 Michaelis 常数 [mmol mol-1]
- **tau25**: Rubisco 特异性因子 [mmol mol-1]
- **qalpha**: 量子效率 [-]
- **theta2**: 电子传输曲率参数 [-]
- **g0_w**: Ball-Berry 气孔导度截距 [mol m-2 s-1]
- **g1_w**: Ball-Berry 气孔导度斜率 [-]
- **clumping**: 叶片聚集指数 [-]
"""
@bounds @with_kw mutable struct ParamPhoto_Farquhar{FT<:AbstractFloat}
  # ===== Farquhar 模型核心参数 =====
  Vcmax25::FT = 89.45 | (5.0, 200.0)              # [μmol m-2 s-1] 最大羧化速率
  Jmax25::FT = 2.39 * 89.45 - 14.2 | (50.0, 400.0) # [μmol m-2 s-1] 最大电子传递速率

  # ===== 呼吸参数 =====
  Rd25_ratio::FT = 0.004657 | (0.001, 0.01)       # [-] Rd/Vcmax25 比率
  Rd_light_factor::FT = 0.4 | (0.2, 0.6)          # [-] 光下呼吸降低因子

  # ===== 温度响应参数 [J mol-1] =====
  evc::FT = 30000.0 | (20000.0, 80000.0)          # Vcmax 活化能
  ejm::FT = 40000.0 | (20000.0, 80000.0)          # Jmax 活化能
  erd::FT = 38000.0 | (20000.0, 60000.0)          # 暗呼吸活化能

  # ===== 最适温度 [K] =====
  toptvc::FT = 298.15 | (288.15, 308.15)          # Vcmax 最适温度
  toptjm::FT = 298.15 | (288.15, 308.15)          # Jmax 最适温度

  # ===== Michaelis-Menten 常数 =====
  kc25::FT = 404.0 | (200.0, 600.0)               # [μmol mol-1] CO2
  ko25::FT = 248.0 | (150.0, 400.0)               # [mmol mol-1] O2 Michaelis 常数
  tau25::FT = 2600.0 | (2000.0, 3000.0)           # [mmol mol-1] Rubisco 特异性

  # ===== 电子传输参数 =====
  qalpha::FT = 0.3 | (0.2, 0.5)                   # [-] 量子效率
  theta2::FT = 0.7 | (0.5, 0.9)                   # [-] 曲率参数

  # ===== 气孔导度参数 =====
  g0_w::FT = 0.001 | (0.0, 0.01)                  # [mol m-2 s-1] Ball-Berry 截距
  g1_w::FT = 4.0 | (1.0, 10.0)                    # [-] Ball-Berry 斜率

  # ===== 冠层结构参数 =====
  clumping::FT = 0.85 | (0.5, 1.0)                # [-] 叶片聚集指数
end

export ParamPhoto_Farquhar
export InitParam_Photo_Farquhar
````

## File: DataType/Params/Params.jl
````julia
export ParamVeg
export ParamSoilHydraulic, ParamSoilThermal, ParamSoil,
  ParamSoilHydraulicLayers, ParamSoilThermalLayers
export ParamBEPS


using Parameters, DataFrames
import FieldMetadata: @metadata, @units, units
@metadata bounds nothing

include("macro.jl")

@bounds @with_kw mutable struct ParamVeg{FT<:AbstractFloat}
  # lc::Int = 1
  # Ω0::FT = 0.7             # // clumping_index
  has_understory::Bool = true      # 
  is_bforest::Bool = false         # broadleaf forest

  LAI_max_o::FT = 4.5 | (0.1, 7.0)      # LAI max for overstory
  LAI_max_u::FT = 2.4 | (0.1, 7.0)      # LAI max for understory

  α_canopy_vis::FT = 0.055 | (0.02, 0.15)  # canopy albedo visible
  α_canopy_nir::FT = 0.300 | (0.15, 0.50)  # canopy albedo near-infrared
  α_soil_sat::FT = 0.10 | (0.05, 0.20)     # albedo of saturated soil
  α_soil_dry::FT = 0.35 | (0.20, 0.50)     # albedo of dry soil

  # r_drainage::FT = 0.5     # ? 产流比例
  r_root_decay::FT = Cdouble(0.95) | (0.85, 0.999) # ? 根系分布衰减率, decay_rate_of_root_distribution

  z_canopy_o::FT = 1.0 | (0.1, 50.0)    # overstory canopy height [m]
  z_canopy_u::FT = 0.2 | (0.05, 5.0)    # understory canopy height [m]
  z_wind::FT = 2 | (1.0, 100.0)         # wind measurement height [m]

  g1_w::FT = 8 | (1.0, 20.0)            # Ball-Berry slope coefficient
  g0_w::FT = 0.0175 | (0.001, 0.1)      # Ball-Berry intercept for H2O

  VCmax25::FT = 89.45 | (5.0, 200.0)    # max Rubisco capacity at 25℃ [μmol m-2 s-1], global range
  # Jmax25::FT = 2.39 * 57.7 - 14.2 #

  # # coefficient reflecting the sensitivity of stomata to VPD/moderately N-stressed plants
  N_leaf::FT = 1.74 + 0.71 | (0.5, 5.0)   # leaf Nitrogen content, mean value + 1 SD [g/m2]
  slope_Vc::FT = 33.79 / 57.7 | (0.3, 1.0) # slope for Vcmax-N relationship
end


# 水力参数
@bounds @with_kw mutable struct ParamSoilHydraulic{FT<:AbstractFloat}
  θ_vfc::FT = FT(0.3) | (0.1, 0.4)  # volumetric field capacity
  θ_vwp::FT = FT(0.1) | (0.1, 0.5)  # volumetric wilting point
  θ_sat::FT = FT(0.45) | (0.1, 0.6) # volumetric saturation
  K_sat::FT = FT(1e-5) | (0.1, 0.7) # saturated hydraulic conductivity
  ψ_sat::FT = FT(-0.5) | (0.1, 0.9) # soil matric potential at saturation
  b::FT = FT(5.0) | (0.1, 0.4) # Cambell parameter b
end

# 热力参数
@bounds @with_kw mutable struct ParamSoilThermal{FT<:AbstractFloat}
  κ_dry::FT = FT(0.2) | (0.05, 0.5)          # dry soil thermal conductivity [W m-1 K-1]
  ρ_soil::FT = FT(1300.0) | (1000.0, 2000.0) # soil bulk density [kg m-3]
  V_SOM::FT = FT(0.02) | (0.0, 0.3)          # organic matter volume fraction [-]
end

@make_layers_struct ParamSoilHydraulic
@make_layers_struct ParamSoilThermal

@with_kw mutable struct ParamSoil{FT<:AbstractFloat}
  hydraulic::ParamSoilHydraulic{FT} = ParamSoilHydraulic{FT}()
  thermal::ParamSoilThermal{FT} = ParamSoilThermal{FT}()
end


include("GlobalData.jl")
include("Param_Init.jl")

include("BEPS_Param.jl")

include("deprecated/VegHelper.jl")
include("deprecated/ReadParamVeg.jl")
include("deprecated/Init_Soil_Parameters.jl")

include("ParamPhoto.jl")
````

## File: DataType/PhotoConsts.jl
````julia
@with_kw mutable struct PhotoConsts{T}
  Γ::T = 0.0
  K::T= 0.0
  Rd_factor::T = 0.0
  Jmax_factor::T = 0.0
  Vcmax_factor::T = 0.0
end

function init_photo_consts(T_leaf_K::T) where {T<:Real}
  tprime25 = T_leaf_K - TK25
  T_factor = tprime25 / (TK25 * rugc * T_leaf_K)

  Kc = kc25 * exp(ekc * T_factor)
  Ko = ko25 * exp(eko * T_factor)
  tau = tau25 * exp(ektau * T_factor)
  Γ = 0.5 * o2 / tau * 1000.0

  K = Kc * (1.0 + o2 / Ko)
  Rd_factor = exp(erd * T_factor)

  Jmax_factor = TBOLTZ(1.0, ejm, toptjm, T_leaf_K)
  Vcmax_factor = TBOLTZ(1.0, evc, toptvc, T_leaf_K)
  Γ, K, Rd_factor, Jmax_factor, Vcmax_factor
end

function PhotoConsts(T_leaf_K::T) where {T<:Real}
  Γ, K, Rd_factor, Jmax_factor, Vcmax_factor = init_photo_consts(T_leaf_K)
  return PhotoConsts{T}(Γ, K, Rd_factor, Jmax_factor, Vcmax_factor)
end

function PhotoConsts!(pc::PhotoConsts{T}, T_leaf_K::T) where {T<:Real}
  Γ, K, Rd_factor, Jmax_factor, Vcmax_factor = init_photo_consts(T_leaf_K)
  @pack! pc = Γ, K, Rd_factor, Jmax_factor, Vcmax_factor
end
````

## File: DataType/setup.jl
````julia
# JAX 风格 setup：st, ps = setup(model)
# st = 状态变量(会变), ps = 模型参数(不变)
export setup


## Internal Helpers ============================================================
# 从 ParamBEPS 初始化 StateBEPS
function _init_state(ps::ParamBEPS, Tsoil, Ta, θ0, z_snow)
  st = StateBEPS(; n_layer=Cint(ps.N))
  st.dz[1:ps.N] .= ps.dz
  UpdateRootFraction!(st, ps)
  Init_Soil_T_θ!(st, Float64(Tsoil), Float64(Ta), Float64(θ0), Float64(z_snow))
  st.Tsnow_c .= Float64(Ta)
  st
end

# 初始化 Soil (Julia/C 版本)
function _init_soil(version::String, VegType::Int, SoilType::Int,
    r_drainage, r_root_decay, Tsoil, Ta, θ0, z_snow)
  soil = version == "julia" ? Soil() : Soil_c()
  soil.r_drainage = r_drainage
  Init_Soil_Parameters(soil, VegType, SoilType, r_root_decay)
  Init_Soil_T_θ!(soil, Float64(Tsoil), Float64(Ta), Float64(θ0), Float64(z_snow))
  soil
end


## Setup Functions (JAX Style) =================================================
"从 Soil 拆分为 (StateBEPS, ParamBEPS)"
function setup(soil::Soil; FT=Float64)
  st = StateBEPS(soil)
  ps = ParamBEPS{FT}(); Soil2Params!(ps, soil)
  st, ps
end

"直接构造 (StateBEPS, ParamBEPS)，无需先创建 Soil"
function setup(VegType::Int, SoilType::Int;
    Ta::Real=20.0, Tsoil::Real=Ta, θ0::Real=0.3, z_snow::Real=0.0,
    r_drainage::Real=0.5, r_root_decay::Real=0.95, N::Int=5, FT::Type=Float64)
  ps = ParamBEPS(VegType, SoilType; N, FT, r_drainage)
  ps.veg.r_root_decay = FT(r_root_decay)
  _init_state(ps, Tsoil, Ta, θ0, z_snow), ps
end

"纯关键字参数版本"
setup(; VegType::Int, SoilType::Int, kw...) = setup(VegType, SoilType; kw...)

"从已有 ParamBEPS 构造状态"
function setup(ps::ParamBEPS; Ta::Real=20.0, Tsoil::Real=Ta, θ0::Real=0.3, z_snow::Real=0.0)
  _init_state(ps, Tsoil, Ta, θ0, z_snow), ps
end


## Legacy Setup (setup_model) ==================================================
"统一 setup，通过 version 区分 Julia/C 版本，返回 (Soil, State, Params)"
function setup_model(VegType::Int, SoilType::Int;
    version::String="julia", Ta::Real=20.0, Tsoil::Real=Ta, θ0::Real=0.3, z_snow::Real=0.0,
    r_drainage::Real=0.5, r_root_decay::Real=0.95, FT::Type=Float64)
  soil = _init_soil(version, VegType, SoilType, r_drainage, r_root_decay, Tsoil, Ta, θ0, z_snow)
  state = version == "julia" ? StateBEPS(soil) : zeros(41)
  InitState!(soil, state, Float64(Ta))
  ps = ParamBEPS(VegType, SoilType; FT)
  version == "julia" && Soil2Params!(ps, soil)
  soil, state, ps
end

setup_jl(args...; kw...) = setup_model(args...; version="julia", kw...)
setup_c(args...; kw...) = setup_model(args...; version="c", kw...)

export setup_model, setup_c, setup_jl
````

## File: DataType/StateSeries.jl
````julia
export StateSeries, save_state!, split_vars
using OrderedCollections

const StateSeries{S<:NamedTuple,V<:NamedTuple} =
    NamedTuple{(:scalars, :vectors),Tuple{S,V}}


"""
预分配状态输出缓冲区
- scalar_fields: 标量字段名, e.g. (:z_water, :z_snow)
- vector_fields: 向量字段名, e.g. (:θ, :Tsoil_c)
"""
function StateSeries(::Val{SF}, ::Val{VF}, n_layer::Int, n_time::Int) where {SF,VF}
    Ns, Nv = length(SF), length(VF)
    s = NamedTuple{SF}(ntuple(_ -> Vector{Float64}(undef, n_time), Ns))
    v = NamedTuple{VF}(ntuple(_ -> Matrix{Float64}(undef, n_layer, n_time), Nv))
    (; scalars=s, vectors=v)
end

@generated function save_state!(out::StateSeries, st::StateBEPS, t::Int,
    ::Val{SF}, ::Val{VF}) where {SF,VF}
    nlayer = 5
    s_ex = [:(out.scalars.$(SF[i])[t] = st.$(SF[i])) for i in eachindex(SF)]
    v_ex = [:(copyto!(view(out.vectors.$(VF[i]), :, t), view(st.$(VF[i]), 1:$nlayer)))
            for i in eachindex(VF)]
    quote
        $(s_ex...)
        $(v_ex...)
        nothing
    end
end

save_state!(out::Nothing, st::StateBEPS, t::Int, ::Val{SF}, ::Val{VF}) where {SF,VF} = nothing


"""
    split_vars(vars) -> (sf::Val, vf::Val)

根据 VARS_SCALAR / VARS_VECTOR 将 vars 划分为标量和向量两组，并做合法性检查。
"""
function split_vars(vars)
    vars = Symbol.(vars)
    known = Set(fieldnames(StateBEPS))

    # 检查字段是否存在于 StateBEPS
    unknown = filter(v -> v ∉ known, vars)
    isempty(unknown) || error("字段不存在于 StateBEPS: $unknown")

    # 检查字段是否在可导出列表中
    exportable = Set((VARS_SCALAR..., VARS_VECTOR...))
    excluded = filter(v -> v ∉ exportable, vars)
    isempty(excluded) || @warn "字段在排除列表中，无法导出: $excluded"

    sf = Val(Tuple(v for v in vars if v ∈ Set(VARS_SCALAR)))
    vf = Val(Tuple(v for v in vars if v ∈ Set(VARS_VECTOR)))
    sf, vf
end

Base.Dict(nt::NamedTuple) = OrderedDict(pairs(nt))

function Base.getindex(out::StateSeries, i::Int)
    scalars = map(x -> x[i], out.scalars)
    vectors = map(x -> x[:, i], out.vectors)
    # Dict(:scalars => Dict(scalars), :vectors => Dict(vectors))
    (; scalars..., vectors...) |> Dict
end


function _print_section(io, nt, prefix)
    names = keys(nt)
    nw = maximum(length ∘ string, names)
    for (i, fname) in enumerate(names)
        c = i == length(names) ? "└" : "├"
        data = nt[fname]
        mb = round(Base.summarysize(data) / 1024^2, digits=2)
        print(io, "$(prefix)$(c)─ ")
        printstyled(io, rpad(string(fname), nw); bold=true, color=:blue)
        print(io, "  ", typeof(data), " | ", size(data), " | ")
        printstyled(io, "$mb Mb\n"; color=:blue, bold=true, underline=true)
    end
end

function Base.show(io::IO, ::MIME"text/plain", out::StateSeries)
    N = 52
    printstyled(io, "─"^N * "\n")
    # println(io, "─ scalars:")
    _print_section(io, out.scalars, "")
    printstyled(io, "─"^N * "\n")
    # println(io, "─ vectors:")
    _print_section(io, out.vectors, "")
    printstyled(io, "─"^N * "")
    return nothing
end
````

## File: evaporation_canopy.jl
````julia
function evaporation_canopy_jl(T_leaf::Leaf, Ta::Float64, RH::Float64,
  Gwater::Leaf, lai::Leaf,
  perc_water::Layer2{Float64},
  perc_snow::Layer3{Float64})
  # perc_water_o::Float64, perc_water_u::Float64,
  # perc_snow_o::Float64, perc_snow_u::Float64)

  # LHw = Leaf()  # latent heat from leaves W/m2, caused by evaporation of intercepted rain
  # LHs = Leaf()  # latent heat from leaves W/m2, caused by evaporation of intercepted snow
  met = meteo_pack_jl(Ta, RH)
  λ = met.λ # 2.5*e6 J / kg

  # leaf level latent heat caused by evaporation or sublimation
  LHw_o_sunlit = perc_water.o * latent_heat(Ta, T_leaf.o_sunlit, Gwater.o_sunlit, met)
  LHw_o_shaded = perc_water.o * latent_heat(Ta, T_leaf.o_shaded, Gwater.o_shaded, met)
  LHw_u_sunlit = perc_water.u * latent_heat(Ta, T_leaf.u_sunlit, Gwater.u_sunlit, met)
  LHw_u_shaded = perc_water.u * latent_heat(Ta, T_leaf.u_shaded, Gwater.u_shaded, met)

  LHs_o_sunlit = perc_snow.o * latent_heat(Ta, T_leaf.o_sunlit, Gwater.o_sunlit, met)
  LHs_o_shaded = perc_snow.o * latent_heat(Ta, T_leaf.o_shaded, Gwater.o_shaded, met)
  LHs_u_sunlit = perc_snow.u * latent_heat(Ta, T_leaf.u_sunlit, Gwater.u_sunlit, met)
  LHs_u_shaded = perc_snow.u * latent_heat(Ta, T_leaf.u_shaded, Gwater.u_shaded, met)

  E_water_o = (LHw_o_sunlit * lai.o_sunlit + LHw_o_shaded * lai.o_shaded) / λ
  E_water_u = (LHw_u_sunlit * lai.u_sunlit + LHw_u_shaded * lai.u_shaded) / λ

  E_snow_o = (LHs_o_sunlit * lai.o_sunlit + LHs_o_shaded * lai.o_shaded) / λ_snow
  E_snow_u = (LHs_u_sunlit * lai.u_sunlit + LHs_u_shaded * lai.u_shaded) / λ_snow

  return E_water_o, E_water_u, E_snow_o, E_snow_u
end
````

## File: evaporation_soil.jl
````julia
"""
# Return
- `Ewater`: evaporation from water
- `Esoil`: evaporation from soil
- `Esoil_g`: evaporation from snow
"""
function evaporation_soil_jl(Tair::FT, Tg::FT, RH::FT, Rn_g::FT, Gheat_g::FT,
  # perc_snow_g::Ref{FT}, 
  perc_snow::Layer3{FT},
  z_water::FT, z_snow::FT,
  # z_water::Ref{FT}, z_snow::Ref{FT},
  mass_water_g::FT, mass_snow::Layer3{FT},
  ρ_snow::FT, swc_g::FT, porosity_g::FT; kstep=360.0) where {FT<:Real}

  met = meteo_pack_jl(Tg, RH)
  (; ρₐ, cp, VPD, Δ, γ) = met
  λ = cal_lambda(Tair) #

  Gwater_g = 1.0 / (4.0 * exp(8.2 - 4.2 * swc_g / porosity_g))

  perc_snow.g = z_snow > 0.02 ? 1.0 : mass_snow.g / (0.025 * ρ_snow)
  perc_snow.g = clamp(perc_snow.g, 0.0, 1.0)

  if z_water > 0.0 && z_snow == 0.0
    Ewater_g = 1.0 / λ * (Δ * (Rn_g * 0.8 - 0) + ρₐ * cp * VPD * Gheat_g) /
               (Δ + γ * (1 + (Gheat_g) / 0.01))
  else
    Ewater_g = 0.0
  end

  Ewater_g = max(-0.002 / kstep, Ewater_g)
  if Ewater_g > 0.0
    Ewater_g = min(Ewater_g, (z_water * ρ_w) / kstep)
  end

  z_water = z_water - (Ewater_g / ρ_w) * kstep
  z_water = max(0, z_water)
  mass_water_g = mass_water_g - Ewater_g * kstep

  if z_snow > 0.0
    Esoil_g = 1 / λ_snow * (Δ * (Rn_g * 0.8 - 0) + ρₐ * cp * VPD * Gheat_g) /
              (Δ + γ * (1 + (Gheat_g) / 0.01)) * perc_snow.g
  else
    Esoil_g = 0.0
  end

  Esoil_g = max(-0.002 / kstep, Esoil_g)
  if Esoil_g > 0.0
    Esoil_g = min(Esoil_g, mass_snow.g / kstep)
  end

  mass_snow.g = max(mass_snow.g - Esoil_g * kstep, 0)
  z_snow = mass_snow.g > 0.0 ? z_snow - (Esoil_g / ρ_snow) * kstep : 0.0

  if z_water > 0.0 || z_snow > 0.0
    Esoil = 0.0
  else
    Esoil = (1.0 - (perc_snow.g)) * 1 / (λ) * (Δ * (Rn_g - 0) + ρₐ * cp * VPD * Gheat_g) /
            (Δ + γ * (1 + Gheat_g / Gwater_g))
    Esoil = max(0.0, Esoil)
  end

  Esoil, Ewater_g, Esoil_g, z_water, z_snow
end
````

## File: heat_H_and_LE.jl
````julia
function latent_heat(Ta::Float64, Ts::Float64, gw::Float64, met::NamedTuple)
  (; VPD, Δ, γ, cp, ρₐ) = met
  (VPD + Δ * (Ts - Ta)) * ρₐ * cp * gw / γ
  # (met.VPD + met.slope * (Ts - Ta)) * met.ρₐ * met.cp * gw / met.γ
end

function latent_heat!(leleaf::Leaf, Gw::Leaf, VPD, slope, Tc_old::Leaf, Tair, ρₐ, cp, γ)
  leleaf.o_sunlit = Gw.o_sunlit * (VPD + slope * (Tc_old.o_sunlit - Tair)) * ρₐ * cp / γ
  leleaf.o_shaded = Gw.o_shaded * (VPD + slope * (Tc_old.o_shaded - Tair)) * ρₐ * cp / γ
  leleaf.u_sunlit = Gw.u_sunlit * (VPD + slope * (Tc_old.u_sunlit - Tair)) * ρₐ * cp / γ
  leleaf.u_shaded = Gw.u_shaded * (VPD + slope * (Tc_old.u_shaded - Tair)) * ρₐ * cp / γ
end

function transpiration_jl(T_leaf::Leaf, Ta::Float64, RH::Float64, Gtrans::Leaf, lai::Leaf)

  met = meteo_pack_jl(Ta, RH)
  (; ρₐ, cp, VPD, λ, Δ, γ) = met

  T = Leaf() # transpiration
  # Luo, 2018, JGR-Biogeosciences
  T.o_sunlit = (VPD + Δ * (T_leaf.o_sunlit - Ta)) * ρₐ * cp * Gtrans.o_sunlit / γ
  T.o_shaded = (VPD + Δ * (T_leaf.o_shaded - Ta)) * ρₐ * cp * Gtrans.o_shaded / γ
  T.u_sunlit = (VPD + Δ * (T_leaf.u_sunlit - Ta)) * ρₐ * cp * Gtrans.u_sunlit / γ
  T.u_shaded = (VPD + Δ * (T_leaf.u_shaded - Ta)) * ρₐ * cp * Gtrans.u_shaded / γ

  trans_o = (T.o_sunlit * lai.o_sunlit + T.o_shaded * lai.o_shaded) / λ
  trans_u = (T.u_sunlit * lai.u_sunlit + T.u_shaded * lai.u_shaded) / λ

  trans_o, trans_u
end



function sensible_heat(T_w::FT, T_a::FT, ρₐ::FT, cp::FT, gH::FT)::FT
  (T_w - T_a) * ρₐ * cp * gH
end

function sensible_heat(T_leaf::Leaf, T_a::FT, ρₐ::FT, cp::FT, gH::Leaf)
  SH = Leaf()
  SH.o_sunlit = (T_leaf.o_sunlit - T_a) * ρₐ * cp * gH.o_sunlit
  SH.o_shaded = (T_leaf.o_shaded - T_a) * ρₐ * cp * gH.o_shaded
  SH.u_sunlit = (T_leaf.u_sunlit - T_a) * ρₐ * cp * gH.u_sunlit
  SH.u_shaded = (T_leaf.u_shaded - T_a) * ρₐ * cp * gH.u_shaded
  SH
end

function sensible_heat_jl(T_leaf::Leaf, T_ground::FT, Ta::FT, RH::FT,
  Gheat::Leaf, Gheat_g::FT, lai::Leaf)

  met = meteo_pack_jl(Ta, RH)
  (; ρₐ, cp) = met # cp: specific heat of moist air above canopy

  SH = sensible_heat(T_leaf, Ta, ρₐ, cp, Gheat)
  SH_o::FT = SH.o_sunlit * lai.o_sunlit + SH.o_shaded * lai.o_shaded
  SH_u::FT = SH.u_sunlit * lai.u_sunlit + SH.u_shaded * lai.u_shaded

  SH_o = max(-200.0, SH_o)
  SH_u = max(-200.0, SH_u)
  SH_g::FT = (T_ground - Ta) * ρₐ * cp * Gheat_g

  SH_o, SH_u, SH_g
end


function Leaf_Temperature_jl(Tair::Float64, Δ::Float64, γ::Float64, VPD::Float64, cp::Float64,
  Gw::Float64, Gw_wet::Float64, Gh::Float64, Xc_sl::Float64, Rn::Float64, constrain::Bool=true)

  p_star = (Gw + Gw_wet * Xc_sl) / γ
  Tc = Tair + (Rn - VPD * ρₐ * cp * p_star) / (ρₐ * cp * (Gh + Δ * p_star))

  constrain && (Tc = clamp(Tc, Tair - 3.0, Tair + 5.0))
  return Tc
end


function Leaf_Temperatures_jl(Tair::Float64, Δ::Float64, γ::Float64,
  VPD::Float64, cp::Float64,
  Gw::Leaf, Gw_wet::Leaf, Gh::Leaf,
  Xcl::Layer2{Float64}, Xcs::Layer3{Float64},
  # Xcs_o::Float64, Xcl_o::Float64,
  # Xcs_u::Float64, Xcl_u::Float64,
  Rn::Leaf, Tc::Leaf)

  args = (Tair, Δ, γ, VPD, cp)
  Tc.o_sunlit = Leaf_Temperature_jl(args...,
    Gw.o_sunlit, Gw_wet.o_sunlit, Gh.o_sunlit, Xcs.o + Xcl.o, Rn.o_sunlit)

  Tc.o_shaded = Leaf_Temperature_jl(args...,
    Gw.o_shaded, Gw_wet.o_shaded, Gh.o_shaded, Xcs.o + Xcl.o, Rn.o_shaded)

  Tc.u_sunlit = Leaf_Temperature_jl(args...,
    Gw.u_sunlit, Gw_wet.u_sunlit, Gh.u_sunlit, Xcs.u + Xcl.u, Rn.u_sunlit)

  Tc.u_shaded = Leaf_Temperature_jl(args...,
    Gw.u_shaded, Gw_wet.u_shaded, Gh.u_shaded, Xcs.u + Xcl.u, Rn.u_shaded)
end
````

## File: inter_prg.jl
````julia
"""
The inter-module function between main program and modules

# Arguments

- `clumping`  : clumping index
- `param`     : parameter array according to land cover types
- `soilp`     : soil coefficients according to land cover types and soil textures
- `mid_flux`  : results struct
"""
function inter_prg_jl(jday::Int, hour::Int, lon::T, lat::T,
  lai::T, Ω::T,
  forcing::Met, ps::ParamBEPS{T}, state::StateBEPS,
  mid_flux::Flux, mid_ET::ETFlux, cache::LeafCache;
  # 内循环参数
  kstep::Float64=360.0, atol::Float64 = 0.02, maxn::Int=10,
  # 过程参数
  fix_sm::Bool=false, fix_Tsoil::Bool=false,
  fix_Ta_annual::Bool=true,
  fix_snowpack::Bool=true, Ta_annual::Float64=10.0,
  kw...) where {T}

  @unpack Tc_old, Tc_new, Gh, Gw, Gw_wet,
  GPP, LAI, PAI = cache

  CosZs::T = s_coszs(jday, hour, lat, lon)
  # ===== 1. 参数提取和计算 =====
  (; α_canopy_vis, α_canopy_nir,
    α_soil_sat, α_soil_dry, z_canopy_o, z_canopy_u, z_wind,
    g0_w, g1_w, VCmax25, N_leaf, slope_Vc) = ps.veg
  θ_vwp = ps.hydraulic.θ_vwp
  θ_sat = ps.hydraulic.θ_sat

  Vcmax_sunlit, Vcmax_shaded = VCmax(lai, Ω, CosZs, VCmax25, N_leaf, slope_Vc)
  lai_o, lai_u, stem_o, stem_u = lai2!(ps.veg, Ω, CosZs, lai, LAI, PAI)

  # ===== 2. 气象变量初始化 =====
  (; Rs, Rln_in, Tair, RH, Uz) = forcing
  precip = forcing.Prcp / step
  met = meteo_pack_jl(Tair, RH) # 变量类型转换

  # ===== 3. 表面状态初始化 =====
  Tc_old .= Tair - 0.5

  # 雪水状态 [kg/m² or m]
  m_snow_pre, m_water_pre = state.m_snow, state.m_water
  m_snow, m_water = Layer3(0.0), Layer2()
  z_snow = state.z_snow
  z_water = state.z_water < 0.001 ? 0.0 : state.z_water

  # 雪覆盖和反照率 [-]
  frac_snow, A_snow, frac_water = Layer3(0.0), Layer2(), Layer2()
  α_v = Rs <= 0 ? Layer3() : Layer3(α_canopy_vis)
  α_n = Rs <= 0 ? Layer3() : Layer3(α_canopy_nir)
  ρ_snow, α_v_sw, α_n_sw = init_dbl(state.ρ_snow), init_dbl(), init_dbl()
  Tc = Layer3()

  # 土壤临时变量和中间变量
  radiation_o = radiation_u = radiation_g = ra_g = 0.0

  # ET 相关局部变量
  Trans_o, Trans_u = 0.0, 0.0
  Eil_o, Eil_u = 0.0, 0.0
  EiS_o, EiS_u = 0.0, 0.0
  Evap_soil, Evap_SW, Evap_SS = 0.0, 0.0, 0.0
  Qhc_o, Qhc_u, Qhg = state.Qhc_o, 0.0, 0.0  # Qhc_o 从 state 初始化
  r_rain_g = 0.0

  pai_o = lai_o + stem_o
  pai_u = lai_u + stem_u

  geo_params = (; z_canopy_o, z_canopy_u, z_wind, Ω, lai_o, lai_u, pai_o, pai_u)
  biophys_params = (; g0_w, g1_w, Vcmax_sunlit, Vcmax_shaded)

  # 对雪面温度进行限制
  prev = state.Tsnow_p # 基于地址的修改
  curr = state.Tsnow_c
  clamp!(prev, curr, Tair)
  clamp!(curr, curr, Tair)

  # ===== 4. 亚小时循环 =====
  kloop = round(Int, step / kstep) # default, 360秒/步, 10步/小时
  @inbounds for k = 1:kloop
    k > 1 && (prev .= curr) # 更新 prev 为上一子时间步的值（k≥3时）

    !fix_snowpack && (ρ_snow[] = 0.0) # TODO: exact as C
    α_v_sw[], α_n_sw[] = 0.0, 0.0

    # /*****  Snowpack stage 1 by X. Luo  *****/
    z_snow = snowpack_stage1_jl(Tair, precip, lai_o, lai_u, Ω,
      m_snow_pre, m_snow, frac_snow, A_snow,
      z_snow, ρ_snow, α_v_sw, α_n_sw; kstep)

    # /*****  Rainfall stage 1 by X. Luo  *****/
    r_rain_g = rainfall_stage1_jl(Tair, precip, frac_water, m_water, m_water_pre, lai_o, lai_u, Ω; kstep)

    # 土壤反照率计算 [-]
    α_g = if state.θ_prev[2] < θ_vwp[2] * 0.5
      α_soil_dry
    else
      (state.θ_prev[2] - θ_vwp[2] * 0.5) / (θ_sat[2] - θ_vwp[2] * 0.5) *
      (α_soil_sat - α_soil_dry) + α_soil_dry
    end
    α_v.g = 2.0 / 3.0 * α_g
    α_n.g = 4.0 / 3.0 * α_g

    # /*****  Soil water factor module by L. He  *****/
    soil_water_factor_v2(state, ps)
    f_soilwater = min(state.f_soilwater, 1.0) # used in `photosynthesis`

    # 感热通量初值用于空气动力学导度计算 [W/m²]
    H_canopy_o = Qhc_o  # 使用上一步的值

    perc_snow_o = A_snow.o / lai_o / 2 # 上层冠层雪覆盖分数
    perc_snow_u = A_snow.u / lai_u / 2 # 下层冠层雪覆盖分数

    Tc.g = Tair   # 地表温度初值用气温代替

    # 能量平衡迭代求解冠层温度
    # /*****  Canopy Energy Balance Iteration extracted by AI Agent  *****/
    snow_params = (; perc_snow_o, perc_snow_u, frac_snow, frac_water, α_v_sw, α_n_sw, α_v, α_n)

    radiation_o, radiation_u, radiation_g, ra_g, _ = solve_canopy_energy_balance!(
      cache, met, forcing, geo_params, snow_params, biophys_params,
      Tc, H_canopy_o, CosZs, f_soilwater, frac_water; atol, maxn
    )

    Trans_o, Trans_u = transpiration_jl(Tc_new, Tair, RH, Gw, LAI) # X. Luo

    # /*****  Evaporation and sublimation from canopy by X. Luo  *****/
    Eil_o, Eil_u, EiS_o, EiS_u = evaporation_canopy_jl(Tc_new, Tair, RH,
      Gw_wet, PAI, frac_water, frac_snow)

    rainfall_stage2_jl(Eil_o, Eil_u, m_water; kstep) # X. Luo
    m_water_pre .= m_water

    snowpack_stage2_jl(EiS_o, EiS_u, m_snow; kstep) # X. Luo

    # /*****  Evaporation from soil module by X. Luo  *****/
    # ra_g 是地表到参考高度的总阻抗 (地表→下层冠层→上层冠层→参考高度)
    Gheat_g = 1 / ra_g  # 地表空气动力学传热导度 [m/s]
    mass_water_g = ρ_w * z_water  # 地表水质量 [kg/m²]

    Evap_soil, Evap_SW, Evap_SS, z_water, z_snow =
      evaporation_soil_jl(Tair, prev.T_surf, RH, radiation_g, Gheat_g,
        frac_snow, z_water, z_snow, mass_water_g, m_snow,
        ρ_snow[], state.θ_prev[1], θ_sat[1]; kstep)

    # /*****  Surface temperature by X. Luo  *****/
    state.G[1] = surface_temperature!(state, ps, prev, curr,
      radiation_g, Tc.u, Tair, RH, z_snow, z_water,
      ρ_snow[], frac_snow.g, Gheat_g,
      Evap_soil, Evap_SW, Evap_SS; kstep)

    # /*****  Snowpack stage 3 by X. Luo  *****/
    z_snow, z_water = snowpack_stage3_jl(Tair, curr.T_snow0, prev.T_snow0,
      ρ_snow[], z_snow, z_water, m_snow; kstep)
    m_snow_pre .= m_snow
    state.z_snow = z_snow

    # /*****  Sensible heat flux by X. Luo  *****/
    Qhc_o, Qhc_u, Qhg = sensible_heat_jl(Tc_new, curr.T_surf, Tair, RH, Gh, Gheat_g, PAI)
    _Ta_annual = fix_Ta_annual ? Ta_annual : Tair
    UpdateHeatFlux(state, _Ta_annual, kstep; fix_Tsoil) # fix kdd, v20260502

    # /*****  Soil water module by L. He  *****/
    Root_Water_Uptake(state, Trans_o, Trans_u, Evap_soil)

    state.r_rain_g = r_rain_g
    state.z_water = z_water

    UpdateSoilMoisture(state, ps, kstep; fix_sm)
    z_water = state.z_water
  end  # end of sub-hourly loop

  # ===== 5. 时间步结束：状态更新 =====
  state.Qhc_o = Qhc_o
  state.m_water .= m_water
  state.m_snow .= m_snow
  state.ρ_snow = ρ_snow[]

  # ===== 6. 输出结果汇总 =====
  @pack! mid_ET = Trans_o, Trans_u, Eil_o, Eil_u, EiS_o, EiS_u,
  Evap_soil, Evap_SW, Evap_SS, Qhc_o, Qhc_u, Qhg
  update_ET!(mid_ET, mid_flux, Tair)

  mid_flux.Net_Rad = radiation_o + radiation_u + radiation_g
  mid_flux.gpp_o_sunlit = GPP.o_sunlit
  mid_flux.gpp_u_sunlit = GPP.u_sunlit
  mid_flux.gpp_o_shaded = GPP.o_shaded
  mid_flux.gpp_u_shaded = GPP.u_shaded

  mid_flux.z_water = z_water
  mid_flux.z_snow = z_snow
  mid_flux.ρ_snow = ρ_snow[]

  GPP = GPP.o_sunlit + GPP.o_shaded + GPP.u_sunlit + GPP.u_shaded
  mid_flux.GPP = GPP * 12 * step * 1e-6  # [umol m-2 s-1] -> [gC m-2]
  nothing
end


"""
    solve_canopy_energy_balance!(cache, met, forcing, geo_params, snow_params, biophys_params,
        Tc, H_canopy_o, CosZs, f_water)

# Arguments
- `atol`: Absolute tolerance for Tc convergence (default: 0.02°C)
- `max`: Maximum number of iterations (default: 10)

Iteratively solves the canopy energy balance to determine canopy temperatures and fluxes.
Extracted from `inter_prg_jl` to improve readability and maintainability.
"""
function solve_canopy_energy_balance!(
  cache::LeafCache, met::NamedTuple, forcing::Met,
  geo_params, snow_params, biophys_params,
  Tc::Layer3{T}, H_canopy_o::Float64, CosZs::T, f_soilwater::T, frac_water::Layer2{T};
  atol::Float64 = 0.02, maxn::Int=10
) where {T}

  # Unpack required variables
  @unpack pc, ac, Ra, Cs_old, Cs_new, Ci_old,
  Tc_old, Tc_new, Gs_old, Gc, Gh, Gw, Gw_wet,
  Gs_new, Ci_new, Ac, GPP, LAI, Rn, Rns, Rnl,
  leleaf, PAI = cache

  (; ρₐ, cp, VPD, ea, Δ, γ) = met
  (; Tair, RH, Uz, Rln_in) = forcing
  (; z_canopy_o, z_canopy_u, z_wind, Ω, lai_o, lai_u, pai_o, pai_u) = geo_params
  (; perc_snow_o, perc_snow_u, frac_snow, α_v_sw, α_n_sw, α_v, α_n) = snow_params
  (; g0_w, g1_w, Vcmax_sunlit, Vcmax_shaded) = biophys_params

  Rs = forcing.Rs # Directly use shortwave radiation

  # /*****  短波辐射（迭代内不变，提前计算一次）  *****/
  PAI_o_sum = PAI.o_sunlit + PAI.o_shaded
  PAI_u_sum = PAI.u_sunlit + PAI.u_shaded
  is_daytime = CosZs > 0

  Rns_o, Rns_u, Rns_g = netRadiation_SW!(Rs, CosZs, lai_o, lai_u, pai_o, pai_u, PAI, Ω,
    α_v_sw[], α_n_sw[], α_v, α_n,
    perc_snow_o, perc_snow_u, frac_snow.g, Rns, Ra)

  radiation_o = radiation_u = radiation_g = ra_g = 0.0
  n_iter = 0

  Ci_old .= 0.7 * CO2_air
  init_leaf_dbl2(Gs_old, 1.0 / 200.0, 1.0 / 300.0)

  # 光合作用相关常量，不随迭代改变
  if !is_daytime
    Gs_new .= 0.0001
    Ac .= 0.0
    Ci_new .= CO2_air * 0.7
    Cs_new .= CO2_air
    # Cc_new .= CO2_air * 0.7 * 0.8
    Ci_old .= Ci_new
    Cs_old .= Cs_new
    Gs_old .= Gs_new
  end

  T_leaf_K = Tair + 273.13 # TODO, 认为leaf温度为Tair, error root
  PhotoConsts!(pc, T_leaf_K) # 计算光合的常量
  AeroConsts!(ac, z_canopy_o, z_canopy_u, z_wind, Ω, Tair, Uz, pai_o)

  while true
    n_iter += 1
    # /***** Aerodynamic conductance module by G.Mo  *****/
    # ra_o, ra_u, ra_g, Ga_o, Gb_o, Ga_u, Gb_u = aerodynamic_conductance_jl(
    #   z_canopy_o, z_canopy_u, z_wind,
    #   Ω, Tair, Uz, H_canopy_o, pai_o, pai_u)
    ra_o, ra_u, ra_g = ra_updateH(
      H_canopy_o, z_wind, z_canopy_o, z_canopy_u,
      ac.ustar, ac.coef_L, ac.gamma_u, ac.exp_u, ac.exp_g_u)
    Ga_o = 1.0 / ra_o
    Ga_u = 1.0 / (ra_o + ra_u)
    Gb_o = 1.0 / ac.rb_o
    Gb_u = 1.0 / ac.rb_u

    # 热量传输导度 [mol/m²/s]
    init_leaf_dbl2(Gh,
      1.0 / (1.0 / Ga_o + 0.5 / Gb_o),
      1.0 / (1.0 / Ga_u + 0.5 / Gb_u))
    # 水汽传输导度 (湿表面) [mol/m²/s]
    init_leaf_dbl2(Gw_wet,
      1.0 / (1.0 / Ga_o + 1.0 / Gb_o + 100),
      1.0 / (1.0 / Ga_u + 1.0 / Gb_u + 100))

    # 上下层冠层平均温度 [°C]
    Tc.o = (Tc_old.o_sunlit * PAI.o_sunlit + Tc_old.o_shaded * PAI.o_shaded) / PAI_o_sum
    Tc.u = (Tc_old.u_sunlit * PAI.u_sunlit + Tc_old.u_shaded * PAI.u_shaded) / PAI_u_sum

    # /*****  长波辐射（依赖 Tc，每次迭代更新）  *****/
    radiation_o, radiation_u, radiation_g = netRadiation_LW!(
      Tc, lai_o, lai_u, pai_o, pai_u, PAI, Ω, Tair, RH,
      Rln_in, Rns_o, Rns_u, Rns_g, Rns, Rnl, Rn)

    # /*****  Photosynthesis module by B. Chen  *****/
    update_Gw!(Gw, Gs_old, Ga_o, Ga_u, Gb_o, Gb_u) # 水汽导度
    latent_heat!(leleaf, Gw, VPD, Δ, Tc_old, Tair, ρₐ, cp, γ)

    if is_daytime
      photosynthesis(Tc_old, Rns, Ci_old, leleaf,
        Tair, ea, f_soilwater, g0_w, g1_w,
        Gb_o, Gb_u, Vcmax_sunlit, Vcmax_shaded,
        Gs_new, Ac, Ci_new; version="julia", pc) # TODO: 未来若采用T_leaf, 则应移除pc

      Ci_old .= Ci_new
      Cs_old .= Cs_new
      Gs_old .= Gs_new
    end

    update_Gw!(Gw, Gs_new, Ga_o, Ga_u, Gb_o, Gb_u)
    update_Gc!(Gc, Gs_new, Ga_o, Ga_u, Gb_o, Gb_u)

    # /***** Leaf temperatures module by L. He  *****/
    Leaf_Temperatures_jl(Tair, Δ, γ, VPD, cp,
      Gw, Gw_wet, Gh, frac_water, frac_snow, Rn, Tc_new)

    # 计算上层冠层感热通量用于下次迭代 [W/m²]
    H_o_sunlit = (Tc_new.o_sunlit - Tair) * ρₐ * cp * Gh.o_sunlit
    H_o_shaded = (Tc_new.o_shaded - Tair) * ρₐ * cp * Gh.o_shaded
    H_canopy_o = H_o_sunlit * PAI.o_sunlit + H_o_shaded * PAI.o_shaded

    # 检查冠层温度是否收敛 (精度0.02°C)
    if (abs(Tc_new.o_sunlit - Tc_old.o_sunlit) < atol &&
        abs(Tc_new.o_shaded - Tc_old.o_shaded) < atol &&
        abs(Tc_new.u_sunlit - Tc_old.u_sunlit) < atol &&
        abs(Tc_new.u_shaded - Tc_old.u_shaded) < atol)
      break               # 收敛，退出循环
    else
      if (n_iter > maxn)  # 迭代未收敛，使用气温作为冠层温度
        Tc_old .= Tair
        break
      else
        Tc_old .= Tc_new
      end
    end
  end
  multiply!(GPP, Ac, LAI)
  return radiation_o, radiation_u, radiation_g, ra_g, H_canopy_o
end
````

## File: netRadiation.jl
````julia
"""
## Arguments
- `T`                 : temperature of o, u, g
- `α_v, α_n`          : albedo of visible, near infrared
- `percentArea_snow_o`: percentage of snow on overstorey (by area)
- `percentArea_snow_u`: percentage of snow on understorey (by area)
- `percent_snow_g`    : percentage of snow on ground (by mass)
"""
function netRadiation_jl(Rs_global::FT, CosZs::FT,
  T::Layer3{FT},
  lai_o::FT, lai_u::FT, lai_os::FT, lai_us::FT,
  lai::Leaf,
  Ω::FT, Tair::FT, RH::FT, Rln_in::FT,
  α_snow_v::FT, α_snow_n::FT, α_v::Layer3{FT}, α_n::Layer3{FT},
  percArea_snow_o::FT, percArea_snow_u::FT, perc_snow_g::FT,
  Rn_Leaf::Leaf, Rns_Leaf::Leaf, Rnl_Leaf::Leaf, Ra::Radiation) where {FT<:Real}

  Rns_o, Rns_u, Rns_g = netRadiation_SW!(Rs_global, CosZs,
    lai_o, lai_u, lai_os, lai_us, lai, Ω,
    α_snow_v, α_snow_n, α_v, α_n,
    percArea_snow_o, percArea_snow_u, perc_snow_g,
    Rns_Leaf, Ra)

  netRadiation_LW!(T, lai_o, lai_u, lai_os, lai_us, lai, Ω, Tair, RH, Rln_in,
    Rns_o, Rns_u, Rns_g, Rns_Leaf, Rnl_Leaf, Rn_Leaf)
end


# 短波辐射计算（迭代过程中不随温度变化，每小时只需在迭代前调用一次）
function netRadiation_SW!(Rs_global::FT, CosZs::FT,
  lai_o::FT, lai_u::FT, lai_os::FT, lai_us::FT,
  lai::Leaf,
  Ω::FT,
  α_snow_v::FT, α_snow_n::FT, α_v::Layer3{FT}, α_n::Layer3{FT},
  percArea_snow_o::FT, percArea_snow_u::FT, perc_snow_g::FT,
  Rns_Leaf::Leaf, Ra::Radiation) where {FT<:Real}

  # calculate α of canopy in this step
  α_v_os::FT = α_v.o * (1.0 - percArea_snow_o) + α_snow_v * percArea_snow_o  # visible, overstory
  α_n_os::FT = α_n.o * (1.0 - percArea_snow_o) + α_snow_n * percArea_snow_o  # near infrared
  α_v_us::FT = α_v.u * (1.0 - percArea_snow_u) + α_snow_v * percArea_snow_u  # understory
  α_n_us::FT = α_n.u * (1.0 - percArea_snow_u) + α_snow_n * percArea_snow_u

  α_o::FT = 0.5 * (α_v_os + α_n_os)
  α_u::FT = 0.5 * (α_v_us + α_n_us)

  # calculate α of ground in this step
  α_v_gs::FT = α_v.g * (1.0 - perc_snow_g) + α_snow_v * perc_snow_g
  α_n_gs::FT = α_n.g * (1.0 - perc_snow_g) + α_snow_n * perc_snow_g
  α_g::FT = 0.5 * (α_v_gs + α_n_gs)

  # separate global solar radiation into direct and diffuse one
  # solar zenith angle small, all diffuse radiation
  ratio_cloud = (CosZs < 0.001) ? 0.0 : Rs_global / (1367 * CosZs)  # Luo2018, A4

  if (ratio_cloud > 0.8)
    Ra.Rs_df = 0.13 * Rs_global  # Luo2018, A2
  else
    Ra.Rs_df = (0.943 + 0.734 * ratio_cloud - 4.9 * pow((ratio_cloud), 2) +
             1.796 * pow((ratio_cloud), 3) + 2.058 * pow((ratio_cloud), 4)) * Rs_global  # Luo2018, A2
  end

  Ra.Rs_df = clamp(Ra.Rs_df, 0.0, Rs_global)
  Ra.Rs_dir = Rs_global - Ra.Rs_df  # Luo2018, A3

  # fraction at each layer of canopy, direct and diffuse. use Leaf only lai here
  τ_o_dir::FT = exp(-0.5 * Ω * lai_o / CosZs)
  τ_u_dir::FT = exp(-0.5 * Ω * lai_u / CosZs)

  # indicators to describe leaf distribution angles in canopy. slightly related with LAI
  cosQ_o::FT = 0.537 + 0.025 * lai_o  # Luo2018, A10, a representative zenith angle for diffuse radiation transmission
  cosQ_u::FT = 0.537 + 0.025 * lai_u

  τ_o_df::FT  = exp(-0.5 * Ω * lai_o  / cosQ_o)
  τ_os_df::FT = exp(-0.5 * Ω * lai_os / cosQ_o)  # considering stem

  τ_u_df::FT  = exp(-0.5 * Ω * lai_u  / cosQ_u)
  τ_us_df::FT = exp(-0.5 * Ω * lai_us / cosQ_u)

  # net short direct radiation on canopy and ground
  if Rs_global > 0.0 && CosZs > 0.0
    Ra.Rns_o_dir = Ra.Rs_dir * ((1.0 - α_o) - (1.0 - α_u) * τ_o_dir)  # dir into dif_under
    Ra.Rns_u_dir = Ra.Rs_dir * τ_o_dir * ((1.0 - α_u) - (1.0 - α_g) * τ_u_dir)
    Ra.Rns_g_dir = Ra.Rs_dir * τ_o_dir * τ_u_dir * (1.0 - α_g)
  else
    Ra.Rns_o_dir = 0.0
    Ra.Rns_u_dir = 0.0
    Ra.Rns_g_dir = 0.0
  end

  # net short diffuse radiation on canopy and ground
  if Rs_global > 0.0 && CosZs > 0.0
    Ra.Rns_o_df = Ra.Rs_df * ((1.0 - α_o) - (1.0 - α_u) * τ_o_df) +
               0.21 * Ω * Ra.Rs_dir * (1.1 - 0.1 * lai_o) * exp(-CosZs)  # A8
    Ra.Rns_u_df = Ra.Rs_df * τ_o_df * ((1.0 - α_u) - (1.0 - α_g) * τ_u_df) +
               0.21 * Ω * Ra.Rs_dir * τ_o_dir * (1.1 - 0.1 * lai_u) * exp(-CosZs)  # A9
    Ra.Rns_g_df = Ra.Rs_df * τ_o_df * τ_u_df * (1.0 - α_g)
  else
    Ra.Rns_o_df = 0.0
    Ra.Rns_u_df = 0.0
    Ra.Rns_g_df = 0.0
  end

  # total net shortwave radiation at canopy level
  Rns_o = Ra.Rns_o_dir + Ra.Rns_o_df
  Rns_u = Ra.Rns_u_dir + Ra.Rns_u_df
  Rns_g = Ra.Rns_g_dir + Ra.Rns_g_df

  if Rs_global > 0.0 && CosZs > 0.0 # only happens in day time, when sun is out
    Rs_o_dir = 0.5 * Ra.Rs_dir / CosZs
    Rs_o_dir = min(Rs_o_dir, 0.7 * 1362)
    Rs_u_dir = Rs_o_dir

    Rs_o_df = (Ra.Rs_df - Ra.Rs_df * τ_os_df) / lai_os + 0.07 * Ra.Rs_dir * (1.1 - 0.1 * lai_os) * exp(-CosZs)
    Rs_u_df = (Ra.Rs_df * τ_o_df - Ra.Rs_df * τ_o_df * τ_us_df) / lai_us +
              0.05 * Ra.Rs_dir * τ_o_dir * (1.1 - 0.1 * lai_us) * exp(-CosZs)
  else
    Rs_o_dir = 0.0
    Rs_u_dir = 0.0
    Rs_o_df = 0.0
    Rs_u_df = 0.0
  end

  # overstorey sunlit leaves
  Rns_Leaf.o_sunlit = (Rs_o_dir + Rs_o_df) * (1.0 - α_o)
  # overstorey shaded leaf
  Rns_Leaf.o_shaded = Rs_o_df * (1.0 - α_o) # diffuse
  # understorey sunlit leaf
  Rns_Leaf.u_sunlit = (Rs_u_dir + Rs_u_df) * (1.0 - α_u)
  Rns_Leaf.u_shaded = Rs_u_df * (1.0 - α_u)

  return Rns_o, Rns_u, Rns_g
end


# 长波辐射更新（每次迭代调用，因冠层温度 T 随迭代变化）
function netRadiation_LW!(T::Layer3{FT},
  lai_o::FT, lai_u::FT, lai_os::FT, lai_us::FT,
  lai::Leaf,
  Ω::FT, Tair::FT, RH::FT, Rln_in::FT,
  Rns_o::FT, Rns_u::FT, Rns_g::FT,
  Rns_Leaf::Leaf, Rnl_Leaf::Leaf, Rn_Leaf::Leaf) where {FT<:Real}

  Rnl_o, Rnl_u, Rnl_g = cal_Rln_Longwave(Tair, RH, T, lai_o, lai_u, Ω, Rln_in)

  # 计算植被和地面的总净辐射
  Rn_o = Rns_o + Rnl_o
  Rn_u = Rns_u + Rnl_u
  Rn_g = Rns_g + Rnl_g

  # overstorey sunlit leaves
  Rnl_Leaf.o_sunlit = lai.o_sunlit > 0.0 ? Rnl_o / lai_os : Rnl_o
  # overstorey shaded leaf
  Rnl_Leaf.o_shaded = lai.o_shaded > 0.0 ? Rnl_o / lai_os : Rnl_o
  # understorey sunlit leaf
  Rnl_Leaf.u_sunlit = lai.u_sunlit > 0.0 ? Rnl_u / lai_us : Rnl_u
  Rnl_Leaf.u_shaded = lai.u_shaded > 0.0 ? Rnl_u / lai_us : Rnl_u

  Rn_Leaf.o_sunlit = Rns_Leaf.o_sunlit + Rnl_Leaf.o_sunlit
  Rn_Leaf.o_shaded = Rns_Leaf.o_shaded + Rnl_Leaf.o_shaded
  Rn_Leaf.u_sunlit = Rns_Leaf.u_sunlit + Rnl_Leaf.u_sunlit
  Rn_Leaf.u_shaded = Rns_Leaf.u_shaded + Rnl_Leaf.u_shaded

  # 叶片尺度的净辐射更新方式
  # 参考Chen 2012年的聚集指数论文
  Rn_o, Rn_u, Rn_g
end


function cal_Rln_Longwave(Tair::FT, RH::FT, T::Layer3{FT},
  lai_o::FT, lai_u::FT, Ω::FT, Rln_in::FT) where {FT<:Real}

  # indicators to describe leaf distribution angles in canopy. slightly related with LAI
  cosQ_o::FT = 0.537 + 0.025 * lai_o  # Luo2018, A10, a representative zenith angle for diffuse radiation transmission
  cosQ_u::FT = 0.537 + 0.025 * lai_u

  τ_o_df::FT = exp(-0.5 * Ω * lai_o / cosQ_o)
  τ_u_df::FT = exp(-0.5 * Ω * lai_u / cosQ_u)

  # ϵ of each part
  ea = cal_ea(Tair, RH)
  ϵ_air = 1.0 - exp(-(pow(ea * 10.0, (Tair + 273.15) / 1200.0)))
  ϵ_air = clamp(ϵ_air, 0.7, 1.0)

  ϵ_o = 0.98
  ϵ_u = 0.98
  ϵ_g = 0.96

  # 计算植被和地面的净长波辐射
  Rl_air = isfinite(Rln_in) ? Rln_in : cal_Rln(ϵ_air, Tair)
  Rl_o = cal_Rln(ϵ_o, T.o)
  Rl_u = cal_Rln(ϵ_u, T.u)
  Rl_g = cal_Rln(ϵ_g, T.g)

  Rnl_o = (ϵ_o * (Rl_air + Rl_u * (1.0 - τ_u_df) + Rl_g * τ_u_df) - 2 * Rl_o) *
          (1.0 - τ_o_df) +
          ϵ_o * (1.0 - ϵ_u) * (1.0 - τ_u_df) * (Rl_air * τ_o_df + Rl_o * (1.0 - τ_o_df))

  Rnl_u = (ϵ_u * (Rl_air * τ_o_df + Rl_o * (1.0 - τ_o_df) + Rl_g) - 2 * Rl_u) * (1.0 - τ_u_df) +
          (1.0 - ϵ_g) * ((Rl_air * τ_o_df + Rl_o * (1.0 - τ_o_df)) * τ_u_df + Rl_u * (1.0 - τ_u_df)) +
          ϵ_u * (1.0 - ϵ_o) * (Rl_u * (1.0 - τ_u_df) + Rl_g * τ_u_df) * (1.0 - τ_o_df)

  Rnl_g = ϵ_g * ((Rl_air * τ_o_df + Rl_o * (1.0 - τ_o_df)) * τ_u_df + Rl_u * (1.0 - τ_u_df)) -
          Rl_g + (1.0 - ϵ_u) * Rl_g * (1.0 - τ_u_df)

  Rnl_o, Rnl_u, Rnl_g
end
````

## File: photosynthesis_helper.jl
````julia
# TODO: Ta, 这里应该传入Leaf Temperature
function photosynthesis(Tc_old::Leaf, R::Leaf, Ci_old::Leaf, leleaf::Leaf,
  Ta::Cdouble, ea::Cdouble, f_soilwater::Cdouble,
  g0_h2o::Cdouble, g1_h2o::Cdouble,
  Gb_o::Cdouble, Gb_u::Cdouble, Vcmax_sunlit::Cdouble, Vcmax_shaded::Cdouble,
  # output
  Gs_new::Leaf, Ac::Leaf, Ci_new::Leaf; version="c", pc::Union{Nothing,PhotoConsts}=nothing)

  if version == "c"
    fun = photosynthesis_c
  elseif version == "julia"
    fun = photosynthesis_jl
  end

  Gs_new.o_sunlit, Ac.o_sunlit, Ci_new.o_sunlit =
    fun(Tc_old.o_sunlit, R.o_sunlit, ea, Gb_o, Vcmax_sunlit, f_soilwater, g0_h2o, g1_h2o,
      Ci_old.o_sunlit,
      Ta, leleaf.o_sunlit; pc)

  Gs_new.o_shaded, Ac.o_shaded, Ci_new.o_shaded =
    fun(Tc_old.o_shaded, R.o_shaded, ea, Gb_o, Vcmax_shaded, f_soilwater, g0_h2o, g1_h2o,
      Ci_old.o_shaded,
      Ta, leleaf.o_shaded; pc)

  Gs_new.u_sunlit, Ac.u_sunlit, Ci_new.u_sunlit =
    fun(Tc_old.u_sunlit, R.u_sunlit, ea, Gb_u, Vcmax_sunlit, f_soilwater, g0_h2o, g1_h2o,
      Ci_old.u_sunlit,
      Ta, leleaf.u_sunlit; pc)

  Gs_new.u_shaded, Ac.u_shaded, Ci_new.u_shaded =
    fun(Tc_old.u_shaded, R.u_shaded, ea, Gb_u, Vcmax_shaded, f_soilwater, g0_h2o, g1_h2o,
      Ci_old.u_shaded,
      Ta, leleaf.u_shaded; pc)
end


"""
- `ea` : [kPa]
- `Ta` : [°C]
- `ρₐ` : air density [kg m-3]
"""
function cal_rho_a(Ta, ea)
  TK = Ta + 273.13
  ρₐ = ea * 2.165 / TK   # absolute humidity, [kg m-3]
  return ρₐ
end

# atm = 1.013 # 1 atm, [1013.25 hPa] -> 1.013 bar
const pstat273 = 0.022624 / (273.16 * 1.013)

umol_m(gs_mol::T, TK::T) where {T<:Real} = gs_mol * TK * pstat273
m_umol(gs::T, TK::T) where {T<:Real} = gs / (TK * pstat273)

"""
Ball-Berry stomatal conductance model

# Arguments
- `A`  : net photosynthesis rate (mol m-2 s-1)
- `Cs` : CO2 concentration at leaf surface (ppm)
- `RH` : relative humidity at leaf surface (0-1)
- `g0` : the minimum stomatal conductance (umol m-2 s-1)

# Returns
- `gs` : stomatal conductance of co2 (umol m-2 s-1)
"""
function stomatal_conductance(A, Cs, RH, g0, g1, β_soil=1.0)
  gs = g0 + β_soil * g1 * A * RH / Cs
  return gs
end


function sort3(a::T, b::T, c::T) where {T<:Real}
  if a > b
    a, b = b, a
  end
  if b > c
    b, c = c, b
  end
  if a > b
    a, b = b, a
  end
  return a, b, c
end

function findroot(root1::Float64, root2::Float64, root3::Float64)::Float64
  A::Float64 = 0.0
  root_min, root_mid, root_max = sort3(root1, root2, root3)
  # find out where roots plop down relative to the x-y axis
  if root_min > 0 && root_mid > 0 && root_max > 0
    A = root_min
  end
  if root_min < 0 && root_mid < 0 && root_max > 0
    A = root_max
  end
  if root_min < 0 && root_mid > 0 && root_max > 0
    A = root_mid
  end
  A
end


@fastmath function SFC_VPD(T_leaf_K::T, LE::T, λ::T, rᵥ::T, ρₐ::T)::T where {T<:Real}
  es = ES(T_leaf_K)          # mb
  ρᵥ = (LE / λ) * rᵥ + ρₐ    # kg m-3
  e = ρᵥ * T_leaf_K / 0.2165 # mb
  vpd = es - e               # mb
  RH = 1.0 - vpd / es        # 0 to 1.0
  return RH
end

# Function to calculate saturation vapor pressure function in mb
@fastmath function ES(t::T)::T where {T<:Real}
  y1::T = 54.8781919 - 6790.4985 / t - 5.02808 * log(t)
  y::T = exp(y1)
  return y
end

# Maxwell-Boltzmann temperature distribution for photosynthesis
@fastmath function TBOLTZ(rate::T, eakin::T, topt::T, tl::T)::T where {T<:Real}
  hkin::T = 200000.0  # enthalpy term, J mol-1

  dtlopt::T = tl - topt
  prodt::T = rugc * topt * tl
  numm::T = hkin * exp(eakin * dtlopt / prodt)
  denom::T = hkin - eakin * (1.0 - exp(hkin * dtlopt / prodt))
  return rate * numm / denom
end
````

## File: photosynthesis.jl
````julia
"""
A = Ag - Rd, net photosynthesis is the difference between gross photosynthesis
and dark respiration. Note photorespiration is already factored into Ag.

Gs from Ball-Berry is for water vapor.  It must be divided by the ratio of the
molecular diffusivities to be valid for A.

Forests are hypostomatous. Hence, we don't divide the total resistance by 2
since transfer is going on only one side of a leaf.

# Arguments
- `ea`      : [kPa]
- `gb_w`    : leaf laminar boundary layer conductance to H2O, [s m-1]
- `Vcmax25` : the maximum rate of carboxylation of Rubisco at 25℃, [umol m-2 s-1]

- `cii`     : intercellular CO2 concentration (ppm)
- `g0_h2o`  : the minimum stomatal conductance to H2O,      [umol m-2 s-1]
- `g1_h2o`  : the slope of the stomatal conductance to H2O, [unitless]

- `LH_leaf` : latent heat of vaporization of water at the leaf temperature, [W m-2]
- `ca`      : atmospheric co2 concentration (ppm)

# Intermediate variables
- `rh_leaf`    : relative humidity at leaf surface (0-1)
- `gs_c_mol`   : stomatal conductance to CO2 (umol m-2 s-1)
- `gs_w_mol`   : stomatal conductance to h2o (umol m-2 s-1)
- `cs`         : CO2 concentration at leaf surface (ppm)
- `Γ`          : CO2 compensation point (ppm)
- `jmopt`      : the maximum potential electron transport rate at 25 deg C (umol
  m-2 s-1)
- `Jmax`       : the maximum potential electron transport rate (umol m-2 s-1)
- `Vcmax`      : the maximum velocities of carboxylation of Rubisco (umol m-2
  s-1)
- `km_co2`     : Michaelis-Menten constant for CO2 (µmol mol-1)
- `km_o2`      : Michaelis-Menten constant for O2 (mmol mol-1)
- `tau`        : the specifity of Rubisco for CO2 compared with O2
- `Jₓ`         : the flux of electrons through the thylakoid membrane (umol m-2
  s-1)
"""
@fastmath function photosynthesis_jl(T_leaf_p::T, Rsn_leaf::T, ea::T,
  gb_w::T, Vcmax25::T,
  β_soil::T, g0_w::T, g1_w::T, cii::T,
  T_leaf::T, LH_leaf::T, ca::T=CO2_air;
  pc::Union{Nothing,PhotoConsts{T}}=nothing) where {T<:Cdouble}

  PPFD = 4.55 * 0.5 * Rsn_leaf # incident photosynthetic photon flux density (PPFD) umol m-2 s-1
  (2PPFD < 1) && (PPFD = 0.0)
  T_leaf_K = T_leaf + 273.13

  if isnothing(pc)
    Γ, K, Rd_factor, Jmax_factor, Vcmax_factor = init_photo_consts(T_leaf_K)
  else
    (; Γ, K, Rd_factor, Jmax_factor, Vcmax_factor) = pc
  end

  λ = leaf_lambda(T_leaf_p) # [J kg-1], ~2.5MJ kg-1
  rᵥ = 1.0 / gb_w

  ρₐ = cal_rho_a(T_leaf, ea) # [kg m-3]
  gb_c_mol = m_umol(gb_w / 1.6, T_leaf_K) # [s m-1] -> [umol m-2 s-1]

  g0_c = g0_w / 1.6
  g1_c = g1_w / 1.6

  rh_leaf = SFC_VPD(T_leaf_K, LH_leaf, λ, rᵥ, ρₐ)

  Rd25 = Vcmax25 * 0.004657    # leaf dark respiration (umol m-2 s-1)
  # Bin Chen: Reduce respiration by 40% in light according to Amthor
  (2PPFD > 10) && (Rd25 *= 0.4)
  Rd = Rd25 * Rd_factor

  #	jmopt = 29.1 + 1.64*Vcmax25; Chen 1999, Eq. 7
  jmopt = 2.39 * Vcmax25 - 14.2
  Jmax = jmopt * Jmax_factor      # Apply temperature correction to JMAX
  Vcmax = Vcmax25 * Vcmax_factor  # Apply temperature correction to vcmax

  # Farquhar and von Cammerer (1981)
  # /*if (jmax > 0) Jₓ = qalpha * iphoton / sqrt(1. +(qalpha2 * iphoton * iphoton / (jmax * jmax)));
  Jₓ = Jmax * PPFD / (PPFD + 2.1 * Jmax) # chen1999, eq.6, J photon from Harley

  # initial guess of intercellular CO2 concentration to estimate Wc and Wj:
  Wj = Jₓ * (cii - Γ) / (4.0 * cii + 8.0 * Γ)
  Wc = Vcmax * (cii - Γ) / (cii + K)

  # Both have the form: `Ag = A + Rd = (a ci - a d)/(e ci + b)`
  if (Wj < Wc)
    a = Jₓ    # J limited
    b = 8.0 * Γ
    e = 4.0
  else
    a = Vcmax # VCmax limited
    b = K
    e = 1.0
  end
  d = Γ
  An = 0.0

  if !(Wj <= Rd || Wc <= Rd)
    # g_s =  g0 + g1 * rh_leaf * β_soil * A_g
    # g_s =  g0 + _c * A_g, (c = g1 * rh_leaf * β_soil)
    c = g1_c * rh_leaf * β_soil
    α = 1.0 + (g0_c / gb_c_mol) - c
    β = ca * (gb_c_mol * c - 2.0 * g0_c - gb_c_mol)
    γ = ca * ca * gb_c_mol * g0_c
    θ = gb_c_mol * c - g0_c

    An = solve_cubic(α, β, γ, θ, Rd, a, b, d, e, ca)
    # Sucrose limitation of photosynthesis, as suggested by Collatz.  `Js=Vmax/2`
    # net photosynthesis rate limited by sucrose synthesis (umol m-2 s-1)
    j_sucrose = Vcmax / 2.0 - Rd
    An = min(An, j_sucrose)
  end

  if An <= 0.0
    An = solve_quad(ca, gb_c_mol, g0_c, a, b, d, e, Rd)
  end
  An = max(0.0, An)
  cs = ca - An / gb_c_mol

  gs_w_mol = (β_soil * g1_w * rh_leaf * An / cs) + g0_w  # mol m-2 s-1
  gs_c_mol = gs_w_mol / 1.6

  ci = cs - An / gs_c_mol
  gs_w = umol_m(gs_w_mol, T_leaf_K)  # s m-1
  return gs_w, An, ci
end

@fastmath function fTᵥ(eact::T, tprime::T, tref::T, t_lk::T)::T where {T<:Real}
  exp(tprime * eact / (tref * rugc * t_lk))
end

function leaf_lambda(TK::T)::T where {T<:Real}
  y = 3149_000.0 - 2370.0 * TK # J kg-1
  # add heat of fusion for melting ice
  if TK < 273.0
    y += 333_000.0 # TODO: unit error, `y += 333_000.0`
  end
  return y
end

"""
If `Wj` or `Wc` are less than Rd then A would probably be less than 0. This
would yield a negative stomatal conductance.

In this case, assume `gs` equals the cuticular value `g0`. This assumptions
yields a quadratic rather than cubic solution for A.

If `A < 0`, set stomatal conductance to cuticle value. A quadratic solution of A
is derived if gs=b, but a cubic form occur if gs = ax + b.  Use quadratic case
when `A<=0`.

```math
c_s = c_a - A * 1/ g_b
c_i = c_a - A * (1/g_b + 1/g_s)
g_s = g_0
Ag = a(c_i - Gamma) / (e c_i + b})
A = Ag - Rd
```
"""
function solve_quad(ca::T, gb_c_mol::T, g0_c::T, a::T, b::T, d::T, e::T, Rd::T) where {T<:Real}
  D = 1 / gb_c_mol + 1 / g0_c
  _a = -D * e
  _b = e * ca + b - e * Rd * D + a * D
  _c = b * Rd - a * ca + a * d + e * Rd * ca

  Δ = _b^2 - 4 * _a * _c
  if Δ >= 0.0
    An = (-_b + sqrt(Δ)) / 2_a
  else
    An = 0.0
  end
  return An
end


"""
Cubic solution: `A^3 + p A^2 + q A + r = 0`. Let `A = x - p / 3`, => `x^3 + ax + b = 0`
Rank roots #1, #2 and #3 according to the minimum, intermediate and maximum value

```math
c_s = c_a - A * 1/ g_b
c_i = c_a - A * (1/g_b + 1/g_s)
g_s = g_0 + g_1 RH A / c_s
Ag = a(c_i - Gamma) / (e c_i + b})
A = Ag - Rd
```
"""
@fastmath function solve_cubic(α::T, β::T, γ::T, θ::T, Rd::T, a::T, b::T, d::T, e::T, ca::T) where {T<:AbstractFloat}
  m = e * α
  p = (e * β + b * θ - a * α + e * Rd * α) / m
  q = (e * γ + (b * γ / ca) - a * β + a * d * θ + e * Rd * β + Rd * b * θ) / m
  r = (-a * γ + a * d * γ / ca + e * Rd * γ + Rd * b * γ / ca) / m

  # Use solution from Numerical Recipes from Press
  Q = (p * p - 3.0 * q) / 9.0
  U = (2.0 * p * p * p - 9.0 * p * q + 27.0 * r) / 54.0
  (Q < 0) && return T(0.0)

  r3q = U / sqrt(Q * Q * Q)
  r3q = clamp(r3q, -1.0, 1.0) #  by G. Mo
  ψ = acos(r3q)

  root1 = -2sqrt(Q) * cos(ψ / 3.0) - p / 3.0  # real roots
  root2 = -2sqrt(Q) * cos((ψ + 2pi) / 3.0) - p / 3.0
  root3 = -2sqrt(Q) * cos((ψ - 2pi) / 3.0) - p / 3.0
  An = findroot(root1, root2, root3)
  return An
end
````

## File: rainfall_stage.jl
````julia
# - m    : [kg m-2]
# - prcp : [m m-2 s-1]
function water_change(m_water_pre, prcp, lai, Ω; kstep=360.0)
  mMax_water = 0.1 * lai
  τ = 1 - exp(-lai * Ω)
  m_water_o = m_water_pre + prcp * kstep * ρ_w * τ
  m_water_o = clamp(m_water_o, 0, mMax_water)

  Δm_water_o = max(m_water_o - m_water_pre, 0.0)
  frac_water_o = min(m_water_o / mMax_water, 1.0)
  m_water_o, frac_water_o, Δm_water_o
end

# [kg m-2] -> [m s-1]
# kg2m(p) = p / ρ_w / kstep
# m2kg(m) = m * kstep * ρ_w

# - m_water: change
function rainfall_stage1_jl(Tair::Float64, prcp::Float64,
  frac_water::Layer2{Float64}, m_water::Layer2{Float64}, m_water_pre::Layer2{Float64},
  lai_o::Float64, lai_u::Float64, Ω::Float64; kstep=360.0)
  # Ta > 0, otherwise it is snow fall
  Tair <= 0.0 && (prcp = 0.0)
  prcp_o = prcp

  # overstorey
  m_water.o, frac_water.o, Δm_water_o = water_change(m_water_pre.o, prcp_o, lai_o, Ω; kstep)
  # understorey
  prcp_u = prcp_o - Δm_water_o / ρ_w / kstep
  m_water.u, frac_water.u, Δm_water_u = water_change(m_water_pre.u, prcp_u, lai_u, Ω; kstep)

  prcp_g = prcp_u - Δm_water_u / ρ_w / kstep
  return prcp_g
end

function rainfall_stage2_jl(evapo_water_o::Float64, evapo_water_u::Float64,
  mass_water::Layer2{Float64}; kstep=360.0)

  mass_water.o = max(mass_water.o - evapo_water_o * kstep, 0.0)
  mass_water.u = max(mass_water.u - evapo_water_u * kstep, 0.0)
end
````

## File: snowpack.jl
````julia
"""
o, u积雪的变化

- kstep: 360s, [s]
- snowrate: [m s-1]，注意`snowrate`的单位
"""
function snow_change(m_snow_pre::FT, snowrate::FT, kstep::FT,
  ρ_new_snow::FT, lai::FT, Ω::FT) where {FT<:Real}

  massMax_snow = 0.1 * lai
  areaMax_snow = 0.01 * lai

  τ = (1 - exp(-lai * Ω)) # 冠层截获的部分
  m_snow = m_snow_pre + snowrate * kstep * ρ_new_snow * τ

  perc_snow = m_snow / massMax_snow
  perc_snow = clamp(perc_snow, 0, 1)
  area_snow = perc_snow * areaMax_snow

  Δm_snow = m_snow - m_snow_pre
  return m_snow, perc_snow, area_snow, Δm_snow
end

"""
  snowpack_stage1_jl

# Arguments
- `m_snow`: m_snow
- `mw`: m_water
- `z_snow`: snow depth
- `z_water`: water depth

*reference variables*
- m_snow_pre
- m_snow
- perc_snow
- area_snow

# add an example of snowpack
"""
function snowpack_stage1_jl(Tair::Float64, prcp::Float64,
  lai_o::Float64, lai_u::Float64, Ω::Float64,
  m_snow_pre::Layer3{Float64},
  m_snow::Layer3{Float64},
  frac_snow::Layer3{Float64},
  area_snow::Layer2{Float64},
  z_snow::Float64,
  ρ_snow::Ref{Float64},
  albedo_v_snow::Ref{Float64}, albedo_n_snow::Ref{Float64}; kstep=360.0)

  # m_snow_pre = Layer3(m_snow)
  massMax_snow_o = 0.1 * lai_o
  massMax_snow_u = 0.1 * lai_u

  # https://www.eoas.ubc.ca/courses/atsc113/snow/met_concepts/07-met_concepts/07b-newly-fallen-snow-density/
  ρ_new = 67.9 + 51.3 * exp(Tair / 2.6) # bug at here，新雪的密度
  # ρ_new = clamp(ρ_new, 50.0, 200.0) # 限制ρ_new的有效值域

  albedo_v_new = 0.94
  albedo_n_new = 0.8

  snowrate = Tair > 0 ? 0 : prcp * ρ_w / ρ_new

  mass2rate(Δm) = Δm / ρ_new / kstep # [kg m-2] -> [m s-1]
  cal_SnowPerc(m_snow, massMax_snow) = clamp(m_snow / massMax_snow, 0.0, 1.0)

  # kg2m 
  if Tair < 0
    snowrate_o = snowrate
    m_snow.o, frac_snow.o, area_snow.o, Δm_snow_o =
      snow_change(m_snow_pre.o, snowrate_o, kstep, ρ_new, lai_o, Ω)

    snowrate_u = max(0, snowrate_o - mass2rate(Δm_snow_o))
    m_snow.u, frac_snow.u, area_snow.u, Δm_snow_u =
      snow_change(m_snow_pre.u, snowrate_u, kstep, ρ_new, lai_u, Ω)

    snowrate_g = max(0.0, snowrate_u - mass2rate(Δm_snow_u))
    δ_zs = snowrate_g * kstep
  else
    snowrate_o = 0.0
    m_snow.o = m_snow_pre.o
    frac_snow.o = clamp(m_snow.o / massMax_snow_o, 0.0, 1.0)

    m_snow.u = m_snow_pre.u
    frac_snow.u = clamp(m_snow.u / massMax_snow_u, 0.0, 1.0)
    # area_snow.o = area_snow.o # area 不变
    # area_snow.u = area_snow.u
    δ_zs = 0.0
  end

  δ_zs = max(0.0, δ_zs)
  m_snow.g = max(0.0, m_snow_pre.g + δ_zs * ρ_new) # [kg m-2]

  if δ_zs > 0
    ρ_snow[] = (ρ_snow[] * z_snow + ρ_new * δ_zs) / (z_snow + δ_zs) # 计算混合密度
  else
    ρ_snow[] = (ρ_snow[] - 250) * exp(-0.001 * kstep / 3600.0) + 250.0
  end

  z_snow = m_snow.g > 0 ? m_snow.g / ρ_snow[] : 0.0
  frac_snow.g = min(m_snow.g / (0.05 * ρ_snow[]), 1.0) # [m]，认为雪深50cm时，perc_snow=1

  if snowrate_o > 0
    albedo_v_snow[] = (albedo_v_snow[] - 0.70) * exp(-0.005 * kstep / 3600) + 0.7
    albedo_n_snow[] = (albedo_n_snow[] - 0.42) * exp(-0.005 * kstep / 3600) + 0.42
  else
    albedo_v_snow[] = albedo_v_new
    albedo_n_snow[] = albedo_n_new
  end
  min(z_snow, 10.0) # 雪深过高，限制为10m即可
end


function snowpack_stage2_jl(evapo_snow_o::Float64, evapo_snow_u::Float64, m_snow::Layer3{Float64}; kstep=360.0)
  # kstep::Float64 = kstep  # length of step
  m_snow.o = max(0.0, m_snow.o - evapo_snow_o * kstep)
  m_snow.u = max(0.0, m_snow.u - evapo_snow_u * kstep)
end


# 热量释放用于融雪（Tsnow -> 0）
# - pos: 融化
# - neg: 冻结
function cal_melt(z_snow::T, ρ_snow::T, Tsnow::T) where {T<:Real}
  dT = Tsnow - 0
  cp_ice = 2228.261         # J Kg-1 K-1
  λ_fusion = 3.34 * 1000000 # J Kg-1
  m = z_snow * ρ_snow   # [kg m-2]
  E = m * dT * cp_ice       # 当前的雪融化，需要这么多能量，
  return E / λ_fusion       # m_ice, -> kg
end

"""
Update Snow on the ground

It is assumed sublimation happens before the melting and freezing process.

> Note: 雪过深时，只有表层的温度(z=0.02)释放。这里存在bug。应该是
> `max(zs_sup*0.02, 0.02)`，而不是2%。

## Units
- mass: [kg m-2]
- depth: [m]
"""
function snowpack_stage3_jl(Tair::Float64, Tsnow::Float64, Tsnow_last::Float64, ρ_snow::Float64,
  z_snow::Float64, z_water::Float64, m_snow::Layer3{Float64}; kstep=360.0)

  zs_sup = z_snow  # already considered sublimation
  ms_sup = m_snow.g

  Δm = cal_melt(zs_sup, ρ_snow, Tsnow) # [kg m-2]
  # con_melt = Tsnow > 0 && Tsnow_last <= 0 && ms_sup > 0
  # con_frozen = Tsnow <= 0 && Tsnow_last > 0 && z_water > 0
  con_melt = Tsnow > 0 && ms_sup > 0
  con_frozen = Tsnow <= 0 && z_water > 0

  ms_melt = 0.0
  mw_frozen = 0.0

  if zs_sup <= 0.02
    # case 1 depth of snow <0.02 m
    if Tair > 0 && zs_sup > 0
      ms_melt = min(Tair * 0.0075 * kstep / 3600 * 0.3, ms_sup)
    end
  elseif 0.02 < zs_sup <= 0.05
    # case 2 depth of snow > 0.02 < 0.05 m
    con_melt && (ms_melt = min(Δm, ms_sup))
    con_frozen && (mw_frozen = min(-Δm, z_water * ρ_w))
  elseif zs_sup > 0.05
    # _z = max(zs_sup*0.02, 0.02) # TODO: fix释放热量的深度
    # _Δm = cal_melt(_z, Tsnow)
    con_melt && (ms_melt = min(0.02Δm, ms_sup))
    con_frozen && (mw_frozen = min(-0.02Δm, z_water * ρ_w))
  end

  m_snow.g = max(0.0, m_snow.g - ms_melt + mw_frozen) # ground snow
  z_snow = max(0.0, zs_sup + (mw_frozen - ms_melt) / ρ_snow)
  z_water = max(0.0, z_water + (ms_melt - mw_frozen) / ρ_w)
  z_snow, z_water
end
````

## File: SoilPhysics/soil_water_factor_v2.jl
````julia
# Function to compute soil water stress factor
function soil_water_factor_v2(st::S, ps::P) where {S<:Union{StateBEPS,Soil},P<:Union{ParamBEPS,Soil}}
  (; ψ_min, alpha) = ps
  (; θ_sat, ψ_sat, b) = get_hydraulic(ps)

  θ = st.θ
  n = st.n_layer

  t1 = -0.02
  t2 = 2.0

  if st.ψ[1] <= 0.000001
    for i in 1:n
      st.ψ[i] = cal_ψ(θ[i], θ_sat[i], ψ_sat[i], b[i])
    end
  end

  for i in 1:n
    # psi_sr in m H2O! He 2017 JGR-B, Eq. 4
    st.f_stress[i] = st.ψ[i] > ψ_min ? 1.0 / (1 + ((st.ψ[i] - ψ_min) / ψ_min)^alpha) : 1.0
    st.f_temp[i] = st.Tsoil_p[i] > 0.0 ? 1.0 - exp(t1 * st.Tsoil_p[i]^t2) : 0

    st.f_stress[i] *= st.f_temp[i]
    st.w_root[i] = FW_VERSION == 1 ? st.f_root[i] * st.f_stress[i] : st.f_root[i]
  end

  w_root_sum = sum(st.w_root) # 每层的土壤水分限制因子

  if w_root_sum < 0.000001
    st.f_soilwater = 0.1
  else
    f_stress_sum = 0.0
    for i in 1:n
      st.w_norm[i] = st.w_root[i] / w_root_sum
      f_stress_sum += st.f_stress[i] * st.w_norm[i]
    end
    st.f_soilwater = max(0.1, f_stress_sum)
  end
end
soil_water_factor_v2(p::Soil) = soil_water_factor_v2(p, p)
````

## File: SoilPhysics/SoilPhysics.jl
````julia
export Init_Soil_Parameters, Init_Soil_T_θ!, InitState!, UpdateRootFraction, Update_Tsoil_c, Update_G
export UpdateHeatFlux, UpdateThermal_Cv,
  Update_ice_ratio,
  UpdateThermal_κ,
  soil_water_factor_v2,
  UpdateSoilMoisture, update_surface_water!, Root_Water_Uptake


get_hydraulic(ps::ParamBEPS) = ps.hydraulic
get_hydraulic(ps::Soil) = ps

get_thermal(ps::ParamBEPS) = ps.thermal
get_thermal(ps::Soil) = ps

get_root_decay(ps::ParamBEPS) = ps.veg.r_root_decay
get_root_decay(ps::Soil) = ps.r_root_decay

include("UpdateHeatFlux.jl")
include("UpdateSoilMoisture.jl")
include("soil_water_factor_v2.jl")


function Update_Tsoil_c(st::S, value::Cdouble) where {S<:Union{StateBEPS,Soil}}
  st.Tsoil_c[1] = value
end

function Update_G(st::S, value::Cdouble) where {S<:Union{StateBEPS,Soil}}
  st.G[1] = value
end

# T < -1℃, all frozen; T > 0℃, no frozen; else partially frozen
get_ice_ratio(Tsoil::FT) where {FT} = clamp(-Tsoil, FT(0), FT(1))

# 新版本：JAX 风格 (st, ps) 签名
function UpdateRootFraction!(st::S, ps::P) where {
  S<:Union{StateBEPS,Soil},P<:Union{ParamBEPS,Soil}}

  n = st.n_layer
  (; f_root, dz) = st
  β = get_root_decay(ps)

  z = zeros(n) # cumulative depth of soil layers
  z[1] = dz[1] * 100
  f_root[1] = 1 - β^(z[1])

  for i in 2:(n-1)
    z[i] = z[i-1] + dz[i] * 100
    f_root[i] = β^(z[i-1]) - β^(z[i])
  end
  f_root[n] = β^(z[n-1])
end
UpdateRootFraction!(soil::Soil) = UpdateRootFraction!(soil, soil)



# function update_state!(state::State, var_n::Vector{Float64})
#   Tsoil = state.Tsoil
#   var_n[3+1] = Tsoil[1]       # Ts0, 3
#   var_n[4+1] = Tsoil[2]       # Tsn, 4 
#   var_n[5+1] = Tsoil[3]       # Tsm0, 5
#   var_n[6+1] = Tsoil[4]       # Tsn1, 6
#   var_n[7+1] = Tsoil[5]       # Tsn1, 7

#   var_n[11+1] = state.Qhc_o   # Qhc_o, 11, sensible heat flux

#   var_n[15+1] = state.m_water.o
#   var_n[18+1] = state.m_water.u

#   var_n[16+1] = state.m_snow.o
#   var_n[19+1] = state.m_snow.u
#   var_n[20+1] = state.m_snow.g
# end
````

## File: SoilPhysics/UpdateHeatFlux.jl
````julia
# Function to update soil heat flux
function UpdateHeatFlux(st::S, Tair_annual_mean::Float64, period_in_seconds::Float64;
  fix_Tsoil::Bool=false) where {S<:Union{StateBEPS,Soil}}

  (; G, Tsoil_c, Tsoil_p, κ, dz) = st
  n = st.n_layer

  # TODO: i may have bug
  @inbounds for i in 2:n+1
    if i <= n
      G[i] = 2(Tsoil_p[i-1] - Tsoil_p[i]) / (dz[i-1] / κ[i-1] + dz[i] / κ[i])
    else
      G[i] = κ[i-1] * (Tsoil_p[i-1] - Tair_annual_mean) / (DEPTH_F + dz[i-1] * 0.5)
    end
    G[i] = clamp(G[i], -200, 200)
  end

  source = 0.0
  if !fix_Tsoil
    for i in 1:n
      Tsoil_c[i] = Tsoil_p[i] + (G[i] - G[i+1] + source) / (st.Cv[i] * dz[i]) * period_in_seconds
      Tsoil_c[i] = clamp(Tsoil_c[i], -50.0, 50.0)
    end
  end

  Update_ice_ratio(st)       # 冻融状态依赖观测温度，始终更新
  Tsoil_p[1:n] .= Tsoil_c[1:n]
end


# Function to update volume heat capacity
# Bonan 2019, Table 5.2
function UpdateThermal_Cv(st::S, ps::P) where {S<:Union{StateBEPS,Soil},P<:Union{ParamBEPS,Soil}}
  (; θ, ice_ratio) = st
  (; ρ_soil, V_SOM) = get_thermal(ps)

  for i in 1:st.n_layer
    # Chen Baozhang. (2007) Ecological Modelling 209, 277-300  (equation 18)
    term1 = 2.0e+6 * ρ_soil[i] / 2650.0 # soil solid, like Quartz
    term2 = 1.0e+6 * θ[i] * (4.2 * (1 - ice_ratio[i]) + 2.09 * ice_ratio[i]) # water and ice
    term3 = 2.5e+6 * V_SOM[i] # soil organic matter, 2.5 [MJ m-3 K-1]
    st.Cv[i] = term1 + term2 + term3 # [MJ m-3 K-1]
  end
end
UpdateThermal_Cv(p::Soil) = UpdateThermal_Cv(p, p)


# Function to update the frozen status of each soil
# 旧版本：兼容 Soil 结构体
function Update_ice_ratio(st::S) where {S<:Union{StateBEPS,Soil}}
  (; dz, θ, θ_prev, Tsoil_c, Tsoil_p, ice_ratio, Cv) = st
  Lf0 = 3.34 * 100000  # latent heat of fusion (liquid: solid) at 0C
  # 会不会这里出错了
  @inbounds for i in 1:st.n_layer
    # starting to freeze
    if Tsoil_p[i] >= 0.0 && Tsoil_c[i] < 0.0 && ice_ratio[i] < 1.0
      Gsf = (0.0 - Tsoil_c[i]) * Cv[i] * dz[i]
      ice_ratio[i] += Gsf / Lf0 / 1000.0 / (θ[i] * dz[i])
      ice_ratio[i] = min(1.0, ice_ratio[i])

      Tsoil_c[i] = 0.0
      # starting to melt
    elseif Tsoil_p[i] <= 0.0 && Tsoil_c[i] > 0.0 && ice_ratio[i] > 0.0
      Gsm = (Tsoil_c[i] - 0.0) * Cv[i] * dz[i]
      ice_ratio[i] -= Gsm / Lf0 / 1000.0 / (θ[i] * dz[i])
      ice_ratio[i] = max(0.0, ice_ratio[i])

      Tsoil_c[i] = 0.0
    end

    ice_ratio[i] *= θ_prev[i] / θ[i]
    ice_ratio[i] = min(1.0, ice_ratio[i])
  end
end


# Function to update soil thermal conductivity
@fastmath function UpdateThermal_κ(st::S, ps::P) where {
  S<:Union{StateBEPS,Soil},P<:Union{ParamBEPS,Soil}}
  (; θ, ice_ratio, κ) = st
  (; θ_sat) = get_hydraulic(ps)
  (; κ_dry) = get_thermal(ps)

  ki = 2.1  # the thermal conductivity of ice
  kw = 0.61  # the thermal conductivity of water

  @inbounds for i in 1:st.n_layer
    k_dry_i = κ_dry[i]^(1 - θ_sat[i])  # dry
    tmp2 = ki^(1.2 * θ[i] * ice_ratio[i])  # ice
    tmp3 = kw^(θ[i] * (1 - ice_ratio[i]))  # water
    tmp4 = θ[i] / θ_sat[i]  # Sr

    κ[i] = (k_dry_i * tmp2 * tmp3 - 0.15) * tmp4 + 0.15  # Note: eq. 8. LHE
    κ[i] = max(κ[i], 0.15) # juweimin05
  end
end
UpdateThermal_κ(p::Soil) = UpdateThermal_κ(p, p)
````

## File: SoilPhysics/UpdateSoilMoisture.jl
````julia
# LSM of Xuanze Zhang
# 
# Soil moisture is predicted from a 5-layer model (as with soil
# temperature), in which the vertical soil moisture transport is governed
# by infiltration, runoff, gradient diffusion, gravity, and root
# extraction through canopy transpiration.  The net water applied to the
# surface layer is the snowmelt plus precipitation plus the throughfall
# of canopy dew minus surface runoff and evaporation.
# CLM3.5 uses a zero-flow bottom boundary condition.

"""
    update_surface_water!(st, ps, kstep) -> inf

更新地表积水 `state.z_water`：处理降雨入渗和地表径流，返回入渗率 [m/s]。
与 `UpdateSoilMoisture` 共享相同物理，但不更新 θ，适用于观测土壤水模式。
"""
function update_surface_water!(st::S, ps::P, kstep::Float64) where {
  S<:Union{StateBEPS,Soil}, P<:Union{ParamBEPS,Soil}}

  n = st.n_layer
  (; θ_sat, K_sat, ψ_sat, b) = get_hydraulic(ps)
  (; θ, f_water, Tsoil_c, dz, z_water, r_rain_g) = st
  r_drainage = ps.r_drainage

  @inbounds for i in 1:n+1
    # 注意：Tsoil_c 长度通常是 n，但这里循环到 n+1，需确认 Tsoil_c 实际分配长度。
    # 假设 Tsoil_c 长度足够，或者边界处理
    # Soil struct 定义 dz 为 Vector{Float64} = zeros(10)，所以可以到 n+1 (5+1=6)
    val_T = i <= length(Tsoil_c) ? Tsoil_c[i] : Tsoil_c[end] # 简单边界保护
    if val_T > 0.0
      f_water[i] = 1.0
    elseif val_T < -1.0
      f_water[i] = 0.1
    else
      f_water[i] = 0.1 + 0.9 * (val_T + 1.0)
    end
  end

  # Max infiltration calculation
  # K_sat * (1 + (θ_sat - θ_prev) / dz * ψ_sat / θ_sat * b)
  inf_max = f_water[1] * K_sat[1] * (1 + (θ_sat[1] - θ[1]) / dz[1] * ψ_sat[1] * b[1] / θ_sat[1])
  inf = max(f_water[1] * (z_water / kstep + r_rain_g), 0)
  inf = clamp(inf, 0, inf_max)

  # Ponded water after runoff
  st.z_water = (z_water / kstep + r_rain_g - inf) * kstep * r_drainage
  return inf
end


# 旧版本：兼容 Soil 结构体
UpdateSoilMoisture(soil::Soil, kstep::Float64) = UpdateSoilMoisture(soil, soil, kstep)

# 新版本：JAX 风格 (st, ps) 签名
function UpdateSoilMoisture(st::S, ps::P, kstep::Float64; fix_sm::Bool=false) where {
  S<:Union{StateBEPS,Soil},P<:Union{ParamBEPS,Soil}}

  n = st.n_layer
  (; θ_sat, K_sat, ψ_sat, b, θ_vwp) = get_hydraulic(ps)
  (; dz, f_water, Kavg, Kmid, ψ, θ, θ_prev, ETi, r_waterflow, ice_ratio) = st

  θ_prev .= θ
  inf = update_surface_water!(st, ps, kstep)
  fix_sm && return # 如果 fix_sm=true，则只更新地表积水，不改变土壤水分状态

  total_t, max_Fb = 0.0, 0.0
  @inbounds while total_t < kstep
    # 为了解决相互依赖的关系，循环寻找稳态
    # the unsaturated soil water retention. LHe
    # Hydraulic conductivity: Bonan, Table 8.2, Campbell 1974, K = K_sat*(θ/θ_sat)^(2b+3)
    for i in 1:n
      ψ[i] = cal_ψ(θ[i], θ_sat[i], ψ_sat[i], b[i])
      Kmid[i] = f_water[i] * cal_K(θ[i], θ_sat[i], K_sat[i], b[i]) # Hydraulic conductivity, [m/s]
    end

    # Fb, flow speed. Dancy's law. LHE.
    # check the r_waterflow further. LHE
    for i in 1:n-1
      # 不同层土壤深度不同，能否这样写？
      # K * ψ * b / (b + 3): ?
      # the unsaturated hydraulic conductivity of soil layer
      Kavg[i] = (Kmid[i] * ψ[i] + Kmid[i+1] * ψ[i+1]) / (ψ[i] + ψ[i+1]) * (b[i] + b[i+1]) / (b[i] + b[i+1] + 6) # 计算平均的一种方案？
      Q = Kavg[i] * (2 * (ψ[i+1] - ψ[i]) / (dz[i] + dz[i+1]) + 1) # z direction
      # `Q_max`出现了单位不匹配的问题，导致Q_max未发挥作用
      Q_max = (θ_sat[i+1] - θ[i+1]) * dz[i+1] / kstep + ETi[i+1]
      Q = min(Q, Q_max)

      r_waterflow[i] = Q
      max_Fb = max(max_Fb, abs(Q))
    end
    # p.r_waterflow[n] = 0

    Δt = guess_step(max_Fb) # this_step
    total_t += Δt
    total_t > kstep && (Δt -= (total_t - kstep))

    # from there: kstep is replaced by this_step. LHE
    for i in 1:n
      if i == 1
        θ[i] += (inf - r_waterflow[i] - ETi[i]) * Δt / dz[i]
      else
        θ[i] += (r_waterflow[i-1] - r_waterflow[i] - ETi[i]) * Δt / dz[i]
      end
      θ[i] = clamp(θ[i], θ_vwp[i], θ_sat[i])
    end
  end

  for i in 1:n
    ice_ratio[i] *= θ_prev[i] / θ[i]
    ice_ratio[i] = min(1.0, ice_ratio[i])
  end
end


# Campbell 1974, Bonan 2019 Table 8.2
@fastmath function cal_ψ(θ::T, θ_sat::T, ψ_sat::T, b::T) where {T<:Real}
  ψ = ψ_sat * (θ / θ_sat)^(-b)
  max(ψ, ψ_sat)
end

@fastmath cal_K(θ::T, θ_sat::T, K_sat::T, b::T) where {T<:Real} =
  K_sat * (θ / θ_sat)^(2 * b + 3)

"""
[m s-1] -> 1000*[mm s-1] -> 1000*[kg m-2 s-1]
"""
# 如果流速过快，则减小时间步长
function guess_step(max_Fb)
  # this constraint is too large
  if max_Fb > 1.0e-5 # 864 mm/day
    Δt = 1.0
  elseif max_Fb > 1.0e-6 # 86.4 mm/day
    Δt = 30.0 # seconds
  else
    Δt = 360.0
  end
  Δt
end

# Function to calculate soil water uptake from a layer
"""
    Root Water Uptake

- `土壤蒸发`：仅发生在表层
- `植被蒸腾`：根据根系分布，耗水可能来自于土壤的每一层
"""
function Root_Water_Uptake(st::S, Trans_o::Float64, Trans_u::Float64, Evap_soil::Float64) where {
  S<:Union{StateBEPS,Soil}}

  Trans = Trans_o + Trans_u
  st.ETi[1] = Trans / ρ_w * st.w_norm[1] + Evap_soil / ρ_w
  for i in 2:st.n_layer
    st.ETi[i] = Trans / ρ_w * st.w_norm[i]
  end
end
````

## File: SPAC/BEPS_helper.jl
````julia
## BEPS modules
function update_Gw!(Gw::Leaf, Gs_new::Leaf, Ga_o, Ga_u, Gb_o, Gb_u)
  Gw.o_sunlit = 1.0 / (1.0 / Ga_o + 1.0 / Gb_o + 1.0 / Gs_new.o_sunlit)  #conductance for water
  Gw.o_shaded = 1.0 / (1.0 / Ga_o + 1.0 / Gb_o + 1.0 / Gs_new.o_shaded)
  Gw.u_sunlit = 1.0 / (1.0 / Ga_u + 1.0 / Gb_u + 1.0 / Gs_new.u_sunlit)
  Gw.u_shaded = 1.0 / (1.0 / Ga_u + 1.0 / Gb_u + 1.0 / Gs_new.u_shaded)
end

function update_Gc!(Gc::Leaf, Gs_new::Leaf, Ga_o, Ga_u, Gb_o, Gb_u)
  Gc.o_sunlit = 1.0 / (1.0 / Ga_o + 1.4 / Gb_o + 1.6 / Gs_new.o_sunlit) # conductance for CO2
  Gc.o_shaded = 1.0 / (1.0 / Ga_o + 1.4 / Gb_o + 1.6 / Gs_new.o_shaded)
  Gc.u_sunlit = 1.0 / (1.0 / Ga_u + 1.4 / Gb_u + 1.6 / Gs_new.u_sunlit)
  Gc.u_shaded = 1.0 / (1.0 / Ga_u + 1.4 / Gb_u + 1.6 / Gs_new.u_shaded)
end
````

## File: SPAC/helper.jl
````julia
# pow = ^
# pow(x::FT, y)::FT where {FT<:Real} = x^y
pow(x, y) = x^y

function blackbody(T::FT) where {FT<:Real}
  σ = 5.67 / 100000000    # stephen-boltzman constant
  σ * (T + 273.15)^4
end

function cal_Rln(emiss::FT, T::FT) where {FT<:Real}
  emiss * blackbody(T)
end

# kPa deg-1
function cal_slope(Ta::FT)::FT where {FT<:Real}
  2503.0 / pow((Ta + 237.3), 2) * exp(17.27 * Ta / (Ta + 237.3))
end

# kPa
function cal_es(Ta::FT)::FT where {FT<:Real} 
  0.61078 * exp(17.3 * Ta / (237.3 + Ta))
end

function cal_ea(Ta::FT, RH::FT)::FT where {FT<:Real}
  cal_es(Ta) * RH / 100
end

function cal_lambda(Ta::FT)::FT where {FT<:Real} 
  (2.501 - 0.00237 * Ta) * 1000000
end

function ea2q(ea::FT, Pa::FT=101.35)::FT where {FT<:Real} 
  0.622 * ea / (Pa - 0.378 * ea)
end

function RH2q(Ta::FT, RH::FT)::FT where {FT<:Real}
  es = cal_es(Ta)
  ea = es * RH / 100
  ea2q(ea)
end

"""
# Arguments
- `q`  : specific humidity, g / kg
- `tem`: air temperature, ℃
"""
function q2RH(q::FT, tem::FT)::FT where {FT<:Real}
  # Vapour pressure in mbar
  ea = 0.46 * q * (tem + 273.16) / 100
  es = 6.1078 * exp((17.269 * tem) / (237.3 + tem))
  clamp(ea / es * 100, 0.0, 100.0)
end


function cal_cp(q::FT)::FT where {FT<:Real} 
  1004.65 * (1 + 0.84 * q)
end

function cal_cp(Ta::FT, RH::FT)::FT where {FT<:Real}
  q = RH2q(Ta, RH)
  cal_cp(q)
end

export pow, cal_ea, cal_es,
  cal_slope, cal_lambda, cal_cp, ea2q, RH2q, q2RH,
  cal_Rln,
  blackbody
````

## File: SPAC/lai2.jl
````julia
function lai2!(Ω::Float64, CosZs::Float64,
  stem_o::Float64, stem_u::Float64,
  lai_o::Float64, lai_u::Float64,
  LAI::Leaf, PAI::Leaf)

  PAI.o_sunlit = CosZs > 0 ? 2 * CosZs * (1 - exp(-0.5 * Ω * (lai_o + stem_o) / CosZs)) : 0
  PAI.o_shaded = (lai_o + stem_o) - PAI.o_sunlit

  PAI.u_sunlit = CosZs > 0 ? 2 * CosZs * (1 - exp(-0.5 * Ω * (lai_o + stem_o + lai_u + stem_u) / CosZs)) - PAI.o_sunlit : 0
  PAI.u_shaded = (lai_u + stem_u) - PAI.u_sunlit

  LAI.o_sunlit = CosZs > 0 ? 2 * CosZs * (1 - exp(-0.5 * Ω * lai_o / CosZs)) : 0
  LAI.o_shaded = max(0, lai_o - LAI.o_sunlit)  # edited by J. Leng

  LAI.u_sunlit = CosZs > 0 ? 2 * CosZs * (1 - exp(-0.5 * Ω * (lai_o + lai_u) / CosZs)) - LAI.o_sunlit : 0
  LAI.u_shaded = max(0, lai_u - LAI.u_sunlit)  # edited by J. Leng
end

function lai2(Ω::Float64, CosZs::Float64,
  stem_o::Float64, stem_u::Float64,
  lai_o::Float64, lai_u::Float64)

  LAI = Leaf()
  PAI = Leaf()
  lai2!(Ω, CosZs, stem_o, stem_u, lai_o, lai_u, LAI, PAI)
  LAI, PAI
end


function partition_lai(lai, Ω, CosZs)
  sunlit = CosZs > 0 ? 2 * CosZs * (1 - exp(-0.5 * Ω * lai / CosZs)) : 0
  shaded = max(0, lai - sunlit)
  sunlit, shaded
end
````

## File: SPAC/Leaf.jl
````julia
# TODO: 可用StaticArrays改进
# they also abstract vector but with name
@with_kw mutable struct Leaf <: FieldVector{4,Cdouble}
  o_sunlit::Cdouble = 0.0
  o_shaded::Cdouble = 0.0
  u_sunlit::Cdouble = 0.0
  u_shaded::Cdouble = 0.0
end

Leaf(x::Cdouble) = Leaf(x,x,x,x)
Leaf(o::Cdouble, u::Cdouble) = Leaf(o, u)

function init_leaf_dbl2(x::Leaf, overstory, understory)
  x.o_sunlit = overstory
  x.o_shaded = overstory
  x.u_sunlit = understory
  x.u_shaded = understory
end

function multiply!(Z::Leaf, X::Leaf, Y::Leaf)
  Z.o_sunlit = X.o_sunlit * Y.o_sunlit
  Z.o_shaded = X.o_shaded * Y.o_shaded
  Z.u_sunlit = X.u_sunlit * Y.u_sunlit
  Z.u_shaded = X.u_shaded * Y.u_shaded
end
````

## File: SPAC/snow_density.jl
````julia
# LoTmpDnsTruncatedAnderson1976
"""
    snow_density(Ta::Float64, U10::Float64=NaN; tfrz=0.0, method="LoTmpDnsSlater2017")

Calculate the density of new snow [`kg m⁻³`] based on temperature and wind
speed. Snow compacts over time, range from 100–500 [`kg m⁻³`].

"Snow fraction depends on the density of snow in CLM4. A 10 cm snowpack has
f_snow=1 when density is low (50–100 kg m–3), such as may be found in fresh
snow, and a smaller snow fraction (f_snow = 0.76) when density is high (400 kg
m–3)" -- Bonan 2019, P148

# Reference

- van Kampenhout et al. 2017

- CLM5,
  <https://github.com/ESCOMP/CTSM/blob/07051e3758addf2f9753d520823be9ebcbfec0aa/src/biogeophys/SnowHydrologyMod.F90#L3729-L3747>

# Examples
```julia
Ta = -50.:50
ρ_snow = snow_density.(Ta, 2.0)
ρ_snow_chen = @. 67.9 + 51.3 * exp(Ta / 2.6)

# using Plots
# plot(Ta, ρ_snow)
# plot!(Ta, ρ_snow_chen)
```
"""
function snow_density(Ta::Float64, U10::Float64=NaN; tfrz=0.0, method="LoTmpDnsSlater2017")
  if Ta > tfrz + 2.0
    ρ_snow = 50.0 + 1.7 * (17.0)^1.5
  elseif Ta > tfrz - 15.0
    ρ_snow = 50.0 + 1.7 * (Ta - tfrz + 15.0)^1.5
  else
    if method == "LoTmpDnsTruncatedAnderson1976"
      ρ_snow = 50.0
    elseif method == "LoTmpDnsSlater2017"
      # ρ_snow = -3.833 * (Ta - tfrz) - 0.0333 * (Ta - tfrz)^2
      t_for_bifall_degC = Ta > tfrz - 57.55 ? (Ta - tfrz) : -57.55
      ρ_snow = -(50.0 / 15.0 + 0.0333 * 15.0) * t_for_bifall_degC - 0.0333 * t_for_bifall_degC^2
    end
  end

  if U10 > 0.1
    ρ_snow = ρ_snow + (266.861 * ((1.0 + tanh(U10 / 2)) / 2.0)^8.8)
  end
  ρ_snow
end
````

## File: SPAC/SPAC.jl
````julia
using DocStringExtensions: TYPEDFIELDS
import DataFrames: DataFrame

# include("../SPAC/SPAC.jl")

export s_coszs, lai2, VCmax
export meteo_pack_jl
export snow_density

include("Leaf.jl")
include("ultilize.jl")
include("lai2.jl")
include("VCmax.jl")
include("snow_density.jl")
include("helper.jl")
include("BEPS_helper.jl")

"""
    s_coszs(jday::Int, j::Int, lat::Float64, lon::Float64)

# Example
```julia
jday, hour, lat, lon = 20, 12, 20., 120.
s_coszs(jday, hour, lat, lon)
```
"""
function s_coszs(jday::Int, hour::Int, lat::Float64, lon::Float64)
  Delta = 0.006918 - 0.399912 * cos(jday * 2π / 365.0) + 0.070257 * sin(jday * 2π / 365.0) -
          0.006758 * cos(jday * 4π / 365.0) + 0.000907 * sin(jday * 4π / 365.0)
  # delta is the declination angle of sun.

  hr = hour + lon / 15.0  # UTC time
  # hr =j*24.0/RTIMES; # local time
  hr > 24 && (hr = hr - 24)
  hr < 0 && (hr = 24 + hr)

  Lat_arc = π * lat / 180.0
  Hsolar1 = (hr - 12.0) * 2.0 * π / 24.0 # local hour angle in arc.

  # sin(h)
  CosZs = cos(Delta) * cos(Lat_arc) * cos(Hsolar1) + sin(Delta) * sin(Lat_arc)
  return CosZs
end

function meteo_pack_jl(Ta::FT, RH::FT) where {FT<:Real}
  ρₐ::FT = 1.292 # ρ_air, kg/m3
  es::FT = cal_es(Ta)
  ea::FT = es * RH / 100
  VPD::FT = es - ea

  q::FT = ea2q(ea)
  cp::FT = cal_cp(q)

  λ::FT = cal_lambda(Ta)
  Δ::FT = cal_slope(Ta) # slope of es
  γ::FT = 0.066         # kPa/K,
  # λ = cal_lambda(Ta) # J kg-1
  # psy = cp * 101.13 / (0.622 * λ)
  (; ρₐ, cp, VPD, λ, Δ, γ, es, ea, q)
end
````

## File: SPAC/ultilize.jl
````julia
import DataFrames: AbstractDataFrame

function Base.sum(df::AbstractDataFrame)
  vals = [sum(df[!, c]) for c in names(df)]
  keys = names(df)
  NamedTuple{Tuple(Symbol.(keys))}(vals)
end


# for test
function nanmaximum(x::AbstractVector)
  inds = .!isnan.(x) |> findall
  !isempty(inds) ? maximum(x[inds]) : NaN
end

function Base.maximum(df::AbstractDataFrame)
  vals = [nanmaximum(df[!, c]) for c in names(df)]
  keys = names(df)
  NamedTuple{Tuple(Symbol.(keys))}(vals)
end

function _nanmaximum(x)
  x = collect(x)
  x = x[.!isnan.(x)]
  maximum(x)
end

export _nanmaximum

# import CSV
# fread(f) = DataFrame(CSV.File(f))
# fwrite(df, file) = begin
#   # dirname(file) |> check_dir
#   CSV.write(file, df)
# end
# export fread, fwrite


## export LVector, list, LA

# import LabelledArrays
# import LabelledArrays: LVector, LArray, symnames
# using DataFrames

# const LA = LabelledArrays
# LA.LVector(keys::Vector{Symbol}, values) = LVector(; zip(keys, values)...)
# LA.LVector(keys::Vector{<:AbstractString}, values) = LVector(; zip(Symbol.(keys), values)...)
# LA.LVector(keys::Tuple, values) = LVector(; zip(keys, values)...)

# LA.LVector(keys::Vector{Symbol}) = LVector(keys, zeros(length(keys)))
# LA.LVector(keys::Vector{<:AbstractString}) = LVector(Symbol.(keys), zeros(length(keys)))
# LA.LVector(keys::Tuple) = LVector(keys, zeros(length(keys)))

# list = LVector;
# Base.names(x::LArray) = symnames(typeof(x))
````

## File: SPAC/VCmax.jl
````julia
# VCmax-Nitrogen calculations
# 
# VCmax25 = 62.5          # maximum capacity of Rubisco at 25C-VCmax	
# N_leaf = 3.10 + 1.35    # leaf Nitrogen content	mean value + 1 SD g/m2 
# slope = 20.72 / 62.5       # slope of VCmax-N curve
function VCmax(lai::FT, Ω::FT, CosZs::FT, VCmax25::FT, N_leaf::FT, χ::FT) where {FT<:Real}
  CosZs <= 0 && return 0.0, 0.0 # 光合仅发生在白天
  K = 0.5 * Ω / CosZs # assuming a spherical leaf angle distribution
  Kn = 0.3            # 0.713/2.4

  expr1 = 1 - exp(-K * lai)
  expr2 = 1 - exp(-lai * (Kn + K))
  expr3 = 1 - exp(-Kn * lai)

  # Formulas based on Chen et al., 2012, GBC
  if (expr1 > 0)
    VCmax_sunlit = VCmax25 * χ * N_leaf * K * expr2 / (Kn + K) / expr1
  else
    VCmax_sunlit = VCmax25
  end

  if (K > 0 && lai > expr1 / K)
    VCmax_shaded = VCmax25 * χ * N_leaf *
                   (expr3 / Kn - expr2 / (Kn + K)) / (lai - expr1 / K)
  else
    VCmax_shaded = VCmax25
  end
  VCmax_sunlit, VCmax_shaded
end
````

## File: standalone/Photosynthesis/core.jl
````julia
using UnPack

"""
    farquhar_model(T::FT, PAR::FT, ci::FT, params::ParamPhoto_Farquhar{FT}) where {FT<:AbstractFloat}

单叶片 Farquhar 光合作用模型

# Arguments
- `T`: 叶片温度 [K]
- `PAR`: 光合有效辐射 [μmol m-2 s-1]
- `ci`: 胞间 CO2 浓度 [μmol mol-1]
- `params`: 光合作用参数

# Returns
- `An`: 净光合速率 [μmol m-2 s-1]
- `Rd`: 暗呼吸速率 [μmol m-2 s-1]

# References
- Farquhar et al., 1980
"""
function farquhar_model(T::FT, PAR::FT, ci::FT, params) where {FT<:AbstractFloat}
  @unpack Vcmax25, Jmax25, Rd25_ratio, Rd_light_factor,
  evc, ejm, erd, toptvc, toptjm,
  kc25, ko25, tau25, qalpha, theta2 = params

  # 1. 温度调整
  Vcmax = fTv(T, Vcmax25, evc, toptvc)
  Jmax = fTj(T, Jmax25, ejm, toptjm)
  Rd25 = Rd25_ratio * Vcmax25
  Rd = fTd(T, Rd25, erd)

  # 2. Michaelis-Menten 常数
  Kc = kc25 * TBOLTZ(T, FT(80500.0))
  Ko = ko25 * TBOLTZ(T, FT(14500.0))
  tau = tau25 * TBOLTZ(T, FT(-29000.0))

  # 3. Rubisco 限制速率
  # Wc = Vcmax * (ci - Γ*) / (ci + Kc * (1 + O2/Ko))
  # Γ* = 0.5 * O2 / tau，O2 = 210 mmol/mol = 210000 μmol/mol
  # 故 0.5 * 210000 = 105000
  Γstar = FT(105000.0) / tau  # CO2 补偿点 [μmol mol-1]
  Wc = Vcmax * (ci - Γstar) / (ci + Kc * (1.0 + 210.0 / Ko))

  # 4. 光限制速率
  # J = (αI + Jmax - sqrt((αI + Jmax)^2 - 4θαIJmax)) / 2θ
  alpha = qalpha
  I2 = alpha * PAR
  J = (I2 + Jmax - sqrt((I2 + Jmax)^2 - 4.0 * theta2 * I2 * Jmax)) / (2.0 * theta2)
  Wj = J * (ci - Γstar) / (4.0 * ci + 8.0 * Γstar)

  # 5. TPU 限制: Wp = 3 * TPU ≈ 0.5 * Vcmax (TPU ≈ Vcmax/6)
  Wp = FT(0.5) * Vcmax

  # 6. 净光合速率
  Ac = min(Wc, Wj, Wp)
  An = Ac - Rd

  return An, Rd
end
````

## File: standalone/Photosynthesis/helper.jl
````julia
"""
    cal_rho_a(Tair::FT, ea::FT) where {FT<:AbstractFloat}

计算空气密度

# Arguments
- `Tair`: 气温 [°C]
- `ea`: 水汽压 [kPa]

# Returns
- 空气密度 [kg m-3]

# References
- Campbell & Norman, 1998
"""
@fastmath function cal_rho_a(Tair::FT, ea::FT) where {FT<:AbstractFloat}
  P = FT(101.3)  # [kPa] 大气压
  Rd = FT(287.0) # [J kg-1 K-1] 干空气气体常数
  T = Tair + FT(273.15)  # 转换为开尔文
  
  return P * FT(1000.0) / (Rd * T) * (1.0 - FT(0.378) * ea / P)
end

"""
    ES(T::FT) where {FT<:AbstractFloat}

计算饱和水汽压（Magnus 公式）

# Arguments
- `T`: 温度 [°C]

# Returns
- 饱和水汽压 [kPa]
"""
@fastmath function ES(T::FT) where {FT<:AbstractFloat}
  return FT(0.6108) * exp(FT(17.27) * T / (T + FT(237.3)))
end

"""
    cal_ea(Tair::FT, RH::FT) where {FT<:AbstractFloat}

计算实际水汽压

# Arguments
- `Tair`: 气温 [°C]
- `RH`: 相对湿度 [%]

# Returns
- 水汽压 [kPa]
"""
@fastmath function cal_ea(Tair::FT, RH::FT) where {FT<:AbstractFloat}
  return ES(Tair) * RH / FT(100.0)
end
````

## File: standalone/Photosynthesis/photosynthesis.jl
````julia
module Photosynthesis

using UnPack
using Parameters
# ParamPhoto_Farquhar 将在 BEPS 模块中定义

# 导入类型
include("types.jl")

# 导入子模块
include("helper.jl")
include("temperature.jl")
include("radiation.jl")
include("stomatal.jl")
include("core.jl")

# 导出公共 API
export LeafPhoto, PhotoResult
export photosynthesis

"""
    photosynthesis(Tair::FT, RH::FT, Srad::FT, LAI::FT, 
                   params; 
                   ca::FT=380.0, 
                   β_soil::FT=1.0,
                   gb_w::FT=0.01) where {FT<:AbstractFloat}

简化的光合作用模型（假设 T_leaf = T_air）

# Arguments
- `Tair`: 气温 [°C]
- `RH`: 相对湿度 [%]
- `Srad`: 短波辐射 [W m-2]
- `LAI`: 叶面积指数
- `params`: 光合作用参数（ParamPhoto_Farquhar）
- `ca`: 大气 CO2 浓度 [μmol mol-1] (默认 380)
- `β_soil`: 土壤水分胁迫因子 [0-1] (默认 1.0，无胁迫)
- `gb_w`: 边界层导度 [mol m-2 s-1] (默认 0.5，典型叶片值)

# Returns
- `PhotoResult`: 包含 An, Gs, Ci, Gc, Rd

# Examples
```julia
using BEPS

params = InitParam_Photo_Farquhar()
result = photosynthesis(25.0, 60.0, 500.0, 2.0, params)
println("阳生叶片 An: ", result.An.sunlit, " μmol m-2 s-1")
```

# References
- Farquhar et al., 1980
- Ball et al., 1987
- Chen et al., 2007
"""
function photosynthesis(Tair::FT, RH::FT, Srad::FT, LAI::FT,
                       params;
                       ca::FT=FT(380.0),
                       β_soil::FT=FT(1.0),
                       gb_w::FT=FT(0.5)) where {FT<:AbstractFloat}
  # 计算气象变量
  ea = cal_ea(Tair, RH)
  rho_a = cal_rho_a(Tair, ea)
  T = Tair + FT(273.15)
  
  # LAI 分配到阳生/阴生叶片
  LAI_sunlit, LAI_shaded = lai2!(LAI, params.clumping)
  
  # 计算叶片吸收的 PAR
  PAR_sunlit = calc_PAR_leaf(Srad, FT(0.0))
  PAR_shaded = calc_PAR_leaf(Srad, LAI_sunlit)
  
  result = PhotoResult{FT}()
  
  # 迭代求解阳生叶片
  MAX_ITERATIONS = 15
  CONVERGENCE_THRESHOLD = FT(1.0)
  
  ci = ca * FT(0.7)
  An = FT(0.0)
  Rd = FT(0.0)
  gs = FT(0.0)
  gc = FT(0.0)
  
  for iter in 1:MAX_ITERATIONS
    An, Rd = farquhar_model(T, PAR_sunlit, ci, params)
    An = An * β_soil
    cs = ca
    gs = ball_berry_gs(max(An, 0.0), RH / FT(100.0), cs, params)
    gc = update_Gc(gs, gb_w)
    ci_new = ca - An / gc
    
    if abs(ci_new - ci) < CONVERGENCE_THRESHOLD
      ci = ci_new
      break
    end
    ci = ci_new
  end
  
  result.An.sunlit = An
  result.Gs.sunlit = gs
  result.Ci.sunlit = ci
  result.Rd.sunlit = Rd
  result.Gc.sunlit = gc
  
  # 迭代求解阴生叶片
  ci = ca * FT(0.7)
  An = FT(0.0)
  Rd = FT(0.0)
  gs = FT(0.0)
  gc = FT(0.0)
  
  for iter in 1:MAX_ITERATIONS
    An, Rd = farquhar_model(T, PAR_shaded, ci, params)
    An = An * β_soil
    cs = ca
    gs = ball_berry_gs(max(An, 0.0), RH / FT(100.0), cs, params)
    gc = update_Gc(gs, gb_w)
    ci_new = ca - An / gc
    
    if abs(ci_new - ci) < CONVERGENCE_THRESHOLD
      ci = ci_new
      break
    end
    ci = ci_new
  end
  
  result.An.shaded = An
  result.Gs.shaded = gs
  result.Ci.shaded = ci
  result.Rd.shaded = Rd
  result.Gc.shaded = gc
  
  return result
end

end # module
````

## File: standalone/Photosynthesis/radiation.jl
````julia
"""
    lai2!(LAI::FT, clumping::FT) where {FT<:AbstractFloat}

计算阳生和阴生叶片 LAI

# Arguments
- `LAI`: 总叶面积指数
- `clumping`: 叶片聚集指数

# Returns
- `LAI_sunlit`: 阳生叶片 LAI
- `LAI_shaded`: 阴生叶片 LAI

# References
- Chen et al., 2007
"""
@fastmath function lai2!(LAI::FT, clumping::FT) where {FT<:AbstractFloat}
  # 消光系数
  k = FT(0.5) / clumping
  
  # 阳生叶片 LAI
  LAI_sunlit = (1.0 - exp(-k * LAI)) / k
  
  # 阴生叶片 LAI
  LAI_shaded = LAI - LAI_sunlit
  
  return LAI_sunlit, LAI_shaded
end

"""
    calc_PAR_leaf(Srad::FT, LAI_layer::FT, k::FT=0.5) where {FT<:AbstractFloat}

计算叶片吸收的 PAR

# Arguments
- `Srad`: 入射短波辐射 [W m-2]
- `LAI_layer`: 累积 LAI 到该层
- `k`: 消光系数（默认 0.5）

# Returns
- `PAR`: 光合有效辐射 [μmol m-2 s-1]

# Notes
- 假设 PAR 占短波辐射的 50%
- 转换系数: 1 W m-2 ≈ 4.6 μmol m-2 s-1
"""
@fastmath function calc_PAR_leaf(Srad::FT, LAI_layer::FT, k::FT=FT(0.5)) where {FT<:AbstractFloat}
  # PAR 占短波辐射的 50%
  PAR_total = FT(0.5) * Srad * FT(4.6)  # [μmol m-2 s-1]
  
  # 该层吸收的 PAR（简化）
  PAR_leaf = PAR_total * exp(-k * LAI_layer)
  
  return PAR_leaf
end
````

## File: standalone/Photosynthesis/stomatal.jl
````julia
using UnPack

"""
    ball_berry_gs(An::FT, RH::FT, cs::FT, params::ParamPhoto_Farquhar{FT}) where {FT<:AbstractFloat}

Ball-Berry 气孔导度模型

# Arguments
- `An`: 净光合速率 [μmol m-2 s-1]
- `RH`: 相对湿度 [0-1]
- `cs`: 叶表面 CO2 浓度 [μmol mol-1]
- `params`: 光合作用参数

# Returns
- `Gs`: 气孔导度 [mol m-2 s-1]

# References
- Ball et al., 1987
"""
@fastmath function ball_berry_gs(An::FT, RH::FT, cs::FT, params) where {FT<:AbstractFloat}
  @unpack g0_w, g1_w = params
  
  # Ball-Berry 模型: gs = g0 + g1 * An * hs / cs
  hs = RH  # 相对湿度
  gs = g0_w + g1_w * An * hs / cs
  
  return max(gs, g0_w)  # 确保不低于最小值
end

"""
    update_Gc(Gs::FT, gb_w::FT) where {FT<:AbstractFloat}

计算 CO2 总导度

# Arguments
- `Gs`: 气孔导度 [mol m-2 s-1]
- `gb_w`: 边界层导度 [mol m-2 s-1]

# Returns
- `Gc`: CO2 总导度 [mol m-2 s-1]

# Notes
- 1.4 是 CO2 与水汽的扩散系数比
- 1.37 是边界层扩散系数比
"""
@fastmath function update_Gc(Gs::FT, gb_w::FT) where {FT<:AbstractFloat}
  return 1.0 / (1.4 / Gs + 1.37 / gb_w)
end
````

## File: standalone/Photosynthesis/temperature.jl
````julia
"""
    TBOLTZ(T::FT, E::FT) where {FT<:AbstractFloat}

温度响应函数（Arrhenius 方程）

# Arguments
- `T`: 温度 [K]
- `E`: 活化能 [J mol-1]

# Returns
- 温度响应因子 [0-1]

# References
- Campbell & Norman, 1998
"""
@fastmath function TBOLTZ(T::FT, E::FT) where {FT<:AbstractFloat}
  rugc = FT(8.314)  # [J mol-1 K-1] 通用气体常数
  TK25 = FT(298.16) # [K] 25°C
  return exp((T - TK25) * E / (T * TK25 * rugc))
end

"""
    fTv(T::FT, Vcmax25::FT, evc::FT, toptvc::FT) where {FT<:AbstractFloat}

Vcmax 的温度响应（Medlyn et al. 2002 归一化峰值 Arrhenius）

# Arguments
- `T`: 叶片温度 [K]
- `Vcmax25`: 25°C 时的最大羧化速率 [μmol m-2 s-1]
- `evc`: 活化能 [J mol-1]
- `toptvc`: 最适温度 [K]（当前实现未使用，保留以保持 API 兼容性；
  去活化由固定参数 Hd=200000 J/mol, S=640 J/mol/K 控制）

# Returns
- 温度调整后的 Vcmax [μmol m-2 s-1]，在 25°C 归一化为 Vcmax25

# References
- Medlyn et al., 2002, Plant Cell Environ.
"""
@fastmath function fTv(T::FT, Vcmax25::FT, evc::FT, toptvc::FT) where {FT<:AbstractFloat}
  rugc = FT(8.314)
  TK25 = FT(298.15)
  Hd   = FT(200000.0)  # 去活化焓 [J mol-1]
  S    = FT(640.0)     # 熵项 [J mol-1 K-1]

  f_temp  = TBOLTZ(T, evc)
  num = FT(1.0) + exp((S * TK25 - Hd) / (TK25 * rugc))  # 25°C 归一化因子
  den = FT(1.0) + exp((S * T - Hd) / (T * rugc))          # 当前温度去活化
  return Vcmax25 * f_temp * num / den
end

"""
    fTj(T::FT, Jmax25::FT, ejm::FT, toptjm::FT) where {FT<:AbstractFloat}

Jmax 的温度响应（Medlyn et al. 2002 归一化峰值 Arrhenius）

# Arguments
- `T`: 叶片温度 [K]
- `Jmax25`: 25°C 时的最大电子传递速率 [μmol m-2 s-1]
- `ejm`: 活化能 [J mol-1]
- `toptjm`: 最适温度 [K]（当前实现未使用，保留以保持 API 兼容性；
  去活化由固定参数 Hd=200000 J/mol, S=640 J/mol/K 控制）

# Returns
- 温度调整后的 Jmax [μmol m-2 s-1]，在 25°C 归一化为 Jmax25

# References
- Medlyn et al., 2002, Plant Cell Environ.
"""
@fastmath function fTj(T::FT, Jmax25::FT, ejm::FT, toptjm::FT) where {FT<:AbstractFloat}
  rugc = FT(8.314)
  TK25 = FT(298.15)
  Hd   = FT(200000.0)  # 去活化焓 [J mol-1]
  S    = FT(640.0)     # 熵项 [J mol-1 K-1]

  f_temp  = TBOLTZ(T, ejm)
  num = FT(1.0) + exp((S * TK25 - Hd) / (TK25 * rugc))  # 25°C 归一化因子
  den = FT(1.0) + exp((S * T - Hd) / (T * rugc))          # 当前温度去活化
  return Jmax25 * f_temp * num / den
end

"""
    fTd(T::FT, Rd25::FT, erd::FT) where {FT<:AbstractFloat}

暗呼吸的温度响应

# Arguments
- `T`: 叶片温度 [K]
- `Rd25`: 25°C 时的暗呼吸速率 [μmol m-2 s-1]
- `erd`: 活化能 [J mol-1]

# Returns
- 温度调整后的 Rd [μmol m-2 s-1]
"""
@fastmath function fTd(T::FT, Rd25::FT, erd::FT) where {FT<:AbstractFloat}
  return Rd25 * TBOLTZ(T, erd)
end
````

## File: standalone/Photosynthesis/types.jl
````julia
using Parameters

"""
    LeafPhoto{FT}

简化的叶片光合作用变量（阳生/阴生）

# Fields
- `sunlit::FT`: 阳生叶片值
- `shaded::FT`: 阴生叶片值
"""
@with_kw mutable struct LeafPhoto{FT<:AbstractFloat}
  sunlit::FT = FT(0.0)
  shaded::FT = FT(0.0)
end

"""
    PhotoResult{FT}

光合作用计算结果

# Fields
- `Gc::LeafPhoto{FT}`: CO2 导度 [mol m-2 s-1]
- `An::LeafPhoto{FT}`: 净光合速率 [μmol m-2 s-1]
- `Ci::LeafPhoto{FT}`: 胞间 CO2 浓度 [μmol mol-1]
- `Gs::LeafPhoto{FT}`: 气孔导度 [mol m-2 s-1]
- `Rd::LeafPhoto{FT}`: 暗呼吸速率 [μmol m-2 s-1]
"""
@with_kw mutable struct PhotoResult{FT<:AbstractFloat}
  Gc::LeafPhoto{FT} = LeafPhoto{FT}()
  An::LeafPhoto{FT} = LeafPhoto{FT}()
  Ci::LeafPhoto{FT} = LeafPhoto{FT}()
  Gs::LeafPhoto{FT} = LeafPhoto{FT}()
  Rd::LeafPhoto{FT} = LeafPhoto{FT}()
end
````

## File: standalone/UpdateSoilMoisture.jl
````julia
function UpdateSoilMoisture(soil::Soil, kstep::Float64)
  inf, inf_max = 0.0, 0.0
  Δt, total_t, max_Fb = 0.0, 0.0, 0.0

  n = soil.n_layer
  @unpack dz, f_water, K_sat, Kavg, Kmid, b,
  ψ_sat, ψ,
  θ_sat, θ, θ_prev = soil
  θ_prev .= θ # assign current soil moisture to prev

  # Max infiltration calculation
  # K_sat * (1 + (θ_sat - θ_prev) / dz * ψ_sat / θ_sat * b )
  inf_max = K_sat[1] * (1 + (θ_sat[1] - θ_prev[1]) / dz[1] * ψ_sat[1] * b[1] / θ_sat[1])
  inf = max((soil.z_water / kstep + soil.r_rain_g), 0)
  inf = clamp(inf, 0, inf_max)

  # Ponded water after runoff. This one is related to runoff. LHe.
  # soil.z_water = (soil.z_water / kstep + soil.r_rain_g - inf) * kstep * soil.r_drainage

  @inbounds while total_t < kstep
    # 为了解决相互依赖的关系，循环寻找稳态
    # the unsaturated soil water retention. LHe
    # Hydraulic conductivity: Bonan, Table 8.2, Campbell 1974, K = K_sat*(θ/θ_sat)^(2b+3)
    for i in 1:n
      ψ[i] = cal_ψ(θ[i], θ_sat[i], ψ_sat[i], b[i])
      Kmid[i] = cal_K(θ[i], θ_sat[i], K_sat[i], b[i]) # Hydraulic conductivity, [m/s]
    end

    # Fb, flow speed. Dancy's law. LHE.
    # check the r_waterflow further. LHE
    for i in 1:n-1
      # 不同层土壤深度不同，能否这样写？
      # K * ψ * b / (b + 3): ?
      # the unsaturated hydraulic conductivity of soil layer
      Kavg[i] = (Kmid[i] * ψ[i] + Kmid[i+1] * ψ[i+1]) / (ψ[i] + ψ[i+1]) * (b[i] + b[i+1]) / (b[i] + b[i+1] + 6) # 计算平均的一种方案？
      Q = Kavg[i] * (2 * (ψ[i+1] - ψ[i]) / (dz[i] + dz[i+1]) + 1) # z direction
      Q_max = (θ_sat[i+1] - θ[i+1]) * dz[i+1] / kstep + soil.ETi[i+1]
      Q = min(Q, Q_max)

      soil.r_waterflow[i] = Q
      max_Fb = max(max_Fb, abs(Q))
    end
    # p.r_waterflow[n] = 0

    Δt = guess_step(max_Fb) # this_step
    total_t += Δt
    total_t > kstep && (Δt -= (total_t - kstep))

    # from there: kstep is replaced by this_step. LHE
    for i in 1:n
      if i == 1
        θ[i] += (inf - soil.r_waterflow[i] - soil.ETi[i]) * Δt / dz[i]
      else
        θ[i] += (soil.r_waterflow[i-1] - soil.r_waterflow[i] - soil.ETi[i]) * Δt / dz[i]
      end
      θ[i] = clamp(θ[i], soil.θ_vwp[i], θ_sat[i])
    end
  end

end


# Campbell 1974, Bonan 2019 Table 8.2
@fastmath function cal_ψ(θ::T, θ_sat::T, ψ_sat::T, b::T) where {T<:Real}
  ψ = ψ_sat * (θ / θ_sat)^(-b)
  max(ψ, ψ_sat)
end

@fastmath cal_K(θ::T, θ_sat::T, K_sat::T, b::T) where {T<:Real} =
  K_sat * (θ / θ_sat)^(2 * b + 3)

"""
[m s-1] -> 1000*[mm s-1] -> 1000*[kg m-2 s-1]
"""
# 如果流速过快，则减小时间步长
function guess_step(max_Fb)
  # this constraint is too large
  if max_Fb > 1.0e-5 # 864 mm/day
    Δt = 1.0
  elseif max_Fb > 1.0e-6 # 86.4 mm/day
    Δt = 30.0 # seconds
  else
    Δt = 360.0
  end
  Δt
end
````

## File: surface_temperature.jl
````julia
# 计算雪热导率 (Jordan, 1991)
@inline cal_κ_snow(ρ) = 0.021 + 4.2e-4 * ρ + 2.2e-9 * ρ^3

# 显式时间步进 (Explicit Euler)
@inline step_exp(T, Fin, Fout, C, dt) = T + (Fin - Fout) / C * dt

# 相变检查：若跨越0度且存在水源，则强制钳制在0度
@inline check_phase(T, Told, w) = ((T > 0 >= Told) || (T < 0 <= Told && w)) ? zero(T) : T

# Formula: (T_old*Inertia + Rad + Air + Cond_Below) / Denom
function solve_imp(T_old, T_bnd, T_bot, ΔE, ra, z, G, ρCp, κ_bot; z_rad=z, c_s=1.0, μ=NaN)
  I = ΔE * ra * z
  numerator = T_old * I + G * ra * z_rad + ρCp * T_bnd * z + c_s * ra * κ_bot * T_bot
  denominator = ρCp * z + c_s * ra * κ_bot + I

  ans = numerator / denominator
  !isnan(μ) && (ans = clamp(ans, μ - 25.0, μ + 25.0))
  return ans
end


function surface_temperature_jl!(
  Rn_g::FT, T_air::FT, Tc_u::FT, RH::FT,
  z_snow::FT, z_water::FT, ρ_snow::FT, perc_snow_g::FT,
  z_soil1::FT, κ_soil1::FT, Cv_soil1::FT, Cv_soil0::FT, Gheat_g::FT,
  E_soil::FT, E_water_g::FT, E_snow_g::FT,
  G_soil1::FT, T_soil1_last::FT, T_soil0_last::FT,
  last::SnowLand{FT}, current::SnowLand{FT};
  kstep=360.0
) where {FT<:AbstractFloat}
  # 从 last_in 读取上一步的温度
  T_surf_last = last.T_surf
  T_mix0_last = last.T_mix0
  T_snow0_last = last.T_snow0
  T_snow1_last = last.T_snow1
  T_snow2_last = last.T_snow2

  Δt::FT = kstep
  cp_ice::FT = 2228.261
  λ_water::FT = cal_lambda(T_air)
  λ_snow::FT = 2.83e6
  cp::FT = cal_cp(T_air, RH)
  ra_g::FT = 1.0 / Gheat_g
  ρCp::FT = ρₐ * cp

  # Parameters for Case 3 (Deep Snow)
  dz_snow_s1::FT = 0.02
  dz_snow_s2::FT = 0.02
  dz_soil_s0::FT = 0.02

  κ_dry_snow::FT = cal_κ_snow(ρ_snow) # 雪热导率
  Gg::FT = Rn_g - E_snow_g * λ_snow - (E_water_g + E_soil) * λ_water # 地表可用能量

  T_soil0::FT = 0.0
  G::FT = 0.0

  ΔM_soil1 = Cv_soil1 * 0.02 / Δt # soil heat capacity per unit area, Cv = ρ cp

  if z_snow <= 0.02
    # Case 1: 无雪或极浅雪 (≤2cm)
    T_surf = solve_imp(T_surf_last, T_air, T_soil1_last, ΔM_soil1,
      ra_g, z_soil1, Gg, ρCp, κ_soil1; μ=T_surf_last)

    T_mix0 = T_surf
    T_snow0 = T_mix0
    T_soil0 = T_mix0
    T_snow1 = T_mix0
    T_snow2 = T_mix0

    G = 2 * κ_soil1 * (T_mix0 - T_soil1_last) / z_soil1
    G = clamp(G, -100.0, 100.0)

  elseif z_snow > 0.02 && z_snow <= 0.05
    # Case 2: 中等雪深 (2-5cm) - 雪土混合
    Δz_soil1 = 0.5z_soil1 # 第一层土壤厚度的一半
    Δz_snow = z_snow      # 雪层厚度, bottom to top

    # Case 2: 中等雪深 (2-5cm) - 雪土混合
    T_soil0 = solve_imp(T_soil0_last, T_air, T_soil1_last, ΔM_soil1, ra_g, z_soil1,
      Gg, ρCp, κ_soil1; c_s=2.0, μ=T_air)                                       # 裸土地表温度

    ΔM_snow = cp_ice * ρ_snow * z_snow / Δt
    T_snow0 = solve_imp(T_snow0_last, Tc_u, T_mix0_last, ΔM_snow, ra_g, z_snow,
      Gg, ρCp, κ_dry_snow; μ=T_air)                                             # 雪表温度

    T_interface = (κ_soil1 * T_soil1_last / Δz_soil1 + κ_dry_snow * T_snow0 / Δz_snow + ΔM_soil1 * T_mix0_last) /
                  (κ_soil1 / Δz_soil1 + κ_dry_snow / Δz_snow + ΔM_soil1)        # Ts(z=0) only with snow cover
    T_mix0 = T_soil0 * (1 - perc_snow_g) + T_interface * perc_snow_g            # Ts(z=0)

    G_snow = κ_dry_snow * (T_snow0 - T_soil1_last) / (Δz_snow + Δz_soil1)
    G_soil = κ_soil1 * (T_mix0 - T_soil1_last) / Δz_soil1

    G = G_snow * perc_snow_g + G_soil * (1 - perc_snow_g)
    G = clamp(G, -100.0, 100.0)

    # 相变检查
    (T_snow0 > 0.0 && T_snow0_last <= 0.0 && z_snow > 0.0) && (T_snow0 = 0.0)
    (T_snow0 < 0.0 && T_snow0_last >= 0.0 && z_water > 0.0) && (T_snow0 = 0.0)

    T_surf = T_snow0 * perc_snow_g + T_soil0 * (1 - perc_snow_g)
    T_surf = clamp(T_surf, T_air - 25.0, T_air + 25.0)

    T_snow1 = T_snow0
    T_snow2 = T_snow0

  else  # z_snow > 0.05
    # Case 3: 深雪 (>5cm) - 3层雪模型
    dz_snow_s12 = dz_snow_s1 + dz_snow_s2

    ΔM_snow = cp_ice * ρ_snow * dz_snow_s1 / Δt
    T_snow0 = solve_imp(T_snow0_last, T_air, T_snow1_last, ΔM_snow, ra_g, dz_snow_s12, Gg, ρCp, κ_dry_snow; z_rad=dz_snow_s1, μ=T_air)

    G_snow = κ_dry_snow * (T_snow0 - T_snow1_last) / dz_snow_s12
    G = clamp(G_snow, -100.0, 100.0)

    G_snow1 = κ_dry_snow * (T_snow1_last - T_snow2_last) / (z_snow - dz_snow_s1)
    T_snow1 = step_exp(T_snow1_last, G, G_snow1, cp_ice * ρ_snow * dz_snow_s2, Δt)

    G_snow2 = (T_snow2_last - T_mix0_last) / ((0.5 * (z_snow - dz_snow_s12) / κ_dry_snow) + (dz_soil_s0 / κ_soil1))
    T_snow2 = step_exp(T_snow2_last, G_snow1, G_snow2, cp_ice * ρ_snow * (z_snow - dz_snow_s12), Δt)

    T_mix0 = step_exp(T_mix0_last, G_snow2, G_soil1, Cv_soil0 * dz_soil_s0, Δt)
    T_soil0 = T_mix0

    # 相变检查
    (T_snow0 > 0.0 && T_snow0_last <= 0.0 && z_snow > 0.0) && (T_snow0 = 0.0)
    (T_snow0 < 0.0 && T_snow0_last >= 0.0 && z_water > 0.0) && (T_snow0 = 0.0)

    T_surf = T_snow0
  end
  @pack! current = T_surf, T_mix0, T_snow0, T_snow1, T_snow2
  return G, T_soil0
end


function surface_temperature!(
  state::AbstractSoil, ps::ParamBEPS{FT},
  Tsnow_p::SnowLand{FT}, Tsnow_c::SnowLand{FT},
  radiation_g::FT, Tc_u::FT, T_air::FT, RH::FT, z_snow::FT, z_water::FT, ρ_snow::FT, f_snow_g::FT, Gheat_g::FT,
  Evap_soil::FT, Evap_SW::FT, Evap_SS::FT; kstep=360.0) where {FT<:AbstractFloat}

  UpdateThermal_κ(state, ps)  # Soil Thermal Conductivity module by L. He
  UpdateThermal_Cv(state, ps)

  # 1. 准备土壤热力学参数
  Cv1 = Cv0 = state.Cv[1]           # 体积热容 [J m-3 K-1]
  κ_soil1 = state.κ[1]                 # 热导率 [W m-1 K-1]; 表皮为1, 第一层为2
  z_soil1 = state.dz[1]               # 层厚度 [m]

  # 2. 调用 surface_temperature_jl 计算
  G, T_soil0 = surface_temperature_jl!(radiation_g, T_air, Tc_u, RH,
    z_snow, z_water, ρ_snow, f_snow_g,
    z_soil1, κ_soil1, Cv1, Cv0, Gheat_g,
    Evap_soil, Evap_SW, Evap_SS,
    state.G[1],
    state.Tsoil_p[2],      # T_soil1: 第一层土壤温度 [°C]
    state.Tsoil_p[1],      # T_soil0:
    Tsnow_p, Tsnow_c; kstep)

  state.Tsoil_c[1] = T_soil0 # 更新 soil 的当前温度状态
  return G
end
````
