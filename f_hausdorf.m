function DistMap=f_hausdorf(Gt, Dc)

if length(size(Gt)) length(size(Dc))
    error('Images Gt and Dc are not of the same size\n');
end
DistGt=bwdist(Gt);
DistDc=bwdist(Dc);
DistMap=double(xor(Gt,Dc)).*max(DistGt,DistDc);
