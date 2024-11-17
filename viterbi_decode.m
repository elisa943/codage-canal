function u = viterbi_decode(y, treillis)
    % Paramètres
    nb = log2(treillis.numInputSymbols);
    ns = log2(treillis.numOutputSymbols);
    m = log2(treillis.numStates);
    L = floor(length(y)/ns)-m;
    nextStates = treillis.nextStates;
    outputs = treillis.outputs;

    % Initialisation des variables
    branches = inf(pow2(m),L+2);
    predecessors = zeros(pow2(m),L+2);
    etat_fermeture = ones(1,pow2(m));
    for i=1:pow2(m)
        if nextStates(i,1)==0 || nextStates(i,2)==0
            etat_fermeture(i)=0;
        end
    end
    for i=1:pow2(m)
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
    branches(1, etat_initial) = 0;                                                          % coût initial
    indice = 2;

    % Parcours des états
    while indice <= L && not(isempty(find(branches(:, indice) == inf, 1)))                  % Tant que tous les états n'ont pas été atteints 
        for i = find(branches(:, indice - 1) ~= inf).'                                      % Pour chaque état déjà atteint (à l'itération précédente)
            for j = 1:2                                                                     % Pour chaque transition possible
                next_state = nextStates(i, j);                                              % prochain état  
                output_bits = int2bit(outputs(i, j), ns);                                   % output en bits
                cout = sum(y(ns * (indice - 2) + 1 : ns * (indice - 1)) .* output_bits.'); 
                nouveau_cout = branches(i, indice - 1) + cout;                              % nouveau coût 

                % Mise à jour 
                if nouveau_cout < branches(next_state + 1, indice)                          % Si le nouveau coût est plus petit, on met à jour 'branches' et le prédécesseur
                    branches(next_state + 1, indice) = nouveau_cout;                        % coût
                    predecessors(next_state + 1, indice) = i;                               % prédécesseur
                end
            end
        end
        indice = indice + 1;
    end

    % Fermeture
    while indice <= L+2 && not(isempty(find(branches(:,indice) == inf, 1)))                 % Tant que tous les états n'ont pas été atteints
        for i = (find(branches(:,indice - 1) ~= inf)).'                                     % Pour chaque état déjà atteint (à l'itération précédente)
            next_state = etat_fermeture(i);                                                 % prochain état
            output_bits = int2bit(outputs(i, j), ns).';                                     % output en bits
            cout = sum((y(ns * (indice - 2) + 1 : ns * (indice - 1)) - output_bits));       
            nouveau_cout = branches(i,indice-1) + cout;                                     % nouveau coût   
            
            % Mise à jour 
            if nouveau_cout < branches(next_state+1,indice)                                 % Si le nouveau coût est plus petit, on met à jour 'branches' et le prédécesseur
                branches(next_state+1,indice) = nouveau_cout;                               % coût
                predecessors(next_state+1,indice) = i;                                      % prédécesseur
            end
        end
        indice=indice+1;
    end

    % Chemin inverse
    u = [];
    [~, state_2] = min(branches(:, L+2));                                       % état final
    state_1 = predecessors(state_2, L+2);                                       % prédécesseur de l'état final
    for n = L+1:-1:1  
        u = cat(2, StateToState(nextStates, state_1, state_2), u);              % Ajoute les bits 
        state_2 = state_1;                                                      % Passe à l'état précédent
        state_1 = predecessors(state_1, n);                                     % Remonte au prédécesseur
    end
end

function bits = StateToState(nextStates, etat_initial, etat_arrivee)           
    % Renvoie les bits entre deux états si la transition existe 
    % Sinon renvoie null
    for i=1:2
        if nextStates(etat_initial, i) + 1 == etat_arrivee
            bits = i-1;
            return;
        end
    end
    bits = null; 
end 