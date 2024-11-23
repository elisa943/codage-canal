function c=cc_encode(u,trellis)
    % Paramètres 
    K = length(u);
    ns = log2(trellis.numOutputSymbols);
    m = log2(trellis.numStates);
    nextStates = trellis.nextStates;
    outputs = trellis.outputs;
    L = K + m;
    c = zeros(1,ns*L);
    etat = 0;
    
    % Gestion de la fermeture 
    etat_fermeture = ones(1,pow2(m));
    for i=1:pow2(m)
        if nextStates(i,1)==0 || nextStates(i,2)==0
            etat_fermeture(i)=0;
        end
    end

    % Encodage
    for i=0:K-1
        sortie      = int2bit(outputs(etat+1,u(i+1)+1).',ns);
        c(ns*i+1)   = sortie(1);
        c(ns*(i+1)) = sortie(2);
        etat        = nextStates(etat+1,u(i+1)+1);
    end

    % Fermeture    
    for j=K:L-1
        next_etat   = etat_fermeture(etat + 1);
        output_bits = int2bit(outputs(etat + 1, StateToState(nextStates,etat + 1,next_etat+1)+1), ns).';
        c(ns*j+1)   = output_bits(1);   
        c(ns*(j+1)) = output_bits(2);
        etat        = next_etat; 
    end

end

function bits = StateToState(nextStates, etat_initial, etat_arrivee)           
    % Renvoie les bits entre deux états si la transition existe 
    % Sinon renvoie null
    for i=1:2                                                                   % Pour chaque transition
        if nextStates(etat_initial, i) + 1 == etat_arrivee                      % Si la transition existe
            bits = i-1;
            return;
        end
    end
    bits = null; 
end 