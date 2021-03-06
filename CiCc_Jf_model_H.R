###############################
###      Bayesian Model    ####
### Following Farq PS model ####
#### Testing Mesophyll, ETR from Chl Flr
######  & no temp dependency
###     Heirarchically set up for genotype and ind par est###
###############################

CiCc_Jf <- "model {
for (i in 1:N){
An[i] ~ dnorm( mu.A[i] , tau )
mu.A[i] <- min(Ac[i], Aj[i])

#quadratic solution for net A if limited by Rubisco
a1[i]<-(-1/gm[ID[i]])
b1[i]<-((Vcmax[ID[i]]-Rd[ID[i]])/gm[ID[i]])+(CiP[i]+(Kc*((1+O[i])/Ko )))
c1[i]<-Rd[ID[i]]*(CiP[i]+(Kc*((1+O[i])/Ko )))-Vcmax[ID[i]]*(CiP[i]-gammaS[ID[i]])
bac1[i]<-(b1[i]^2)-(4*a1[i]*c1[i])
Ac[i]<- (-b1[i]+sqrt(bac1[i]))/(2*a1[i])

# quadratic solution for net A if limited by light (RuBP regeneration)
a2[i]<-(-4.0/gm[ID[i]])
b2[i]<-(4.0*CiP[i]) + (8.0*gammaS[ID[i]]) + (Jf[i]/gm[ID[i]]) - (4.0*Rd[ID[i]] /gm[ID[i]])
c2[i]<-Jf[i] *(gammaS[ID[i]] - CiP[i] ) + (gm[ID[i]] *(4.0*CiP[i] + 8.0*gammaS[ID[i]]))
bac2[i]<-(b2[i]^2)-(4*a2[i]*c2[i])
Aj[i]<- (-b2[i]+sqrt(bac2[i]))/(2*a2[i])


}
for (k in 1:NID){
Vcmax[k] ~ dnorm(mu.Vcmax,tau.Vcmax)T(0,)
Rd[k] ~ dnorm(mu.Rd, tau.Rd)
gm[k] ~ dnorm(mu.gm, tau.gm)
gammaS[k] ~ dnorm(mu.gammaS,tau.gammaS)T(0,)
}
### Maximum rate Carboxylation -- nromal prior from Agricultural Species WULLSCHLEGER
mu.Vcmax ~ dnorm(90, 0.000625) ## SD of 40
tau.Vcmax ~ dgamma(5,5000)  # as variance distribution has mean = 34 ; SD = 9

### normal prior Dark Respiration from LR data (umol m-2 s-1)
mu.Rd ~ dnorm(3.97, 1)
tau.Rd ~ dgamma(9, 16)  # as variance distribution has mean = 1.4 ; SD = .25

### prior on gamma star (Pa) -- CO2 compensation point with photorespiration
mu.gammaS ~ dnorm(3.86,10)  ### provides narrow prior based as thought highly conserver
tau.gammaS ~ dgamma(50,5 )  ### mean is centered around 10 (or .3 as variance)

### prior on mesophyll conductance (umol m-2 s-1)
mu.gm ~ dgamma(1.85,.15)  #dnorm (2.5, 0.025)T(0,) ## wide variance due to uncertaintly and possible influence of model structure
tau.gm ~ dgamma(4,300)  ### as variance distribution has mean = 9.5 ; SD = 2.7

## Michaelis-Menten constant for CO2
Kc ~ dnorm(32.675,0.5)  # narrow prior (SD of 1.4) (RUBSICO evolutionary contraints)
#Michaelis-Menten constant for O2
Ko ~ dnorm(28612.4282, 1e-05)  # narrow prior (SD or 316) (RUBSICO evolutionary contraints)

### truncated T distribution with varaince set at 2.5 to reflect reasonalbe measurement error
tau ~ dt(0 , pow(2.5,-2), 1)T(0,)
}
"

