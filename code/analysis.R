# analysis.R

#==============================================
# Setup
#==============================================

# install packages if needed 
# install.packages(c("lme4","lmerTest","emmeans","ggplot2","gridExtra"))

# load libraries
library(lme4)
library(lmerTest)
library(emmeans)
library(ggplot2)
library(gridExtra)

# Read the data
data <- read.csv("../data/music.csv")
head(data)

# Factor conversion
data$Platform       <- as.factor(data$Platform)
data$CustomerStatus <- as.factor(data$CustomerStatus)
data$Observer       <- as.factor(data$Observer)

# Subset for AdCount model (exclude Apple, as it has 0 ads)
data_ads <- subset(data, Platform != "Apple")

#==============================================
# Helper functions
#==============================================

# --- Function to create diagnostic plots ---
create_diagnostic_plots <- function(model, filename) {
  
  png(filename, width = 800, height = 400)
  par(mfrow = c(1, 2))
  
  # (1) Residuals vs Fitted
  plot(
    x = fitted(model),
    y = resid(model),
    xlab = "Fitted values",
    ylab = "Residuals",
    main = "Residuals vs Fitted"
  )
  abline(h = 0, lty = 2)
  
  # (2) Normal Q–Q plot
  qqnorm(resid(model), main = "Normal Q–Q Plot")
  qqline(resid(model))
  dev.off()
  
  cat("Diagnostic plots saved to", filename, "\n")
}

# --- Function to create interaction plots ---
create_interaction_plot <- function(model, data, response_var, filename, 
                      main_title = paste("Interaction Plot for", response_var),
                      x_var1 = "Platform", x_var2 = "CustomerStatus", 
                      group_var1 = "CustomerStatus", group_var2 = "Platform") {
  
  # Create first panel - x_var1 on x-axis, grouped by group_var1
  p1 <- ggplot(data, aes_string(x = x_var1, y = response_var, 
                                color = group_var1, 
                                group = group_var1)) +
    geom_jitter(width = 0.1, height = 0, alpha = 0.7) +
    stat_summary(fun = mean, geom = "line", linewidth = 1) +
    stat_summary(fun = mean, geom = "point", size = 3) +
    labs(x = x_var1, y = response_var) + 
    theme_bw()
  
  # Create second panel - x_var2 on x-axis, grouped by group_var2
  p2 <- ggplot(data, aes_string(x = x_var2, y = response_var, 
                                color = group_var2, 
                                group = group_var2)) +
    geom_jitter(width = 0.1, height = 0, alpha = 0.7) +
    stat_summary(fun = mean, geom = "line", linewidth = 1) +
    stat_summary(fun = mean, geom = "point", size = 3) +
    labs(x = x_var2, y = response_var) +
    theme_bw()
  
  # Combine plots with a centered main title
  combined <- grid.arrange(p1, p2, ncol = 2,
              top = grid::textGrob(main_title, 
                    gp = grid::gpar(fontsize = 14, font = 2)))
  
  # Save the combined plot
  ggsave(filename, combined, width = 12, height = 6)
  cat("Interaction plot saved to", filename, "\n")
  
  # Return a list with individual plots and combined plot
  return(list(p1 = p1, p2 = p2, combined = combined))
}

#==============================================
# Model 1: AdCount model (Excluding Apple)
#==============================================

# Fit the mixed effects models
model_ads <- lmer(
  AdCount ~ Platform * CustomerStatus + (1 | Observer),
  data = data_ads
)

# --- anova table ---
anova(model_ads)

# --- Coefficient  ---
summary(model_ads)$coefficients

# --- Test for random effect ---
ranova(model_ads)

# --- Diagnostic Plots ---
create_diagnostic_plots(model_ads, "../output/model_ads_resid.png")

# --- Interaction Plot ---
int_plot <- create_interaction_plot(model_ads, data_ads, 
                                    "AdCount", 
                                    "../output/model_ads_interaction.png")

#==============================================
# Model 2: Satisfaction model
#==============================================
model_sat <- lmer(
  Satisfaction ~ Platform * CustomerStatus + (1 | Observer), 
  data = data
)

# --- anova table ---
anova(model_sat)

# --- Coefficient  ---
summary(model_sat)$coefficients

# --- Test for random effect ---
ranova(model_sat)

# --- Diagnostic Plots ---
create_diagnostic_plots(model_sat, "../output/model_sat_resid.png")

# --- Interaction Plot ---
int_plot <- create_interaction_plot(model_sat, data, 
                                    "Satisfaction", 
                                    "../output/model_sat_interaction.png")

#==============================================
# Model 3: Satisfaction model as a function of ad number
#==============================================
model_sat_ad <- lmer(
  Satisfaction ~ AdCount + Platform * CustomerStatus + (1 | Observer), 
  data = data
)

# --- anova table ---
anova(model_sat_ad)

# --- Coefficient  ---
summary(model_sat_ad)$coefficients

# --- Test for random effect ---
ranova(model_sat_ad)

# --- Diagnostic Plots ---
create_diagnostic_plots(model_sat_ad, "../output/model_sat_ad_resid.png")

# --- Interaction Plot ---
int_plot <- create_interaction_plot(model_sat_ad, data, 
                                    "Satisfaction", 
                                    "../output/model_sat_ad_interaction.png")
