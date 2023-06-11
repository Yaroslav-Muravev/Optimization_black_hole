function Export_3D(res_param)
    cd result/
    import com.comsol.model.*
    import com.comsol.model.util.*
    
    model = ModelUtil.create('Model');
    model.modelPath('~/Рабочий стол/matlab_kras/x');
    
    comp1 = model.component.create('comp1',true);
    geom1 = comp1.geom.create('geom1', 3);
    
    wp1 = geom1.feature.create('wp1', 'WorkPlane');
    wp1.set('planetype', 'quick');
    wp1.set('quickplane', 'xy');
    
    rings = res_param{1};
    x1 = res_param{2};
    x2 = res_param{3};
    x3 = res_param{4};
    x4 = res_param{5};
    x5 = res_param{6};
    x6 = res_param{7};
    x7 = 0.1;

    r1 = wp1.geom.feature.create('r1', 'Rectangle');
    r1.set('size', [x7 24]);
    r1.set('pos', [0 1]);
    
    for r_ind = 1:19
        if rings(r_ind) == 1
            r_name = 'r' + string(r_ind + 1);
            r_obj = wp1.geom.feature.create(r_name, 'Rectangle');
        
            r_pos = x2*(r_ind + x3) + (x4 + 1)*x5/2;
            r_size = x6*r_pos;
        
            r_obj.set('size', [r_size*0.1 0.2]);
            r_obj.set('pos', [x7 r_pos*0.1]);
        end
    end
    geom1.run
    
    ext1 = geom1.feature.create('ext1', 'Extrude');
    ext1.set('distance', '6');
    ext1.selection('input').set({'wp1'});
    geom1.run;
    
    wp2 = geom1.feature.create('wp2', 'WorkPlane');
    wp2.set('planetype', 'quick');
    wp2.set('quickplane', 'yz');
    wp2.set('quickx', '0');
    
    pd = wp2.geom.feature.create('pd', 'Rectangle');
    pd.set('pos', [0, -0.1])
    pd.set('size', [25, 0.1])
    
    ext2 = geom1.feature.create('ext2', 'Extrude');
    ext2.selection('input').set({'wp2'});
    ext2.set('distance', '12');
    geom1.run;
    
    mphsave(model, 'optimized_model_3d');
end