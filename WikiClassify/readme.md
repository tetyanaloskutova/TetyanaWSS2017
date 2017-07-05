# WikiClassify: Content- and Link-Based Classification

Project by Tetyana Loskutova

The goal of this project was to create an algorithm that would be able to describe the scope of knowledge covered in Wikipedia. The task was approached as a classification problem. 

## Problem

In the case of Wikipedia, classification is difficult mainly for two reasons:

 1. The scope keeps changing as new articles are being added and new linkages between articles are created; 
 2. Similar vocabularies may be used to describe totally different concepts in different contexts.

When a new article is added, simple classification based on content is may be insufficient because it is difficult to categorize the content that is not similar to the previously learned. Links provide immediate help as it is safe to assume that a large portion of the linked articles discuss related and similar issues. 

## Solution outline

To include both content and links, I based my solution on Iterative Classification Algorithms whose basic idea is the minimization of dissimilarity in the categories of closely linked articles. The implementation involved two classifiers: 

 1. A basic Content Classifier used the most frequently used words as a feature vector
 2. A Relational Classifier used the occurrence of categories in the linked articles as a feature vector. 
In the following sections, data preparation/feature extraction methods for each classifier is explained. Then the code for each classifier is outlined.  Finally, the combined application of the two classifiers and the benefits of such combination are discussed. In conclusion, the outline for the future development of this project is detailed.

## Classifiers

In the ICA, the initial content categories or labels are “guessed” and then further improved. The “guessing” or initial approximation is used for training the relational and the content classifiers. 
In the project, the training data was extracted starting from a randomly selected article (“Activism” in this particular analysis) and collecting further linked articles until the sample size of ~4000 articles was reached. These articles were initially classified for training using:
topicCheck = Classify["FacebookTopic"]

### Relational Classifier feature extraction

