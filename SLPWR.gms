$funclibin stolib stodclib
function
    randbin /stolib.dbinomial /;

Set
    i   "product"   /i1,i2,i3,i4,i5,i6,i7,i8/
    j   'parts'     /j1,j2,j3,j4,j5/
    k   'scenatio'  /k1,k2/;
Parameter Table  A(i,j)   "num of part j for product i"
        j1  j2  j3  j4  j5
    i1  1   1   3   0   0
    i2  2   2   1   1   2
    i3  3   0   0   3   3
    i4  2   1   3   2   1
    i5  1   2   1   0   1
    i6  0   0   2   1   2
    i7  1   3   2   2   4
    i8  1   2   1   0   0;
Parameters
    l(i)    "sub cost to make product i"    /i1 19, i2 19, i3 16, i4 14, i5 19, i6 13, i7 10, i8 24/
    q(i)    "price of product i"    /i1 197, i2 186, i3 199, i4 179, i5 179, i6 155, i7 193, i8 167/;
Parameters
    b(j)    "cost to order part j"  /j1 8, j2 12, j3 12, j4 14, j5 9/
    s(j)    "price sell part j"     /j1 7,j2 6, j3 4, j4 6, j5 7/;
Parameter
    d(i,k)  "demand of product i in each scenario";
Parameter
    p(k)    "probaly of scenario"   /k1 0.5, k2 0.5/;

Integer Variables
    x(j)    "num of part ordered"
    y(j,k)  "num of part left"
    z(i,k)  "num of product";
Variable g total profit
Equations
    obj objective function
    cond1   z<=d
    cond2   y=x-A^T*z
    xcond   x>=0
    ycond   y>=0
    zcond   z>=0;
    
    obj..   g =e= sum(j,x(j)*b(j))+sum(k,p(k)*(sum(i,(l(i)-q(i))*z(i,k))-sum(j,s(j)*y(j,k))));
    cond1(i,k)..    z(i,k)=l=d(i,k);
    cond2(j,k)..    y(j,k)=e=x(j)-sum(i,A(i,j)*z(i,k));
    
    xcond(j)..  0 =l= x(j);
    ycond(j,k).. 0 =l= y(j,k);
    zcond(i,k).. 0 =l= z(i,k);

    

d(i, k) = randbin(10,0.5);

Model SLP   /all/;
solve SLP using mip minimizing g
display g.l, x.l, y.l, z.l, d;