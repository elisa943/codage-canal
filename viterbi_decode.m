function u = viterbi_decode(y, treillis)
    % Paramètres
    nb = log2(treillis.numInputSymbols);
    ns = log2(treillis.numOutputSymbols);
    m = log2(treillis.numStates);
    L = floor(length(y) / ns)-2;
    K = L - m;
    nextStates = treillis.nextStates;
    outputs = treillis.outputs;
    branches = inf(pow2(m),L+2);
    predecessors = zeros(pow2(m),L+2);
    etat_fermeture = ones(1,4);
    for i=1:4
        if nextStates(i,1)==0 || nextStates(i,2)==0
            etat_fermeture(i)=0;
        end
    end
    for i=1:4
        if etat_fermeture(i)~=0
            for j=1:2
                if etat_fermeture(nextStates(i,j))==0
                    etat_fermeture(i)=nextStates(i,j);
                end
            end
        end
    end
    % Initialisation de l'état initial (état 0)
    etat_initial = 1; 
    branches(1, etat_initial) = 0;                           % coût initial
    indice = 2;

    % Parcours 
    while indice <= L && not(isempty(find(branches(:, indice) == inf, 1)))                     % Tant que tous les états n'ont pas été atteints 
        for i = find(branches(:, indice - 1) ~= inf).'                                                               % Pour chaque état déjà atteint (à l'itération précédente)
            for j = 1:2                                                                     % Pour chaque transition possible
                next_state = nextStates(i, j);                                              % Prochain état  
                output_bits = int2bit(outputs(i, j), ns);                                   % output en bits
                cout = sum(y(ns * (indice - 2) + 1 : ns * (indice - 1)) .* output_bits.'); 
                nouveau_cout = branches(i, indice - 1) + cout;

                % Mise à jour 
                if nouveau_cout < branches(next_state + 1, indice)
                    branches(next_state + 1, indice) = nouveau_cout;                        % Coût
                    predecessors(next_state + 1, indice) = i;                               % Prédécesseur
                end
            end
        end
        
        indice = indice + 1;
    end
    disp(branches);

    % Chemin inverse
    u = [];
    [~, state_2] = min(branches(:, L));
    for n = L:-1:2
        state_1 = predecessors(state_2, n);                                     % Remonte au prédécesseur
        disp("Output :")
        disp(state_1);
        disp(state_2);  
        u = cat(2, outputStateToState(outputs, ns, state_1, state_2), u);       % Ajoute les bits 
        state_2 = state_1;                                                      % Passe à l'état précédent
    end
end

function bits = outputStateToState(outputs, ns, etat_initial, etat_arrivee)
    for i=1:2
        if outputs(etat_initial, i) == etat_arrivee
            bits = int2bit(i, ns).';
            return;
        end
    end
    bits = null; 
end 