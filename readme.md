# WikiMap 

Project by Tetyana Loskutova

WikiMap project is a Wolfram Language implementation of  a semantic topic map for Wikipedia. 


## Statement of the problem
Wikipedia contains a large amount of knowledge, which can be associated with different domains. Given the amount of data, it is impossible to grasp the scope of the knowledge coverage without some kind of automation. The goal of this project is to group the articles by subject domains and display them on a topic map, which will allow to estimate meaning-based connections between domains.

## Solution outline
The core of the solution is a zoomable graph with the main nodes corresponding to the knowledge domains (TODO: what are knowledge domains? Can they be approximated by wikipedia portals or categories? Perhaps, classification by article title and category).
The main nodes are interlinked and the strength of the link is proportional to the number of cross-references between domains.
Within main nodes, further zoom is permitted to open topic maps of the node (same structure as the top level).

## ICA. Theory behind the solution
We experiment using simple classification algorithm in an iterative fashion to improve
classification accuracy by exploiting relational information in the data. The hypothesis underlying this approach
is that if two objects are related, inferring something about one object can assist inferences about the other
This forms the basis for Iterative Classification Algorithm (ICA).
When testing an estimator, one needs a reliable metric to evaluate its performance. Using the same data for
training and testing is not acceptable because it leads to overly confident model performance, a phenomenon
also known as overfitting. Crossvalidation
is a technique that allows one to reliably evaluate an estimator
on a given dataset. It consists in iteratively fitting the estimator on a fraction of the data, called training set,
and testing it on the leftout
unseen data, called test set. Several strategies exists to partition the data. For
example, kfold
crossvalidation
consists in dividing (randomly or not) the samples in k subsets: each subset is
then used once as testing set while the others k − 1 subsets are used to train the estimator. This is one of the
simplest and most widely used crossvalidation
strategies. The parameter k is commonly set to 5 or 10.
For a given model, the scores on the various test sets can be averaged to give a quantitative score to assess
how good the model is. Maximizing this crossvalidation
score offers a principled way to set hyperparameters
and allows to choose between different models. This procedure is known as model selection.
     

## TODO: (* how to run your code *)

## TODO: (* examples, code documentation, etc *)
Process section is the implementation of ICA.
First a train data is classified using a content classifier. Then it is classified using a relational classifier. If the accuracy is low, the relational classifier is then given content classifier labels to train on.

