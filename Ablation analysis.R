####### Area ablation analysis

test_ablation_KO = KO_all
test_ablation = WT_all


library(ggplot2)

ggplot(data = test_ablation, aes(time, area, color = factor(cell)))+
  geom_line()

test_ablation_KO$cell_stack = paste(test_ablation_KO$stack, test_ablation_KO$cell)

ggplot(data = test_ablation_KO, aes(time, area, color = factor(cell_stack)))+
  geom_line()

n = length(test_ablation_KO$stack)/5

a = c()
for (i in 0:(n-1)) {
  a = c(a, rep(1+i*5,5))
}

test_ablation_KO$area_init = test_ablation_KO$area[a]

test_ablation_KO$area_norm_init_area = test_ablation_KO$area/test_ablation_KO$area_init

ggplot(data = test_ablation_KO, aes(time, area_norm_init_area, color = factor(cell_stack)))+
  geom_line()

ggplot()+
  geom_line(data = test_ablation_KO, aes(time, area_norm_init_area, color = factor(cell_stack)))


test_ablation$cell_stack = paste(test_ablation$stack, test_ablation$cell)

n = length(test_ablation$stack)/5

a = c()
for (i in 0:(n-1)) {
  a = c(a, rep(1+i*5,5))
}

test_ablation$area_init = test_ablation$area[a]

test_ablation$area_norm_init_area = test_ablation$area/test_ablation$area_init


ggplot()+
  geom_line(data = test_ablation_KO, aes(time, area_norm_init_area, fill = factor(cell_stack), color = "blue"))+
  geom_line(data = test_ablation, aes(time, area_norm_init_area, fill = factor(cell_stack), color = "red"))

average_area_WT = aggregate(test_ablation$area_norm_init_area, by = list(test_ablation$time), mean)
names(average_area_WT) = c("time", "norm_area") 

average_area_KO = aggregate(test_ablation_KO$area_norm_init_area, by = list(test_ablation_KO$time), mean)
names(average_area_KO) = c("time", "norm_area") 

plot(average_area_WT, type = 'l')
lines(average_area_WT, col = 'red')
lines(average_area_KO, col = 'blue')

ggplot()+
  geom_line(data = test_ablation_KO, aes(time, area_norm_init_area, fill = factor(cell_stack), color = "lightblue"))+
  geom_line(data = average_area_KO, aes(time, norm_area), color = "red", size = 3)+
  geom_line(data = test_ablation, aes(time, area_norm_init_area, fill = factor(cell_stack), color = "red"))+
  geom_line(data = average_area_WT, aes(time, norm_area), color = "lightblue", size = 3)


n = length(WT_all$stack)/5

a = c()
for (i in 0:(n-1)) {
  a = c(a, rep(1+i*5,5))
}

WT_all$area_init = WT_all$area[a]

WT_all$area_norm_init_area = WT_all$area/WT_all$area_init
WT_all$cell_stack = paste(WT_all$stack, WT_all$cell)

n = length(KO_all$stack)/5

a = c()
for (i in 0:(n-1)) {
  a = c(a, rep(1+i*5,5))
}

KO_all$area_init = KO_all$area[a]

KO_all$area_norm_init_area = KO_all$area/KO_all$area_init
KO_all$cell_stack = paste(KO_all$stack, KO_all$cell)
KO_all$cell_stack_replicate = paste(KO_all$cell_stack, KO_all$replicate)

average_length_WT = aggregate(WT_all$area_norm_init_area, by = list(WT_all$time), mean)
names(average_length_WT) = c("time", "norm_length") 

average_length_KO = aggregate(KO_all$area_norm_init_area, by = list(KO_all$time), mean)
names(average_length_KO) = c("time", "norm_length") 

ggplot()+
  geom_line(data = WT_all, aes(time, area_norm_init_area, fill = factor(cell_stack)), color = "lightblue")+
  geom_line(data = KO_all, aes(time, area_norm_init_area, fill = factor(cell_stack_replicate)), color = "red")+
  geom_line(data = average_length_WT, aes(time, norm_length), color = "lightblue", size = 3)+
  geom_line(data = average_length_KO, aes(time, norm_length), color = "red", size = 3)


# time between the start of two images is 0.26 s

area_time0_KO = KO_all$area[KO_all$time==0]
area_time10_KO = KO_all$area[KO_all$time==2.6]

