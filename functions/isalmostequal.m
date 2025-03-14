function result = isalmostequal(A, B, tol)
    if nargin < 3
        tol = 1e-12; % Default tolerance
    end
    if ~isequal(size(A), size(B))
        result = false; % Matrices must have the same size
    else
        result = all(abs(A - B) < mavu(tol,A.unit), 'all');
    end
end
