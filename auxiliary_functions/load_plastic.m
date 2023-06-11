model.component('comp1').material.create('mat2', 'Common');
model.component('comp1').material('mat2').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat2').label('Acrylic plastic');
model.component('comp1').material('mat2').set('family', 'custom');
model.component('comp1').material('mat2').set('specular', 'custom');
model.component('comp1').material('mat2').set('customspecular', [0.9803921568627451 0.9803921568627451 0.9803921568627451]);
model.component('comp1').material('mat2').set('diffuse', 'custom');
model.component('comp1').material('mat2').set('customdiffuse', [0.39215686274509803 0.7843137254901961 0.39215686274509803]);
model.component('comp1').material('mat2').set('ambient', 'custom');
model.component('comp1').material('mat2').set('customambient', [0.39215686274509803 0.7843137254901961 0.39215686274509803]);
model.component('comp1').material('mat2').set('noise', true);
model.component('comp1').material('mat2').set('noisefreq', 1);
model.component('comp1').material('mat2').set('lighting', 'phong');
model.component('comp1').material('mat2').set('shininess', 1000);
model.component('comp1').material('mat2').propertyGroup('def').set('thermalexpansioncoefficient', {'7.0e-5[1/K]' '0' '0' '0' '7.0e-5[1/K]' '0' '0' '0' '7.0e-5[1/K]'});
model.component('comp1').material('mat2').propertyGroup('def').descr('thermalexpansioncoefficient_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('heatcapacity', '1470[J/(kg*K)]');
model.component('comp1').material('mat2').propertyGroup('def').descr('heatcapacity_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('density', '1190[kg/m^3]');
model.component('comp1').material('mat2').propertyGroup('def').descr('density_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('thermalconductivity', {'0.18[W/(m*K)]' '0' '0' '0' '0.18[W/(m*K)]' '0' '0' '0' '0.18[W/(m*K)]'});
model.component('comp1').material('mat2').propertyGroup('def').descr('thermalconductivity_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Enu').set('youngsmodulus', '3.2e9[Pa]');
model.component('comp1').material('mat2').propertyGroup('Enu').descr('youngsmodulus_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Enu').set('poissonsratio', '0.35');
model.component('comp1').material('mat2').propertyGroup('Enu').descr('poissonsratio_symmetry', '');
model.component('comp1').material('mat2').set('groups', {});
model.component('comp1').material('mat2').set('family', 'custom');
model.component('comp1').material('mat2').set('lighting', 'phong');
model.component('comp1').material('mat2').set('shininess', 1000);
model.component('comp1').material('mat2').set('ambient', 'custom');
model.component('comp1').material('mat2').set('customambient', [0.39215686274509803 0.7843137254901961 0.39215686274509803]);
model.component('comp1').material('mat2').set('diffuse', 'custom');
model.component('comp1').material('mat2').set('customdiffuse', [0.39215686274509803 0.7843137254901961 0.39215686274509803]);
model.component('comp1').material('mat2').set('specular', 'custom');
model.component('comp1').material('mat2').set('customspecular', [0.9803921568627451 0.9803921568627451 0.9803921568627451]);
model.component('comp1').material('mat2').set('noisescale', 0);
model.component('comp1').material('mat2').set('noise', 'on');
model.component('comp1').material('mat2').set('noisefreq', 1);
model.component('comp1').material('mat2').set('noise', 'on');
model.component('comp1').material('mat2').set('alpha', 1);
model.component('comp1').material('mat2').selection.named('selection_structure');
model.component('comp1').material('mat2').propertyGroup('def').set('soundspeed', {'340'});