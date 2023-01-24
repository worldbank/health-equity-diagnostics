library(dplyr)
library(ggplot2)

rwi_path <- 'P:/Data/PROJECTS/Health/output/LBR/test_rwi_adm1.csv'

rwi <- read.csv(rwi_path) 
# %>%
#    filter(WB_ADM1_NA=="Barrobo")

rwi$rwi_cut2 <- factor(rwi$rwi_cut, order = TRUE, levels =c('lowest', 'second-lowest', 'middle', 'second-highest', 'highest'))


health_rwi <- ggplot(data=rwi, aes(x=as.factor(rwi_cut2), y=health_pct, fill=rwi_cut2)) +
  geom_col(width=0.5) +
  theme_minimal() + 
  theme(legend.position="bottom") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  # theme(legend.title = element_blank(), legend.position="none") +
  labs(x="", y="% of pop", title="Population within 2hr. of primary care facility",
       fill="Wealth Quintile") +
  scale_y_continuous(labels = scales::percent) +
  facet_wrap(~WB_ADM1_NA)
  

hospital_rwi <- ggplot(data=rwi, aes(x=as.factor(rwi_cut2), y=hospital_pct, fill=rwi_cut2)) +
  geom_col(width=0.5) +
  theme_minimal() + 
  theme(legend.position="bottom") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  # theme(legend.title = element_blank(), legend.position="none") +
  labs(x="", y="% of pop", title="Population within 2hr. of hospital",
       fill="Wealth Quintile") +
  scale_y_continuous(labels = scales::percent) +
  facet_wrap(~WB_ADM1_NA)


out_path <- 'P:/Data/PROJECTS/Health/output/LBR'
setwd(out_path)

health_rwi
ggsave("Access to Health by RWI adm1.jpeg", width = 8, height = 6)

hospital_rwi
ggsave("Access to Hospital by RWI adm1.jpeg", width = 8, height = 6)


