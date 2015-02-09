% 1.  build model
t = cputime;
[model] = build_model ();
fprintf ( 'bulid model time = %f sec\n', cputime-t);


% 2.  test each image

% (1) load GT
gt = csvread ( 'unknown/gt.csv' );

% (2) test on unknown images
pt = 0;

t = cputime;

for i = 1:35
    fn = sprintf ( 'unknown/%d.gif', i );
    f = imread ( fn );
    
    alg_id = who_am_i ( model, f );
    
    if ( gt(i) == alg_id )
        pt = pt + 1;
    end
    
    fprintf ( '%d - alg(%d) vs gt(%d) - %f sec -> total pt [%d]\n', ...
        i, alg_id, gt(i), cputime-t, pt );
end

fprintf ( 'final accuracy = %d / %d = %f\n', ...
    pt, 35, (double(pt)/double(35)) );