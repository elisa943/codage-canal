% Méthode de l'impulsion
function TEP = impulsion(d0, d1, trellis, Eb_N0) 
    % Paramètres et initialisation des variables
    K = 1024;
    N = 1024;
    R = K/N;
    v = zeros(1, K);
    x_u = zeros(1, K);
    y = ones(1, N);

    for l = 0:K-1
        A = d0 - 0.5; 
        x_u_2 = x_u;

        while isequal(x_u_2, x_u) && A <= d1
            A = A + 1;
            y(l+1) = 1 - A; 
            x_u_2 = viterbi_decode(y, trellis);
        end
        v(l+1) = floor(A);
    end

    % Estimation du TEP : 
    TEP = 0; 
    disp(Eb_N0);
    for d = unique(v)
        Ad = length(find(v == d));
        TEP = TEP + Ad * erfc(sqrt(d*R*Eb_N0)); 
    end
    TEP = 1/2 * TEP;
end