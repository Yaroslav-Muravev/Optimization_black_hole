function F = Cost_func(cur_item)
    F = 0;
    %% Parameters
    model_dimension = 2;
    params.model.axisymmetric = true;
    
    wave_amplitude_p0 = 1; % [Pa]
    rings = cur_item{1};
    x1 = cur_item{2};
    x2 = cur_item{3};
    x3 = cur_item{4};
    x4 = cur_item{5};
    x5 = cur_item{6};
    x6 = cur_item{7};
    x7 = cur_item{8};
    
    %% Initialization of the model
    import com.comsol.model.*
    import com.comsol.model.util.*
    model = ModelUtil.create('Model');
    comp1 = model.component.create('comp1', true);
    
    
    %% Set up geometry
    geom1 = comp1.geom.create('geom1', model_dimension);
    if params.model.axisymmetric
        geom1.axisymmetric(true);
    end
    
    r_poses = [];
    r_sizes = [];
    r_domains = [];
    for r_ind = 1:18
        if rings(r_ind) == 1
            r_name = 'r' + string(r_ind + 1);
            r_obj = geom1.create(r_name, 'Rectangle');
                
            r_pos = x1*(r_ind + x2) + (r_ind + x3)*r_ind*x4;
            r_size = r_pos*x5;

            r_sizes(end + 1) = r_size;
            r_poses(end + 1) = r_pos;
            
            r_obj.set('size', [r_size*0.001 x6*0.001]);
            r_obj.set('pos', [x7*0.001 r_pos*0.001]);
            r_obj.set('createselection', 'on');
        end
    end

    maximum_index = find(r_poses == max(r_poses));

    % Tube
    tube_air = geom1.create('tube_air', 'Rectangle');
    tube_air.set('size', [0.001*(max(r_sizes) + x7 + 2) (60 + r_poses(maximum_index))*0.001]);
    tube_air.set('pos', {'0' '-20 [mm]'});
    tube_air.set('createselection', 'on');
    geom1.run;
    
    
    % PML: bottom
    pml_down = geom1.create('pml_down', 'Rectangle');
    pml_down.set('size', [0.001*(max(r_sizes) + x7 + 2) 0.1]);
    pml_down.set('pos', {'0' '-120 [mm]'});
    pml_down.set('createselection', 'on');
    geom1.run;
    
    
    % PML: top
    pml_up = geom1.create('pml_up', 'Rectangle');
    pml_up.set('size', [0.001*(max(r_sizes) + x7 + 2) 0.1]);
    pml_up.set('pos', [0 -0.02 + (60 + r_poses(maximum_index))*0.001]);
    pml_up.set('createselection', 'on');
    geom1.run;
    
    r1 = geom1.create('r1', 'Rectangle');
    r1.set('size', [x7*0.001 (r_poses(maximum_index) + x6)*0.001]);
    r1.set('pos', [0 0]);
    r1.set('createselection', 'on');
    
    
    geom1.run;
    
    %% Create selections
    % PML
    pml_up_domain_ent = mphgetselection(model.selection('geom1_pml_up_dom'));
    pml_up_domain = pml_up_domain_ent.entities;
    pml_down_domain_ent = mphgetselection(model.selection('geom1_pml_down_dom'));
    pml_down_domain = pml_down_domain_ent.entities;
    comp1.selection.create('selection_pml', 'Explicit');
    comp1.selection('selection_pml').set([pml_up_domain pml_down_domain]);
    comp1.selection('selection_pml').label('pml');
    mphgeom(model, 'geom1')
    % Structure
    for r_ind = 1:18
        if rings(r_ind) == 1 
            r_name = 'r' + string(r_ind + 1);
            r_obj_domain_ent = mphgetselection(model.selection('geom1_' + r_name + '_dom'));
            r_obj_domain = r_obj_domain_ent.entities;
            r_domains(end + 1) = r_obj_domain;
        end
    end
    
    comp1.selection.create('selection_structure', 'Explicit');
    comp1.selection('selection_structure').set(r_domains);
    comp1.selection('selection_structure').label('structure');
    
    % Air domains
    tube_air_domain_ent = mphgetselection(model.selection('geom1_tube_air_dom'));
    tube_air_domain = tube_air_domain_ent.entities;
    tube_air_domain = setdiff(tube_air_domain, r_domains);
    comp1.selection.create('selection_air', 'Explicit');
    comp1.selection('selection_air').set([pml_up_domain pml_down_domain tube_air_domain]);
    comp1.selection('selection_air').label('air');
    
    % Waveguide domains
    waveguide_air_domain = setdiff(tube_air_domain, [pml_up_domain pml_down_domain]);
    comp1.selection.create('waveguide_air', 'Explicit');
    comp1.selection('waveguide_air').set(waveguide_air_domain);
    comp1.selection('waveguide_air').label('waveguide');
    % SK: I add the waveguide domain selection because background pressure
    % field should be set only for this domain.
    
    %% Set materials
    addpath("auxiliary_functions/")
    load_air()
    load_plastic()
    % SK: it is better to move model.component('comp1').material('mat1').selection
    % lines to the main code.
    
    
    %% Set-up physics
    % Pressure acoustics
    comp1.physics.create('acpr', 'PressureAcoustics', 'geom1');
    comp1.physics('acpr').selection.named('selection_air');
    
    comp1.physics('acpr').create('bpf1', 'BackgroundPressureField', 2);
    comp1.physics('acpr').feature('bpf1').selection.named('waveguide_air');
    % SK: make sure that BPF is applied to the correct domain
    comp1.physics('acpr').feature('bpf1').set('pamp', wave_amplitude_p0);
    comp1.physics('acpr').feature('bpf1').set('c_mat', 'from_mat');
    comp1.physics('acpr').feature('bpf1').set('dir', [0, 0, 1]);
    % SK: make sure that the direction of wave propagation is correct
    
    % Solid mechanics
    comp1.physics.create('solid', 'SolidMechanics', 'geom1');
    comp1.physics('solid').selection.named('selection_structure');
    
    % Acoustic-structure boundary
    comp1.multiphysics.create('asb1', 'AcousticStructureBoundary', 1);
    comp1.multiphysics('asb1').selection.all;
    % SK: the above line is important since it is needed to select the
    % appropriate boundaries between solid structure and air.
    
    
    %% PML
    pml_scaling = '1';
    pml_curvature = '3';
    
    pml1 = comp1.coordSystem.create('pml1', 'PML');
    pml1.set('name', 'pml');
    pml1.set('ScalingType', 'Cylindrical');
    pml1.selection.set([pml_up_domain pml_down_domain]);
    pml1.set('PMLfactor', pml_scaling);
    pml1.set('PMLgamma', pml_curvature);
    
    
    %% Sampling points
    point_before_structure_x = 0.0575;
    point_before_structure_y = 0;
    point_before_structure = geom1.create('point_before_structure', 'Point');
    point_before_structure.set('p', [point_before_structure_x; point_before_structure_y]);
    geom1.run('point_before_structure');
    
    point_in_structure_x = 0.0575;
    point_in_structure_y = 0.200;
    point_in_structure = geom1.create('point_in_structure', 'Point');
    point_in_structure.set('p', [point_in_structure_x; point_in_structure_y]);
    geom1.run('point_in_structure');
    
    point_after_structure_x = 0.0005*(max(r_sizes) + x7 + 2);
    point_after_structure_y = (r_poses(maximum_index) + 10)*0.001;
    point_after_structure = geom1.create('point_after_structure', 'Point');
    point_after_structure.set('p', [point_after_structure_x; point_after_structure_y]);
    geom1.run('point_after_structure');
    
    %% Mesh
    freq_start = 100;
    freq_step = 100;
    freq_end = 3000;
    velocity = 343;
    wavelength_min = velocity/freq_end;
    
    mesh_max_element = wavelength_min/5;
    mesh_min_element = wavelength_min/20;
    mesh_curvature = 0.6;
    mesh_growth_rate = 1.5;
    mesh_pml_distribution = 10;
    mesh_narrow = 5;
    
    % Mesh size
    comp1.mesh.create('mesh1');
    comp1.mesh('mesh1').feature('size').set('custom', true);
    comp1.mesh('mesh1').feature('size').set('hmax', mesh_max_element);
    comp1.mesh('mesh1').feature('size').set('hmin', mesh_min_element);
    comp1.mesh('mesh1').feature('size').set('hgrad', mesh_growth_rate);
    comp1.mesh('mesh1').feature('size').set('hcurve', mesh_curvature);
    comp1.mesh('mesh1').feature('size').set('hnarrow', mesh_narrow);
    % SK: please, do not forget to put the narrow resolution to make sure that
    % small elements are meshed correctly
    
    % PML
    comp1.mesh('mesh1').create('map1', 'Map');
    comp1.mesh('mesh1').feature.move('map1', 1);
    comp1.mesh('mesh1').feature('map1').selection.geom('geom1', 2);
    comp1.mesh('mesh1').feature('map1').selection.set([pml_down_domain pml_up_domain]);
    comp1.mesh('mesh1').feature('map1').selection.named('selection_pml');
    % SK: to create distribution, you should select boundaries instead of the
    % domains. Hence, you need one more selection do do it.
    pml_up_domain_bnd = mphgetselection(model.selection('geom1_pml_up_bnd'));
    pml_up_boundaries = pml_up_domain_bnd.entities;
    pml_down_domain_bnd = mphgetselection(model.selection('geom1_pml_down_bnd'));
    pml_down_boundaries = pml_down_domain_bnd.entities;
    comp1.mesh('mesh1').feature('map1').create('dis1', 'Distribution');
    comp1.mesh('mesh1').feature('map1').feature('dis1').selection.all;
    comp1.mesh('mesh1').feature('map1').feature('dis1').selection.set([pml_up_boundaries, pml_down_boundaries]);
    % SK: so, here you write selection for boundaries.
    comp1.mesh('mesh1').feature('map1').feature('dis1').set('numelem', mesh_pml_distribution);
    
    % Waveguide and structure
    comp1.mesh('mesh1').create('ftri1', 'FreeTri');
    comp1.mesh('mesh1').feature('ftri1').selection.geom('geom1', 2);
    comp1.mesh('mesh1').feature('ftri1').selection.set([tube_air_domain r_domains]);
    comp1.mesh('mesh1').run;
    
    
    %% Study
    f_range_std = sprintf('range(%f, %f, %f)', freq_start, freq_step, freq_end);
    model.study.create('std1');
    model.study('std1').create('freq', 'Frequency');
    model.study('std1').feature('freq').activate('acpr', true);
    model.study('std1').feature('freq').activate('solid', true);
    model.study('std1').feature('freq').set('plist', f_range_std);
    model.study('std1').run;
    
    p_t_Pa = mphinterp(model,'acpr.p_t','coord', [point_after_structure_x; point_after_structure_y]);
    p_b_Pa = mphinterp(model,'acpr.p_b','coord', [point_after_structure_x; point_after_structure_y]);
    p_dB = 20*log(abs(p_t_Pa/p_b_Pa));
    freq0 = mphglobal(model, {'acpr.freq'});
    x = mean(p_dB, 1);
    F = x(1);
end
