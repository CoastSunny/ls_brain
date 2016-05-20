%baseline remove by using averaging
function [Y]=smooth_data(L,data)
    for j=1:size(data,1)
        N=length(data);
        for i=1:N-L+1
            data_s(i:L+i-1)=sum(data(j,i:L+i-1))/L;
        end
        for i=N-L+1:-1:1
            data_s2(i:L+i-1)=sum(data_s(i:L+i-1))/L;
        end
        data_rb=data(j,:)-data_s2;
        Y(j,:)=data_rb;
    %     figure; plot(data(ch,:))
    %     title('original data')
    %     figure; plot(data_s2)
    %     title('smoothed data')
    %     figure; plot(data_rb)
    %     title('baseline removed data')
    end
end