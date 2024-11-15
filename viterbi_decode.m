function u = viterbi_decode(y, treillis)
    % Paramètres
    nb = log2(treillis.numInputSymbols);
    ns = log2(treillis.numOutputSymbols);
    m = log2(treillis.numStates);
    L = floor(length(y) / ns)-2;
    K = L - m;
    nextStates = treillis.nextStates;
    outputs = treillis.outputs;
    branches = -inf(pow2(m), L);
    predecessors = zeros(pow2(m), L);

    % Initialisation de l'état initial (état 0)
    etat_initial = 1; 
    branches(1, etat_initial) = 0;                           % coût initial
    indice = 2;

    % Parcours 
    while indice <= L && not(isempty(find(branches(:, indice) == -inf, 1)))                     % Tant que tous les états n'ont pas été atteints 
        etat_atteints = find(branches(:, indice - 1) ~= -inf).';
        if (not(isempty(etat_atteints)))
            for i = etat_atteints                                                               % Pour chaque état déjà atteint (à l'itération précédente)
                for j = 1:2                                                                     % Pour chaque transition possible
                    next_state = nextStates(i, j);                                              % Prochain état  
                    output_bits = int2bit(outputs(i, j), ns);                                   % output en bits
                    cout = sum(y(ns * (indice - 2) + 1 : ns * (indice - 1)) .* output_bits.'); 
                    nouveau_cout = branches(i, indice - 1) + cout;

                    % Mise à jour 
                    if nouveau_cout > branches(next_state + 1, indice)
                        branches(next_state + 1, indice) = nouveau_cout;                        % Coût
                        predecessors(next_state + 1, indice) = i;                               % Prédécesseur
                    end
                end
            end
        end
        indice = indice + 1;
    end

    disp(branches);

    % Fermeture 
    u = zeros(1, K);
    [~, state] = min(branches(:, L));
    for n = L:-1:2
        u(n - 1) = state;                           % Enregistre l'état
        state = predecessors(state, n);             % Remonte au prédécesseur
    end
end