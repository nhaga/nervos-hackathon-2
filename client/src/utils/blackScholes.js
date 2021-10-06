function N(z) {
  let b1 =  0.31938153
  let b2 = -0.356563782
  let b3 =  1.781477937
  let b4 = -1.821255978
  let b5 =  1.330274429
  let p  =  0.2316419
  let c2 =  0.3989423
  let a = Math.abs(z)
  if (a>6.0) {return 1.0;} 
  let t = 1.0/(1.0+a*p);
  let b = c2*Math.exp((-z)*(z/2.0));
  let n = ((((b5*t+b4)*t+b3)*t+b2)*t+b1)*t;
  n = 1.0-b*n;
  if (z < 0.0) {n = 1.0 - n;}
  return n;
}  

function ndist(z) {
  return (1.0/(Math.sqrt(2*Math.PI)))*Math.exp(-0.5*z)
}

function bsCall (S, X, r, v, t) {
  let sqt = Math.sqrt(t)
  let d1 = (Math.log(S / X) + r * t) / (v * sqt) + 0.5 * (v * sqt)
  let d2 = d1 - (v*sqt)
  return ( S*N(d1)-X*Math.exp(-r*t) *N(d2))
}

function bsIV(S,X,r,t,o) { 
  let sqt = Math.sqrt(t)
  const MAX_ITER = 100
  const ACC = 0.0001
 
  let sigma = (o/S)/(0.398*sqt)
  for (let i=0; i < MAX_ITER; i++) {
    let price = bsCall(S,X,r,sigma,t)
    let diff = o - price
    if (Math.abs(diff) < ACC) return sigma
    let d1 = (Math.log(S/X) + r*t)/(sigma*sqt) + 0.5*sigma*sqt
    let vega = S*sqt*ndist(d1);
    sigma = sigma + diff/vega;
  }
  return "Error, failed to converge";
 
} 


export { bsCall, bsIV }



