function train_ocsvm( obj , varargin )

     if ( nargin > 0 )
            
            opts = struct( ...
                'name' , [] , ...
                'classes' , []  ) ;
            [ opts ] = parseOpts( opts , varargin ) ;
            opts2var
          
            classlength = zeros( size( classes , 1 ) , 1 ) ;
            labels = [] ;
            
            for i = 1 : size( classes , 1 ) 
                
                for j = 1 : numel( classes{ i } )
                    
                    indices{ i , j } = find( obj.markers == classes{ i }{ j } ) ;
                    
                    classlength( i ) = classlength( i ) + numel( indices{ i , j } ) ;
                    
                end                              
                
            end
           
            texts={'good','great','crap','shitty','amazing','normal','wtf!','desired','worthy','top secret',...
                'relaxing','nobel prize winning'};
            fprintf('\nHope you get a %s classification rate!!!!\n',texts{randi(numel(texts))});
            
          
            indices=indices';
            indices=indices(:);
            indices=cell2mat(indices);
            %X = zeros( numel( obj.data.label ) , numel( obj.data.time{ 1 } ) , numel( indices ) );
            
            for i = 1 : numel( indices )
            
                %X( : , : , i ) = obj.data.trial{ indices( i ) }(:,10:64) ; 
                %Y = obj.data.trial{ indices( i ) }(:,10:64) ; 
                Y = obj.data.trial{ indices( i ) }(38,10:64) ; 
                %[e v Y a]=pcsquash(Y,10);
                %w=inv(Y*Y')*Y*mmn';
                %X(:,:,i)=w'*Y;
                
                X(:,:,i)=Y;
               
            end
            
%             fprintf('classification starting...\n');
%             freqband=[0.1 20]';
%             fs=128;
%             len=size(X,2);
%             filt=mkFilter(freqband,floor(len/2),fs/len);
%             X=fftfilter(X,filt,[0 len],2,1);            
%             X=detrend(X,2); % detrend over time
%             
            for i = 1 : numel( indices )          
                
                Y=X(:,:,i);
                Z(:,i)=Y(:);
               
            end                                  
          
            [model]=svmtrain(ones(size(Z,2),1),Z','-s 2 -t 1 -v 5 -d 5');
            model
            %[clsfr, res]=cvtrainFn('klr_cg',X,labels','dim',3);
            try obj.addprop(name);                
            catch err
                   % delete(obj.(name));
            end
            obj.(name).model=model;                      
            obj.(name).labels=labels;
     end

end