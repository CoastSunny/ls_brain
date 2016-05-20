function [sae, t, outx] = saeff(sae, x)
    for i = 1 : numel(sae.ae);
%         disp(['Learning features level ' num2str(i) '/' num2str(numel(sae.ae))]);
        %sae.ae{i} = nntrain(sae.ae{i}, x, x, opts);
        sae.ae{i}.testing=1;
        t = nnff(sae.ae{i}, x, x);
        sae.ae{i}.testing=0;
        x = t.a{2};
        %remove bias term
        x = x(:,2:end);
    end
    outx=x;
end