norm_area_time0_KO = KO_all$area_norm_init_area[KO_all$time==0]
norm_area_time10_KO = KO_all$area_norm_init_area[KO_all$time==2.6]

speed_area_KO = (area_time10_KO - area_time0_KO)/2.6
speed_norm_area_KO = (norm_area_time10_KO - norm_area_time0_KO)/2.6


area_time0_WT = WT_all$area[WT_all$time==0]
area_time10_WT = WT_all$area[WT_all$time==2.6]

norm_area_time0_WT = WT_all$area_norm_init_area[WT_all$time==0]
norm_area_time10_WT = WT_all$area_norm_init_area[WT_all$time==2.6]

speed_area_WT = (area_time10_WT - area_time0_WT)/2.6
speed_norm_area_WT = (norm_area_time10_WT - norm_area_time0_WT)/2.6

boxplot(speed_area_KO, speed_area_WT, names=c("KO", "WT"))

boxplot(speed_norm_area_KO, speed_norm_area_WT, names=c("KO", "WT"))

df_area_speed = data.frame(speed = c(speed_norm_area_KO, speed_norm_area_WT), genotype = c(rep("KO", length(speed_norm_area_KO)), rep("WT", length(speed_norm_area_WT))))
df_area_speed_abs = data.frame(speed = c(speed_area_KO, speed_area_WT), genotype = c(rep("KO", length(speed_norm_area_KO)), rep("WT", length(speed_norm_area_WT))))


mean_sd_plus = function(x) {
  mean(x) + sd(x)
}

mean_sd_minus = function(x) {
  mean(x) - sd(x)
}


ggplot(df_area_speed, aes(genotype, speed*100, color = genotype))+
  #geom_boxplot(show.legend = F, outlier.alpha = 0)+
  geom_jitter(width = 0.2, height = 0, show.legend = F)+
  stat_summary(fun = "mean", geom = "crossbar", show.legend = FALSE, width = 0.8)+
  stat_summary(geom = "errorbar",
                            width = 0.7,
                            fun.min = mean_sd_plus,
                            fun.max = mean_sd_minus)+
  labs(y = "Area increase (%/s)")+
  theme_classic()

ggplot(df_area_speed_abs, aes(genotype, speed*100, color = genotype))+
  #geom_boxplot(show.legend = F, outlier.alpha = 0)+
  geom_jitter(width = 0.2, height = 0, show.legend = F)+
  stat_summary(fun = "mean", geom = "crossbar", show.legend = FALSE, width = 0.8)+
  stat_summary(geom = "errorbar",
               width = 0.7,
               fun.min = mean_sd_plus,
               fun.max = mean_sd_minus)+
  labs(y = "Area increase (µm²/s)")+
  theme_classic()



####### Junction ablation analysis


n = length(WT_junction_all$stack)/5

a = c()
for (i in 0:(n-1)) {
  a = c(a, rep(1+i*5,5))
}

WT_junction_all$length_init = WT_junction_all$length[a]

WT_junction_all$length_norm_init_length = WT_junction_all$length/WT_junction_all$length_init
WT_junction_all$cell_stack = paste(WT_junction_all$stack, WT_junction_all$cell)



#get rid of one junction that was very small compared to the others
#KO_junction_all_unfiltered = KO_junction_all
KO_junction_all = KO_junction_all_unfiltered

KO_junction_all$cell_stack = paste(KO_junction_all$stack, KO_junction_all$cell)

KO_junction_all = subset(KO_junction_all, KO_junction_all$cell_stack != "4 4")
#area that decreases on next one
KO_junction_all = subset(KO_junction_all, KO_junction_all$cell_stack != "2 3")


n = length(KO_junction_all$stack)/5

a = c()
for (i in 0:(n-1)) {
  a = c(a, rep(1+i*5,5))
}

KO_junction_all$length_init = KO_junction_all$length[a]

KO_junction_all$length_norm_init_length = KO_junction_all$length/KO_junction_all$length_init

KO_junction_all$cell_stack_replicate = paste(KO_junction_all$cell_stack, KO_junction_all$replicate)

average_length_WT = aggregate(WT_junction_all$length_norm_init_length, by = list(WT_junction_all$time), mean)
names(average_length_WT) = c("time", "norm_length") 

