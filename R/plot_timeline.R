#' plot timeline of model output
#' 
#' plot timeline of model output
#' @param pr promm model output
#' @param degElevation sun elevation angle for comparison threshold method
#' @export





plot_timeline <- function(pr,degElevation=-3){
  
  
  ho2 <- pr[[2]]
  ho2$tFirst  <- ho2$tFirst  + ho2$tFirst.err
  ho2$tSecond <- ho2$tSecond + ho2$tSecond.err
  ho2$lon <- coord(tFirst=ho2$tFirst,tSecond=ho2$tSecond,type=ho2$type,degElevation = degElevation,note=F)[,1]
  ho2$lat <- coord(tFirst=ho2$tFirst,tSecond=ho2$tSecond,type=ho2$type,degElevation = degElevation,note=F)[,2]
  
  se <- as.numeric(unlist(strsplit(as.character(pr[[4]][13,2]),'[ ]')))
  fe <- as.numeric(unlist(strsplit(as.character(pr[[4]][14,2]),'[ ]')))
  
  # doy 79  = 20 March
  # doy 265 = 22 September
  se <- c(79  - se[1], 79  + se[2])
  fe <- c(265 - fe[1], 265 + fe[2])
  
  years <- unique(pr[[1]]$year)
  
  jday  <- floor(as.numeric(julian(ISOdate(years,1,1))))
  
  jse1 <- jday+se[1]
  jse2 <- jday+se[2]
  jfe1 <- jday+fe[1]
  jfe2 <- jday+fe[2]
  
  poly.frame<-function(data1,data2,prob1,prob2){
    polyf<-data.frame(c(unique(data1[order(data1)]),unique(data1[order(data1,decreasing=T)])),c(tapply(data2,data1,quantile, probs = prob1,na.rm=T),tapply(data2,data1,quantile, probs = prob2,na.rm=T)[order(as.numeric(names(tapply(data2,data1,quantile, probs = prob2,na.rm=T))),decreasing=T)]))
    return(polyf)
  }
  
  par(mfrow=c(3,1),mar=c(0,4,0,0))
  plot(pr[[1]]$jday,pr[[1]]$lat,col='white',lwd=1,type="p",xaxt="n",ylab="Latitude")
  polygon(poly.frame(pr[[1]]$jday,pr[[1]]$lat,0.95,0.05),col=rgb(1,0,0,alpha=0.5) ,border=NA)
  lines(pr[[2]]$jday,pr[[2]]$lat,col='darkred',lwd=1,type="o")
  lines(ho2$jday,ho2$lat,lwd=1,type="o")
  abline(h=c(jse1,jse2),lty=3,col="green")
  abline(h=c(jfe1,jfe2),lty=3,col="blue")
  
  plot(pr[[1]]$jday,pr[[1]]$lon,col='white',lwd=1,type="p",xaxt="n",ylab="Longitude")
  polygon(poly.frame(pr[[1]]$jday,pr[[1]]$lon,0.95,0.05),col=rgb(1,0,0,alpha=0.5) ,border=NA)
  lines(pr[[2]]$jday,pr[[2]]$lon,col='darkred',lwd=1,type="o")
  lines(ho2$jday,ho2$lon,lwd=1,type="o")
  
  par(mar=c(2,4,0,0))
  plot  (pr[[1]]$jday,pr[[1]]$sat.sst,type='l',lwd=1,col="white",ylab="SST",xaxt="n")
  polygon(poly.frame(pr[[1]]$jday,pr[[1]]$sat.sst,0.95,0.05),col=rgb(1,0,0,alpha=0.5) ,border=NA)
  points(pr[[2]]$jday,pr[[2]]$median.sat.sst,type='o',lwd=1,col="darkred")
  points(pr[[2]]$jday,pr[[2]]$tag.sst,type='o',lwd=1)
  axis(1,at=floor(pr[[2]]$jday),labels=as.Date(floor(pr[[2]]$jday),origin="1970-01-01"))
  
  par(mfrow=c(1,1),mar=c(4,4,2,2)) 
  
}