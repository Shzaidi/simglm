#' Master simulation function.
#' 
#' Takes simulation parameters as inputs and returns simulated data.
#' 
#' Simulated data is useful for classroom demonstrations and to study 
#' the impacts of assumption violations on parameter estimates, statistical
#' power, or empirical type I error rates.
#' 
#' This function allows researchers a flexible approach to simulate regression
#' models, including single level models and cross sectional or longitudinal
#' linear mixed models (aka. hierarchical linear models or multilevel models).
#' 
#' @param fixed One sided formula for fixed effects in the simulation.  To suppress intercept add -1 to formula.
#' @param random One sided formula for random effects in the simulation. Must be a subset of fixed.
#' @param fixed.param Fixed effect parameter values (i.e. beta weights).  Must be same length as fixed.
#' @param random.param Variance of random effects. Must be same length as random.
#' @param w.var Number of within cluster variables, including intercept if applicable.   
#' Also could be number of level one covariates for cross-sectional clustering.
#' @param cov.param List of mean and variance for fixed effects. Does not include intercept, time, or 
#' interactions. Must be same order as fixed formula above.
#' @param n Cluster sample size.
#' @param p Within cluster sample size.
#' @param errorVar Scalar of error variance.
#' @param randCor Correlation between random effects.
#' @param rand.dist Simulated random effect distribution.  Must be "lap", "chi", "norm", "bimod", 
#' "norm" is default.
#' @param err.dist Simulated within cluster error distribution. Must be "lap", "chi", "norm", "bimod", 
#' "norm" is default.
#' @param serCor Simulation of serial correlation. Must be "AR", "MA", "ARMA", or "ID", "ID" is default.
#' @param serCorVal Serial correlation parameters. A list of values to pass on to arima.sim.
#' @param data.str Type of data. Must be "cross", "long", or "single".
#' @param num.dist Number of distributions for bimodal random variables
#' @export 
#' @examples
#' \donttest{
#' # generating parameters for single level regression
#' fixed <- ~1 + act + diff + numCourse + act:numCourse
#' fixed.param <- c(2, 4, 1, 3.5, 2)
#' cov.param <- list(c(0, 4), c(0, 3), c(0, 3))
#' n <- 150
#' errorVar <- 3
#' err.dist <- "norm"
#' temp.single <- sim.reg(fixed = fixed, fixed.param = fixed.param, cov.param = cov.param, 
#' n = n, errorVar = errorVar, err.dist = err.dist, data.str = "single")
#' # Fitting regression to obtain parameter estimates
#' summary(lm(sim.data ~ 1 + act + diff + numCourse + act:numCourse, data = temp.single))
#' 
#' # Longitudinal linear mixed model example
#' fixed <- ~1 + time + diff + act + time:act
#' random <- ~1 + time + diff
#' fixed.param <- c(4, 2, 6, 2.3, 7)
#' random.param <- c(7, 4, 2)
#' w.var <- 3
#' cov.param <- list(c(0, 1.5), c(0, 4))
#' n <- 150
#' p <- 30
#' errorVar <- 4
#' randCor <- 0
#' rand.dist <- "norm"
#' err.dist <- "norm"
#' serCor <- "ID"
#' serCorVal <- NULL
#' data.str <- "long"
#' temp.long <- sim.reg(fixed, random, fixed.param, random.param, w.var, cov.param, 
#' n, p, errorVar, randCor, rand.dist, err.dist, serCor, serCorVal, data.str)
#' 
#' ## fitting lmer model
#' library(lme4)
#' lmer(sim.data ~ 1 + time + diff + act + time:act + (1 + time + diff | clustID), 
#' data = temp.long)
#' }
sim.reg <- function(fixed, random, fixed.param, random.param, w.var, cov.param, n, p, errorVar, randCor, 
                         rand.dist, err.dist, serCor, serCorVal, data.str, num.dist) {
  
  if(data.str == "single"){
    sim.reg.single(fixed, fixed.param, cov.param, n, errorVar, err.dist, num.dist)
  } else {
    sim.reg.nested(fixed, random, fixed.param, random.param, w.var, cov.param, n, p, errorVar, randCor, 
                   rand.dist, err.dist, serCor, serCorVal, data.str, num.dist)
  }
  
}
