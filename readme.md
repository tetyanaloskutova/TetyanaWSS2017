# WikiClassify: Content- and Link-Based Classification

Project by Tetyana Loskutova

WikiClassify project is a Wolfram Language implementation of the Iterative Classification Algorithm (ICA) for semantic topic classification for Wikipedia.


## Statement of the problem
Knowledgedomans,suchasWikipedia,containmeaningstructures,whicharebasedbothonthemeaningofthechosenwordsandonthelinkagesbetweensentences,
paragraphs,articles,andsoon.Thegoalofthisprojectistocreateatopicclassifierthatcantakeintoconsiderationboththecontentofanarticleanditslinkstotheother
articles.

## Solution outline
The solution is based on the Iterative Classification Algorithm [1] . The ICA works in the following steps:
1. Assign "guessed" categories to data using Content Classifier.
2. Compare the categories with the nearest neighbours (linked articles) using Relational Classifier.
3. Retrain the Relational Classifier based on the Content Classifier categories and record the adjustments in the Conditional map.
The use of the ICA works as an optimization algorithm for finding the minimum mismatch between linked categories.
In this particular implementation, the full ICA was not completed. Instead, the outputs of the Content and Relational classifiers were used based on their estimated accuracies. The use of the two classifiers also allowed to account for the dynamically changing content of Wikipedia and the need for creation of new categories labels: the cases of low probability conflicting classifications were treated as an indication for the need of new labels.


### References

[1] Lu, Q., & Getoor, L. (2003). Link-based classification. In Proceedings of the 20th International Conference on Machine Learning (ICML-03) (pp. 496-503). 

## Running the code
The solution is not yet at the stage to be run automatically. 
The notebooks should be executed section by section. It is necessary to change the paths in Import/Export functions.
CollectData.nb is used to create content features and link features from Wikipedia. The amount of test data as well as the starting article may be changed in the code.
IterativeClassifier.nb runs with the data created by CollectData.nb or using the existing data files: wiki.comtent, wiki.cites, and wikifeature.content
ClassifierSandbox.nb runs on the test data (cora.cites and cora.content)


