function Grid = setupGrid(Width,Translation,box,x)
%Handles the setup of the Grid used to reduce the unneccessary comparisons 
% between particles by sorting the particles into grid cell's, restricting 
% the particles interactions to the current and 8 other neighbouring cells

Grid.Width = Width;
Grid.Translation = Translation;
Grid.cells_X = Grid.Translation + ceil((box(1,2) - box(1,1))/(Grid.Width));
Grid.cells_Y = Grid.Translation + ceil((box(2,2) - box(2,1))/(Grid.Width));

% Find Grid Box for each Particle
Grid.idx = Grid.Translation + floor(x./Grid.Width);

% Converting to linear indexing
cell_indices = round(sub2ind([Grid.cells_X, Grid.cells_Y], Grid.idx(1,:), Grid.idx(2,:)));
particle_indices = (1:length(x))';
% Grouping the particles associated with each cell
Grid.data = accumarray(cell_indices(:), particle_indices, [Grid.cells_X*Grid.cells_Y 1], @(x) {x});   
end

