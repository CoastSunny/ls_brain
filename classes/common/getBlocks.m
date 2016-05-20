function [blocks_in blocks_excluded]= getBlocks(obj , blocks_in)
                 
                all_blocks=1:numel(obj.block_idx);
                if (strcmp(blocks_in,'all'))
                    blocks_in=all_blocks;
                    blocks_excluded=[];
                else
                    blocks_excluded=setdiff(all_blocks,blocks_in);
                end
end