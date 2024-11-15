function u = viterbi_decode(y, treillis)
    % Paramètres
    nb = log2(treillis.numInputSymbols);
    ns = log2(treillis.numOutputSymbols);
    m = log2(treillis.numStates);
    L = floor(length(y) / ns)-2;
    K = L - m;
    nextStates = treillis.nextStates;
    outputs = treillis.outputs;
    branches = -inf(pow2(m),L);
    predecessors = zeros(pow2(m),L);

    % Initialisation de l'état initial (état 0)
    etat_initial = 1; 
    branches(1, etat_initial) = 0;
    indice = 2;

    % Parcours 
    while indice<= L && not(isempty(find(branches(:,indice) == -inf, 1))) % Tant que tous les états n'ont pas été atteints
        for i = (find(branches(:,indice-1) ~= -inf)).'    
            %disp(":");
            %disp(i);% Pour chaque état déjà atteint
            disp(branches);
            for j = 1:2 
                disp(i);
                disp(outputs(i, j));% Pour chaque transition possible
                next_state = nextStates(i, j);
                output_bits = int2bit(outputs(i, j), ns).';
                cout = sum((y(ns * (indice - 2) + 1 : ns * (indice - 1)) - output_bits));
                nouveau_cout = branches(i,indice-1) + cout;
                %disp(next_state);
                %disp(cout);
                %disp(nouveau_cout);
                % Mise à jour 
                if nouveau_cout > branches(next_state+1,indice)
                    branches(next_state+1,indice) = nouveau_cout;
                    predecessors(next_state+1,indice) = i;
                end
            end
        end
        indice = indice + 1;
        %disp(indice);
    end

    % Parcours des sections 
    for n = indice:L
        % Parcours sur tous les états
        for i=1:length(outputs)
            branches(n, nextStates(i, 1)) = branches(n-1, outputs(n-1, 1)) + [y(L * (n-1) +  1) y(L * (n-1) + 2)] * int2bit(i, 2);
            branches(n, nextStates(i, 2)) = branches(n-1, outputs(n-1, 2)) + [y(L * (n-1) +  1) y(L * (n-1) + 2)] * int2bit(i, 2);
        end
    end

    % Fermeture 
    u = zeros(1, K);
    [~, state] = min(branches(L + 1, :));
    for n = L:-1:2
        u(n - 1) = state; % Enregistre l'état
        state = predecessors(n, state); % Remonte au prédécesseur
    end
end