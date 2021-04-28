p= 2359457956956300567038105751718832373634513504534942514002305419604815592073181005834416173;
dsa_pub = [Mod(16, p), 589864489239075141759526437929708093408628376133735628500576354901203898018295251458604043, 2028727269671031475103905404250865899391487240939480351378663127451217489613162734122924934];
[g,q,X]= dsa_pub;
dsa_pub= [g, q,  Mod(X, p)];


\\ **********************************************************************************
\\  Infos :                                                                         *
\\                                                                                  *
\\    dsa_pub: Clé publique utilisée par notre algorithme DSA                       *
\\          dsa_pub au format [g, q, X]                                             *
\\                                                                                  *
\\ **********************************************************************************



\\ **********************************************************************************
\\  Fonctions de l'exercice :                                                       *
\\                                                                                  *
\\    find_k(signatures_r, dsa_pub): Tire au hasard un k et vérifie                 *
\\      grâce à la fonction check_k_all, s'il existe une signature [H(m), r, s]     *
\\                  tel que r= (g^k mod p) mod q                                    *
\\      Si un tel r existe dans signatures_r, renvoyer [k, r]                       *
\\                                                                                  *
\\    find_correspondant_sig(r, signatures):                                        *
\\      Retourne la signature [H(m), r_, s] pré-existante dans signatures           *
\\                  tel que r_ = r                                                  *
\\                                                                                  *
\\  Méthode:                                                                        *
\\    Déterminer un [r, k] fonctionnel avec find_k                                  *
\\    Déterminer la signature associée à r                                          *
\\    s= (h + rx) / k ssi x= (sk - h) / r                                           *
\\    Calculer x= (sk - h) / r                                                      *
\\ **********************************************************************************

check_k_all(k, r_all, dsa_pub)= {
  my(h,r,g,q,X);
  [g,q,X] = dsa_pub;
  r= lift( Mod( lift(Mod(g^k,p)), q) );
  if( vecsearch(r_all, r) > 0, r, 0);
}

find_k(signatures_r, dsa_pub)= {
  my(k, r);
  j= 1;
  while(true, k=random(10^10); r= check_k_all(k, signatures_r, dsa_pub); if(r > 0, break; ); );
  [k, r];
}
find_correspondant_sig(r, signatures)={
  for(i=1,#signatures, if(signatures[i][2] == r, return(signatures[i]); ) );
}

signatures= readvec("input.txt");
signatures_r= vecsort( [ signatures[i][2] | i <- [1..#signatures] ]);

[k, r]= find_k(signatures_r, dsa_pub);
[h, r, s]= find_correspondant_sig(r, signatures);

x=lift(Mod(lift((s*k-h)*r^(-1)),q));

print(x);