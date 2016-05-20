function A2=update_A(Y,X)

    A2=Y*X'*((X*X')^(-1));

end