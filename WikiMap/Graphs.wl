(* ::Package:: *)

WC[Optional[text_String, "https://en.wikipedia.org/wiki/Cat"]] :=
 Module[{excludewords, a0, a1, a2, a3, a5, a6, a7, a8},
  excludewords = {"consider", "include", "suggest", "isbn", "oxford", "university", "press", "archive", "retrieve", "pmid", "pdf",     "doi", "main", "list", "language", "refer", "link", "article", "content", "wikipedia", "encyclopedia", "year", "bc", "ago", ".",     ToString /@ Range[0, 9]};
  a0 = TextWords /@ TextSentences[ToLowerCase@DeleteStopwords@Import[text]][[9 ;; -9]];
  a1 = StringReplace[#, a__ ~~ "'" : > a] & /@ DeleteCases[WordStem /@  DeleteCases[#, (a2_ /; StringLength[a2] == 1) | (a2_ /; StringContainsQ[a2, excludewords])] & /@ a0, a_ /; Length[a] < 3];
  a3 = Graph[Flatten[(UndirectedEdge @@@DeleteCases[DeleteDuplicates[Subsets[#, {2}]], {a_, a_}]) & /@a1]];
  a5 = Subgraph[a3, FindGraphCommunities[a3][[1]]];
  a6 = SortBy[VertexList[a5], Length[AdjacencyList[a5, #]] &][[-100 ;;]];
  a7 = (# -> Length[AdjacencyList[a5, #]]) & /@ a6;
  a8 = Thread[a6 -> Flatten@Nearest[Flatten[a0], a6, 1, DistanceFunction -> (If[StringContainsQ[#2, #1], 0, 1] &)]];
  WordCloud[Association[a7 /. a8]]]
