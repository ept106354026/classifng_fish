fish <- read.table("file:///C:/Users/Asus/Documents/classifng_fish/fish.data.txt", header = T)
library(rpart)
fish.control <- rpart.control(minisplit = 10, minbucket = 3, xval = 0)
fish.treeorig<-rpart(Species~Weight+L1+L2+L3+Height+Width,data=fish,method="class",control=fish.control)
#Let’s now plot the tree:
plot(fish.treeorig)
text(fish.treeorig)
#Also check out the complexity parameter (CP):
printcp(fish.treeorig)
summary(fish.treeorig)

fish.prunetree <- prune.rpart(fish.treeorig,cp=0.02)
plot(fish.prunetree)
text(fish.prunetree)
L21<-fish$L2-fish$L1
L32<-fish$L3-fish$L2
L31<-fish$L3-fish$L1
newfish<-cbind(fish,L21,L32,L31)
newfish.treenew<-rpart(Species~., data=newfish,method="class",parms=list(split="information"),control=fish.control)
printcp(newfish.treenew)
plot(newfish.treenew)
text(newfish.treenew)
fish.control <- rpart.control(minbucket=3,minsplit=10,xval=148)
newfish.treenewcv <- rpart(Species~., data=newfish,method="class",parms=list(split="information"),control=fish.control)
printcp(newfish.treenewcv)
newfish.test<-read.table("file:///C:/Users/Asus/Documents/classifng_fish/fish_test.data.txt",h=T)
L31<-newfish.test$L3- newfish.test$L1
L32<-newfish.test$L3- newfish.test$L2
L21<-newfish.test$L2- newfish.test$L1
newfish.test<-cbind(newfish.test,L21,L32,L31)
newfish.tpred<-predict(newfish.treenewcv,newfish.test)
newfish.tpred
library(MASS)
newfish.lda<-lda(Species~.,data=newfish)
newfish.lda<-lda(Species~Weight+L1+Height+Width+L21+L32,data=newfish)
newfish.lda
newfish.ldapred<-predict(newfish.lda,newfish[,-1])
table(newfish$Species,newfish.ldapred$class)
newfish.ldacv<-lda(Species~Weight+L1+Height+Width+L21+L32,data=newfish,CV=T)
table(newfish$Species,newfish.ldacv$class)
#
eqscplot(newfish.ldapred$x,type="n",xlab="1st LD",ylab="2nd LD")
fish.species <- c(rep("B",33),rep("W",5),rep("R",18),rep("Pa",10),rep("S",12),rep("Pi",16),rep("Pe",54))
fish.colors <- c(rep(1,33),rep(2,5),rep(3,18),rep(4,10),rep(5,12),rep(6,16),rep(7,54))
text(newfish.ldapred$x[,1:2],fish.species,col=fish.colors)
#To predict the class identities of the new data points we use:
newfish.ldatest<-predict(newfish.lda,newfish.test)
newfish.ldatest$class
#We see that the results agree with those obtained from the classification tree.
#Let us examine how to apply QDA to this dataset.

#newfish.qda<-qda(Species~.,data=newfish)
newfish.q<-read.table("file:///C:/Users/Asus/Documents/classifng_fish/newfish.qdata.txt",h=T)
#newfish.qda<-qda(Species~.,data=newfish.q)
newfish.qda<-qda(Species~Weight+L1+Height+Width+L21+L32,data=newfish.q)
newfish.qdapred<-predict(newfish.qda,newfish.q)
predict(newfish.qda,newfish.test)$class
newfish.qda<-qda(Species~Weight+L1+Height+Width+L21+L32,data=newfish.q,CV=T)
table(newfish.q$Species,newfish.qda$class)
library(class)
newfish.knn<-knn(newfish[,2:10],newfish[,2:10],newfish[,"Species"],k=3,prob=T)
table(newfish$Species,newfish.knn)
#We see that the apparent error rate for k = 3 is about 21%. For k = 2, we have:
newfish.knn<-knn(newfish[,2:10],newfish[,2:10],newfish[,"Species"],k=2,prob=T)
table(newfish$Species,newfish.knn)
#這是新的
