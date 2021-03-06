context("FilterWrapper")

test_that("FilterWrapper", {
  lrn1 = makeLearner("classif.lda")
  lrn2 = makeFilterWrapper(lrn1, fw.method = "chi.squared", fw.perc = 1)
  m = train(lrn2, binaryclass.task)
  expect_true(!inherits(m, "FailureModel"))
  expect_equal(m$features, getTaskFeatureNames(binaryclass.task))
  lrn2 = makeFilterWrapper(lrn1, fw.method = "chi.squared", fw.abs = 0L)
  m = train(lrn2, binaryclass.task)
  expect_equal(getLeafModel(m)$features, character(0))
  expect_true(inherits(getLeafModel(m)$learner.model, "NoFeaturesModel"))
  lrn2 = makeFilterWrapper(lrn1, fw.method = "chi.squared", fw.perc = 0.1)
  res = makeResampleDesc("CV", iters = 2)
  r = resample(lrn2, binaryclass.task, res)
  expect_true(!any(is.na(r$aggr)))
  expect_subset(r$extract[[1]][[1]], getTaskFeatureNames(binaryclass.task))
})

test_that("FilterWrapper univariate (issue #516)", {
  lrn1 = makeLearner("classif.rpart")
  lrn2 = makeFilterWrapper(lrn1, fw.method = "univariate.model.score", fw.perc = 1)
  m = train(lrn2, binaryclass.task)
  expect_true(!inherits(m, "FailureModel"))
  expect_equal(m$features, getTaskFeatureNames(binaryclass.task))
})

test_that("Filterwrapper permutation.importance (issue #814)", {
  lrn1 = makeLearner("classif.rpart")
  lrn2 = makeFilterWrapper(lrn1, fw.method = "permutation.importance", imp.learner = "classif.rpart", fw.perc = 1L, nmc = 1L)
  m = train(lrn2, binaryclass.task)
  res = makeResampleDesc("CV", iters = 2)
  r = resample(lrn2, binaryclass.task, res)
  expect_true(!any(is.na(r$aggr)))
  expect_subset(r$extract[[1]][[1]], getTaskFeatureNames(binaryclass.task))
})

