/*------------------------------*/
/*----  LWDMTXT Start Code  ----*/
/*------------------------------*/
/*----  This code is not used in the course  ----*/
/*----  and is only included to illustrate   ----*/
/*----  SAS Text Miner macro variables.      ----*/



/*----  Make intermediate SVD data available to the SAS Code node  ----*/

%let TM_SVDDATA=1;

/*----  Default definition of roll up term weight calculation  ----*/
/*----  D=Number of Documents containg term                    ----*/
/*----  Values of TM_ROLLWEIGHT:                               ----*/
/*----     1=TermWeight                                        ----*/
/*----     2=log(D+1)*TermWeight                               ----*/
/*----     3=sqrt(D)*TermWeight                                ----*/
/*----     4=D*TermWeight                                      ----*/

%let TM_ROLLWEIGHT=3;

/*----  Minimum number of documents a term must appear in to   ----*/
/*----  be selected as a descriptive term by the Text Cluster  ----*/
/*----  node. The default is 2.                                ----*/

%let TM_MINDESCTERMS=2;

/*----  Newest Macro Variables  ----*/

%let TMM_DOCCUTOFF=0.03;
%let TMM_TERM_CUTOFF_PCT=0.1;
%let TMM_MAX_TOPIC_ANGLE=3;

/*----
TMM_DOCCUTOFF       
   default=.03 
   for any topic, this will be used to determine the default document 
   cutoff for user topics and multi-term topics in the Topic table, 
   higher values will decrease the number of documents assigned to a 
   topic.  For multi-term topics it is multiplied by 2, due to the 
   disparate number of terms in those types of topics.  So for the 
   default of .03, user topics will have a document cutoff of .03 and 
   multi-term topics of .06
TMM_TERM_CUTOFF_PCT
   default=.1
   For any multi-term topic, the initial term cutoff will be set to 
   this value multiplied by the highest weighted term:  For example, 
   if the highest weighted term is 2, the default term cutoff for 
   that multi-term topic will be .2
TMM_MAX_TOPIC_ANGLE
   default=3
   For any single-term topic or multi-term topic, that topic is 
   excluded if its topic vector is within this many degrees of any 
   lower number topic created.

R&D Notes

In TM 4.2 the default value for tmm_max_topic_angle was only 
0.5, which was way too small, even small changes to a topic sometimes 
did not cause that topic to be excluded when rerunning the node, causing 
people to see a new multi-term topic very similar to their new user topic.

Perhaps the same default doc_cutoff should be used in the multi-term 
topics and user topics so that, for example, just changing the name of 
the topic will cause different results when the node is rerun... also, 
that should be used for single-term topics too, but currently is not.
  ----*/

