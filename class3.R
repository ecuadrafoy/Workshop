library(tidyverse)
library(readxl)
library(ggpubr)
library(ggrepel)
library(tidyHeatmap)
library(tidybulk)




#Using ggpubr

compare_means(data = ToothGrowth, len~dose, method='t.test')

ggboxplot(ToothGrowth, x='supp', y='len') + stat_compare_means(method='t.test')

ggboxplot(ToothGrowth, x='supp', y='len') + 
  stat_compare_means(method='t.test', aes(label = ..p.signif..),
                     label.x = 1.5, label.y = 40) +
  facet_grid(~dose)
  
#Making more complex visualizations
data <- read_csv('https://raw.githubusercontent.com/ecuadrafoy/Workshop/master/figure_4a.csv')
head(data)

data_long <- data %>% 
  pivot_longer(cols = -Cytokine,
               names_to = c('thy','status','repeat'),
               names_sep = '_',
               values_to = 'levels') %>% 
  select(-'repeat') %>% 
  unite('status', c('thy', 'status'))

my_comparisons <- list( c("Thy1_minus", "Thy1_plus"))
cytokines <- data_long %>% ggplot(aes(x=status, y=levels, fill=status))+
  stat_summary(fun = 'mean', geom='bar') +
  scale_fill_manual(values=c("grey","black"))+
  facet_wrap(~Cytokine, scales = "free_y")+
  stat_compare_means(comparisons = my_comparisons,
                     method = 't.test', aes(label = ..p.signif..),
                     size=2, paired=TRUE)+
  labs(x='Thy Status',
       y ='Cytokine Levels',
       title = 'Figure 4a',
       subtitle = 'Croft et al, Nature, 2019')+
  theme(strip.background = element_rect(fill = FALSE))+
  theme(panel.background = element_rect(fill = "white"))
  

cytokines

#Working with RNASeq Data
pasilla_raw <- read_csv('https://raw.githubusercontent.com/ecuadrafoy/Workshop/master/pasilla_gene_counts.csv')

pasilla_annotation <- read_csv('https://raw.githubusercontent.com/ecuadrafoy/Workshop/master/pasilla_sample_annotation.csv')

pasilla_tt <- pasilla_dataset %>%  tidybulk(sample, transcript, count)

pasilla_scaled <- pasilla_tt %>% scale_abundance(factor_of_interest = condition)

pasilla_scaled

#Performing PCA
pasilla_scal_PCA <- pasilla_scaled %>% reduce_dimensions(method='PCA')

pasilla_scal_PCA %>% select(transcript, PC1, PC2)

pasilla_scal_PCA %>% pivot_sample()

pasilla_scal_PCA %>%
  pivot_sample() %>%
  ggplot(aes(x=PC1, y=PC2, colour=condition, shape = type)) +
  geom_point() +
  geom_text_repel(aes(label=sample), show.legend = FALSE) + #From ggrepel package
  theme_bw()

#Plotting a heatmap
heatmap <- pasilla_scaled %>%
  # filter lowly abundant
  filter(!lowly_abundant) %>%
  # extract 500 most variable genes
  keep_variable( .abundance = count_scaled, top = 500) %>% #keep_variable allows to extract the most variable genes
  # create heatmap
  heatmap(
    .row = transcript,
    .column = sample,
    .value = count_scaled,
    annotation = condition,
    palette_value = circlize::colorRamp2(c(-2, -1, 0, 1, 2), viridis::magma(5))
  )

heatmap



#Differential Gene Expression
pasilla_de <- pasilla_tt %>% 
  test_differential_abundance(~ condition + type)

pasilla_de


pasilla_de %>%
  filter(significant == TRUE) %>%
  summarise(num_de = n_distinct(transcript))

top_pasilla <-
  pasilla_de %>%
  pivot_transcript() %>%
  arrange(PValue) %>%
  head

top_pasilla

topgenes_symbols <- top_pasilla %>% pull(transcript)

pasilla_de %>%
  keep_abundant() %>%
  pivot_transcript() %>%
  
  # Subset data
  mutate(significant = FDR<0.05 & abs(logFC) >=3) %>%
  mutate(transcript = ifelse(significant, as.character(transcript), NA)) %>%
  
  # Plot
  ggplot(aes(x = logCPM, y = logFC, label=transcript)) +
  geom_point(aes(color = significant)) +
  geom_text_repel() +
  scale_color_manual(values=c("black", "#e11f28")) +
  scale_size_discrete(range = c(0, 10)) +
  theme_bw()