> getWikiLinks:=Function[{articleName},""
> linkText=WikipediaData[articleName,"SummaryWikicode"];""
> list=StringCases[linkText,Shortest["[["~~"
> x__"~~"]]"]⧴ToString[x]];""
> list1=DeleteCases[list,_?((StringTake[#,Min[StringLength[#],4]]=="File"||StringTake[#,Min[StringLength[#],4]]=="Imag")&)];""
> Clear[strListClear];""
> strListClear:=(If[StringPosition[#,"|"]≠{},pos=StringPosition[#,"|"][[1,1]];StringTake[#,pos-1],#])&;""
> listOfLinks=Map[strListClear,list1];""
> listOfLinks=Union[listOfLinks]]

Loop through the links:

> getWikiLinksAndAdd :=   Function[temp = getWikiLinks[#];   
> tempInitialIds =  Table[#, Length[temp]] ;    tempDataLinks0 =
> Transpose[{tempInitialIds, temp}]; {temp,     tempDataLinks0 }]

the results of the function were saved into a file, e.g.:

> *Activism	artivism 
Activism	boycott 
Activism	civic engagement 
Activism	Civil Rights Movement
 ….. and so on.*

This file was further used in the relational classifier.

### Content classifier: Data preparation and feature extraction

For the content classifier, the same articles as in the relational classifier were extracted, however instead of Wikicode, plain text summary was used. The articles were classified using topicCheck classifier created above. Further, a list of most frequent nouns was extracted from each article, combined from all articles into the list of keywords and used to create a feature vector. 

CreateContentFile:= Function[{uniqueArticle}, 
	text = ToString[WikipediaData[uniqueArticle, "SummaryPlaintext"]];
	label = topicCheck[text]; 
	nouns = TextCases[text, "Noun"];
	(*nouns = Pluralize/@ nouns;*)
	nouns = DeleteStopwords[ToLowerCase[nouns]];
	freqnouns=Sort[Counts[nouns], Greater];
	features =If[Length[freqnouns]>=1,Keys[freqnouns][[1]],""];
	{features, label}
	]

Article names, keywords, and labels were saved into wiki.content file. This file was then used to create feature vectors:
finalAllTRead = 
 Import["wiki.content", "Table"]
The features in the feature vector were assigned based on the occurrence of the keyword’s stem in the article’s summary:
For[k1 = 1, k1 <= Length[finalAllTRead], k1++,
 featureVector = Table[0, Length[keywords]];
 kw = ToString[finalAllTRead[[k1, 2]]];
 For[k2 = 1, k2 <= Length[keywords], k2++,
  If[ StringPosition[kw, keywords[[k2]]] != {}, 
   featureVector[[k2]] = 1]];
 finalAllTRead[[k1, 2]] = featureVector]
The feature vector was saved into a separate file:

Export["wikifeature.content", finalAllTRead[[All, 2]], "Table"]

### Content Classifier

Content classifier was trained using wiki.content and wikifeature.content data and logistic regression:
localClf=Classify[selectedFeatures→selectedLabels,Method→"LogisticRegression"];

### Relational Classifier

The relational classifier was also based on logistic regression and the data stored in wiki.cites file. However, before the data in the file could be used for regression purposes, it had to be transformed into suitable feature arrays and labels. The feature array had the length equal to the number of unique labels and was constructed based on the occurrence of a particular label in the article’s neighbours (the articles linked to the current):

aggregate[conditionalMap_, vertice_, 
  features1_] :=(*returns a matrix: rows equal to training sample, \
columns equal to dataLabels equal to the amount of dataLabels in the \
find all connected indices*)(
  tempFeatures = List[features1][[1]];
  neighboursR = Select[dataLinks, Part[#, 1] == vertice &];
  neighboursR = neighboursR[[All, 2]];
  neighboursL = Select[dataLinks, Part[#, 2] == vertice &];
  neighboursL = neighboursL[[All, 1]];
  neighbours = Join[neighboursL, neighboursR];
  For[j = 1, j <= Length[neighbours], j++, 
   node = neighbours[[j]];
   labelToReinforce = Select[conditionalMap, Part[#, 1] == node &];
   If[labelToReinforce != {}, 
    k = Flatten[
       Position[uniqueLabels, labelToReinforce[[All, 2]][[1]]]][[1]];
    If[features1[[k]] >= 0, tempFeatures[[k]] ++];
    ];
   ];
  tempFeatures
  )

For [i = 1, i <= Length[trainIds], i++, (
   selectedFeatures1 = 
    aggregate[conditionalMap, selectedNodes[[i]], 
     selectedFeatures[[i]]];
   selectedFeatures[[i]] = selectedFeatures1;
   )];
Further, the labels and the feature arrays were used in the logistic regression:

relClf = Classify[selectedFeatures -> selectedLabels, 
  Method -> "LogisticRegression"]

### Combining the Classifiers

In the ICA, combining classifiers is used to find the optimum labels by adjusting the labels in the relational classifier in an iterated fashion until the least label diversity in the directly linked articles is reached. This was not fully implemented in the project, however, the availability of two different classifiers allowed to select the classifier with higher accuracy and choose the answer with higher probability:

relLabel = relClf[testFeature][[1]]
relClf[testFeature, "TopProbabilities"]
relLabelProbaility = 
 relClf[testFeature, "TopProbabilities"][[1]][[1, 2]]

localLabel = localClf[dataFeatures[[1]]]
localLabelProb = 
 localClf[dataFeatures[[1]], "TopProbabilities"][[1, 2]]

The cases where the prediction of the Content Classifier differed from the Relational classifier, and both classifiers were not confident of the answer were treated as an indication for the need of a new label:

If[(localLabel != relLabel && localLabelProb < 0.5 && 
   relLabelProbaility < 0.5), 
 newLabel = 
  topicCheck[ToString[getText[dataContent[[dataIds[[58]]]][[1]]]] ];
 newId = Max[dataIds] + 1;
 AppendTo[conditionalMap, {newId, newLabel}];
 newFeatures = {(*recreates the feature vectors*)}]

## Future development

The most obvious future development is the implementation of the full ICA. It would also require improvements in the data preparation procedures and the automation of the feature vectors update when a new label is created.
The current solution was based on links in Wikicode, however, it can be extended to the analysis of Natural text as the linkages in text may be inferred from phrases like “this means that” or “this explains that” and so on. The extension of the algorithm to the meaning extraction from the natural text should be the next goal of this project.

The code for this analysis is available on GitHub: [WikiClassify][1]


  [1]: https://github.com/tetyanaloskutova/TetyanaWSS2017/tree/master/WikiClassify