
figure,hold on

for i=1:450
    
    if (i<151)
        a='r';
    elseif(i>150 && i<301)
        a='g';
    else a='b';
    end
    
    plot(V(i,:),a);
    pause(0.05);
    
end
