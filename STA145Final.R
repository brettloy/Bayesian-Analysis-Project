library("ash")

# Load dataset
Demographic <- read.table("~/Desktop/STA CLASSES/STA 145/Final Project/Demographic.txt")

# Rename columns
colnames(Demographic) <- c('ID','County','State','Land_Area','Total_Population','Population_18to34',
                           'Population_65','Physicians','Beds','Y_i','Graduate_Highschool','Graduate_Bachelor',
                           'Below_Poverty','Unemployment','Capita_Income','Personal_Income','Geographic_Region')

# Log-transform serious crimes (Y_i)
Demographic$Log_Y_i <- log(Demographic$Y_i)

# Correlation Matrix
cor_matrix <- cor(Demographic[, c("Log_Y_i", "Total_Population", "Land_Area", "Beds", "Personal_Income", "Unemployment")])
print(cor_matrix)


cor(Demographic[, c("Log_Y_i", "Graduate_Highschool", "Graduate_Bachelor", 
                    "Capita_Income", "Physicians", "Beds")])
cor(Demographic[, c("Log_Y_i", "Land_Area", "Population_18to34", "Population_65", "Personal_Income")])


# Scatterplot Matrix
pairs(Demographic[, c("Log_Y_i", "Graduate_Bachelor", "Personal_Income", "Unemployment", "Capita_Income")],
      main = "Scatterplot Matrix of Log(Serious Crimes) and Predictors")

# Linear Regression Model (Using Capita_Income and Graduate_Bachelor as Predictors)
model_r <- lm(Log_Y_i ~ poly(Capita_Income, 2), data = Demographic)
summary(model_r)


# Plot Regression Results (Graduate_Bachelor vs. Log_Y_i)
plot(Demographic$Capita_Income, Demographic$Log_Y_i, pch=19,
     xlab="Capita Income", ylab="Log(Serious Crimes)", main="Regression: Log(Serious Crimes) vs. Capita_Income")
abline(model_r, col="red", lwd=2)

# Boxplot for Geographic Region
boxplot(Log_Y_i ~ Geographic_Region, data = Demographic,
        main = "Serious Crimes by Geographic Region",
        xlab = "Geographic Region", ylab = "Log(Serious Crimes)")

summary(Demographic[, c("Log_Y_i", "Total_Population", "Land_Area", "Beds", "Personal_Income", "Unemployment")])




final_model <- lm(Log_Y_i ~ Personal_Income, data = Demographic)
summary(final_model)
anova(final_model, model_r)
# Stick with model c because it is much better
# Plot Regression Results (Capita_Income vs. Log_Y_i)
plot(Demographic$Personal_Income, Demographic$Log_Y_i, pch=19,
     xlab="Personal Income", ylab="Log(Serious Crimes)", main="Regression: Log(Serious Crimes) vs. Personal_Income")
abline(final_model, col="red", lwd=2)




# ======================================================
# Bayesian Estimation via MCMC (Monte Carlo Simulation)
# ======================================================

# Define variables
n <- nrow(Demographic)
X <- cbind(rep(1, n), Demographic$Personal_Income)  # Design matrix using Personal_Income
p <- ncol(X)
y <- Demographic$Log_Y_i

# Define prior parameters
beta_0 <- rep(0, p)  # Prior mean for beta
Sigma_0 <- diag(1000, p)  # Prior covariance matrix
nu_0 <- 1  # Prior degrees of freedom for sigma^2
sigma2_0 <- 1  # Prior scale parameter for sigma^2

# MCMC Setup
S <- 5000  # Number of iterations

# Convenient quantities
iSigma_0 <- solve(Sigma_0)  # Inverse of prior covariance matrix
XtX <- t(X) %*% X  # X'X matrix

# Store MCMC samples in these objects
beta_post <- matrix(nrow = S, ncol = p)
sigma2_post <- rep(NA, S)

# Initial value for sigma^2
set.seed(1)
sigma2 <- var(residuals(lm(Log_Y_i ~ Personal_Income, data = Demographic)))

# Gibbs Sampling
for (scan in 1:S) {
  # Compute posterior mean and variance
  V_beta <- solve(iSigma_0 + XtX / sigma2)
  E_beta <- V_beta %*% (iSigma_0 %*% beta_0 + t(X) %*% y / sigma2)
  beta <- t(rmvnorm(1, E_beta, V_beta))
  
  # Update sigma^2
  nu_n <- nu_0 + n
  ss_n <- nu_0 * sigma2_0 + sum((y - X %*% beta)^2)
  sigma2 <- 1 / rgamma(1, nu_n / 2, ss_n / 2)
  
  # Save results
  beta_post[scan, ] <- beta
  sigma2_post[scan] <- sigma2
}

# Posterior summaries
par(mfrow = c(2, 2))

hist(beta_post[, 1], xlab = expression(beta[0]), main = "Posterior of Intercept")
abline(v = final_model$coefficients[1], col = 2, lwd = 2)

hist(beta_post[, 2], xlab = expression(beta[1]), main = "Posterior of Personal_Income")
abline(v = final_model$coefficients[2], col = 2, lwd = 2)

hist(sigma2_post, xlab = expression(sigma^2), main = "Posterior of Sigma^2")
abline(v = summary(final_model)$sigma^2, col = 2, lwd = 2)

# Plot posterior beta values
plot(beta_post[, 1], beta_post[, 2], main = "Joint Posterior of Beta_0 and Beta_1")

# ===========================================
# Compute 95% Confidence and Credible Intervals
# ===========================================

# Frequentist 95% confidence intervals
conf_intervals <- confint(final_model, level = .95)
print("95% Confidence Intervals:")
print(conf_intervals)

# Bayesian 95% credible intervals
credible_intervals <- apply(beta_post, 2, quantile, probs = c(0.025, 0.975))
print("95% Bayesian Credible Intervals:")
print(credible_intervals)

# Extract p-values from the updated frequentist model
p_values <- summary(final_model)$coefficients[, 4]
print("Frequentist p-values:")
print(p_values)

# Compute Bayesian probabilities for the updated model
bayesian_p <- colMeans(beta_post > 0)  # Probability that beta_j > 0
bayesian_p <- 2 * pmin(bayesian_p, 1 - bayesian_p)  # Two-tailed test

print("Bayesian Posterior Probabilities (two-tailed):")
print(bayesian_p)

# ============================
# Residual Analysis
# ============================
residuals_r <- residuals(final_model)
plot(final_model) 