average_length_KO = aggregate(KO_junction_all$length_norm_init_length, by = list(KO_junction_all$time), mean)
names(average_length_KO) = c("time", "norm_length") 

ggplot()+
  geom_line(data = WT_junction_all, aes(time*0.26, length_norm_init_length, fill = factor(cell_stack)), color = "lightblue")+
  geom_line(data = KO_junction_all, aes(time*0.26, length_norm_init_length, fill = factor(cell_stack_replicate)), color = "pink1")+
  geom_line(data = average_length_WT, aes(time*0.26, norm_length), color = "#009ACD", size = 3)+
  geom_line(data = average_length_KO, aes(time*0.26, norm_length), color = "red", size = 3)+
  xlab("time (s)")+
  ylab("normalized length")+
  theme_bw()

average_length_WT_unnorm = aggregate(WT_junction_all$length, by = list(WT_junction_all$time), mean)
names(average_length_WT_unnorm) = c("time", "length") 

average_length_KO_unnorm = aggregate(KO_junction_all$length, by = list(KO_junction_all$time), mean)
names(average_length_KO_unnorm) = c("time", "length") 


ggplot()+
  geom_line(data = WT_junction_all, aes(time*0.26, length, fill = factor(cell_stack)), color = "lightblue")+
  geom_line(data = KO_junction_all, aes(time*0.26, length, fill = factor(cell_stack_replicate)), color = "pink1")+
  geom_line(data = average_length_WT_unnorm, aes(time*0.26, length), color = "#009ACD", size = 3)+
  geom_line(data = average_length_KO_unnorm, aes(time*0.26, length), color = "red", size = 3)+
  xlab("time (s)")+
  ylab("length")+
  theme_bw()

length_time0_KO = KO_junction_all$length[KO_junction_all$time==0]
length_time10_KO = KO_junction_all$length[KO_junction_all$time==10]

# time between the start of two images is 0.26 s

speed_KO = (length_time10_KO - length_time0_KO)/2.6

length_time0_WT = WT_junction_all$length[WT_junction_all$time==0]
length_time10_WT = WT_junction_all$length[WT_junction_all$time==10]

speed_WT = (length_time10_WT - length_time0_WT)/2.6

boxplot(speed_KO, speed_WT, names=c("KO", "WT"))

norm_speed_KO = (KO_junction_all$length_norm_init_length[KO_junction_all$time==10]-1)/2.6
norm_speed_WT = (WT_junction_all$length_norm_init_length[WT_junction_all$time==10]-1)/2.6
boxplot(norm_speed_KO, norm_speed_WT, names=c("KO", "WT"))

speeds = c(speed_KO, speed_WT)
norm_speed = c(norm_speed_KO, norm_speed_WT)
speed_names = c(rep("KO", length(norm_speed_KO)), rep("WT", length(norm_speed_WT)))

junction_speed = data.frame(speeds, norm_speed, speed_names)

ggplot(junction_speed, aes(speed_names, speeds, fill = speed_names))+
  geom_boxplot(show.legend = F, outlier.alpha = 0)+
  geom_jitter(width = 0.2, height = 0, show.legend = F)+
  labs(y = "vertex speed (µm/s)")+
  theme_classic()

ggplot(junction_speed, aes(speed_names, norm_speed*100, fill = speed_names))+
  geom_boxplot(show.legend = F, outlier.alpha = 0)+
  geom_jitter(width = 0.2, height = 0, show.legend = F)+
  labs(y = "vertex normalized speed (%/s)")+
  theme_classic()

ggplot(junction_speed, aes(speed_names, norm_speed*100, color = speed_names))+
  #geom_boxplot(show.legend = F, outlier.alpha = 0)+
  geom_jitter(width = 0.2, height = 0, show.legend = F)+
  stat_summary(fun = "mean", geom = "crossbar", show.legend = FALSE, width = 0.8)+
  stat_summary(geom = "errorbar",
               width = 0.7,
               fun.min = mean_sd_plus,
               fun.max = mean_sd_minus, show.legend = F)+
  labs(y = "Vertex normalized speed (%/s)")+
  theme_classic()


ggplot(junction_speed, aes(speed_names, speeds, fill = speed_names))+
  geom_boxplot(show.legend = F, outlier.alpha = 0)+
  geom_jitter(width = 0.2, height = 0, show.legend = F)+
  labs(y = "vertex speed (µm/s)")+
  theme_classic()
