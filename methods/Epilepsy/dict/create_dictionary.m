function [D,P,D_chirp,D_chirp_rb]=create_dictionary()

    load ('spike_location.mat')
    load ('B_G.mat')
    n=6;

    for i=1:size(spike_location,2)
        D(i,:)=double(B_G(19,spike_location(i)*200-35:spike_location(i)*200+35));
        P(i,:)=reshape(find_chirplets(D(i,:),n),[1 5*n]);
%         'D'
%         size(D,2)
        D_chirp(i,:)=real(chirplets(size(D,2),reshape(P(i,:),[n 5])));
%         D_chirp(i,:)=real(chirplets(50,reshape(P(i,:),[n 5])));
    end

    figure
    for i=1:size(D,1)
        subplot(size(D,1)/2,2,i)
        plot(D(i,:))
    end

    figure
    for i=1:size(D_chirp,1)
        subplot(size(D_chirp,1)/2,2,i)
        plot(D_chirp(i,:))
    end
    
    
    for i=1:size(D_chirp,1)
        D_chirp(i,:)=D_chirp(i,:)-mean(D_chirp(i,:));
        D_chirp(i,:)=D_chirp(i,:)/norm(D_chirp(i,:));
        D_chirp_rb(i,:)=remove_baseline(D_chirp(i,:),70,'low');
        D_chirp_rb(i,:)=remove_baseline(D_chirp_rb(i,:),10,'high');
    end
    
    figure
    for i=1:size(D_chirp_rb,1)
        subplot(size(D_chirp_rb,1)/2,2,i)
        plot(D_chirp_rb(i,:))
    end

end