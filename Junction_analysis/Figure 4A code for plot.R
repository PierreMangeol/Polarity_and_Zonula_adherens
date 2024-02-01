library(ggplot2)

dens <- density(area$V1)
df <- data.frame(x=dens$x, y=dens$y)
probs <- c(-0, 0.5)
quantiles <- c(-50, 0)
df$quant <- factor(findInterval(df$x,quantiles))
ggplot(df, aes(x,y))+
  geom_line() +
  geom_ribbon(aes(ymin=0, ymax=y, fill=quant), show.legend = F)+
  xlim( c(-170,170))+
  theme_test()

