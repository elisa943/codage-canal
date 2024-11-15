function v=viterbi_decode_nul(y,trellis)
    n=(length(y)/2)-2;
    c=y+ones(1,length(y));
    p=zeros(1,4);
    graph=zeros(4,7);
    graph_b=zeros(4,7);
    % Ouverture
    for i=0:1
        graph(trellis.nextStates(1,1)+1,1:2)=int2bit(trellis.outputs(1,1).',2);
        p(trellis.nextStates(1,1)+1)=mod(graph(trellis.nextStates(1,1)+1,1)+c(2*i+1),2)+mod(graph(trellis.nextStates(1,1)+1,1)+c(2*i+2),2)+p(trellis.nextStates(1,1)+1);
        graph(trellis.nextStates(1,2)+1,1:2)=int2bit(trellis.outputs(1,2).',2);
        p(trellis.nextStates(1,2)+1)=mod(graph(trellis.nextStates(1,2)+1,2)+c(2*i+1),2)+mod(graph(trellis.nextStates(1,2)+1,2)+c(2*i+2),2)+p(trellis.nextStates(1,2)+1);
        if i==1
            graph(trellis.nextStates(4,1)+1,3:4)=int2bit(trellis.outputs(4,1).',2);
            p(trellis.nextStates(4,1)+1)=mod(graph(trellis.nextStates(4,1)+1,1)+c(2*i+1),2)+mod(graph(trellis.nextStates(4,1)+1,1)+c(2*i+2),2);
            graph(trellis.nextStates(4,2)+1,3:4)=int2bit(trellis.outputs(4,2).',2);
            p(trellis.nextStates(4,2)+1)=mod(graph(trellis.nextStates(4,2)+1,2)+c(2*i+1),2)+mod(graph(trellis.nextStates(4,2)+1,2)+c(2*i+2),2);
        end
    end
    for i=2:n-1
        for j=1:4
            %graph(trellis.nextStates(j,1)+1,1:2)=int2bit(trellis.outputs(j,1).',2);
            if j==1 || j==3
                p1=mod(graph(trellis.nextStates(j,1)+1,1)+c(2*i+1),2)+mod(graph(trellis.nextStates(j,1)+1,2)+c(2*i+2),2)+p(trellis.nextStates(j,1)+1);
                if p1>p(trellis.nextStates(j,1)+1)
                    p(trellis.nextStates(j,1)+1)=p1;
                    graph_b(trellis.nextStates(j,1)+1,1:2*i+1)=graph(trellis.nextStates(j,1),1:2*i+1);
                else
                    graph_b(trellis.nextStates(j,1)+1,1:2*i+1)=graph(trellis.nextStates(j-1,2),1:2*i+1);
                end
                p2=mod(graph(trellis.nextStates(j,2)+1,2)+c(2*i+1),2)+mod(graph(trellis.nextStates(j,2)+1,2)+c(2*i+2),2)+p(trellis.nextStates(j,2)+1);
                if p2>p(trellis.nextStates(j,2)+1)
                    p(trellis.nextStates(j,1)+1)=p1;
                    graph_b(trellis.nextStates(j,1)+1,1:2*i+1)=graph(trellis.nextStates(j,1),1:2*i+1);
                else
                    graph_b(trellis.nextStates(j,1)+1,1:2*i+1)=graph(trellis.nextStates(j-1,2),1:2*i+1);
                end
                %p(trellis.nextStates(j,1)+1)=mod(graph(trellis.nextStates(j,1)+1,1)+c(2*i+1),2)+mod(graph(trellis.nextStates(j,1)+1,2)+c(2*i+2),2)+p(trellis.nextStates(j,1)+1);
            end
            %graph(trellis.nextStates(j,2)+1,1:2)=int2bit(trellis.outputs(j,2).',2);
            p(trellis.nextStates(j,2)+1)=mod(graph(trellis.nextStates(j,2)+1,1)+c(2*i+1),2)+mod(graph(trellis.nextStates(j,2)+1,2)+c(2*i+2),2)+p(trellis.nextStates(j,2)+1);
        end
    end
end