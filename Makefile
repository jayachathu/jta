JAVA	=	java
JAR	=	jar
JAVAC	=	javac
DEBUG	=	-g -deprecation
JFLAGS	=	-classpath $(CLASSPATH):.
SRCDIR	=	de

.SUFFIXES:	.java .class

# compile java files to class
.java.class:
	$(JAVAC) $(DEBUG) $(JFLAGS) $<

#
# major rules to create files
#
all: 	app doc jar
	
doc:	app
	-mkdir doc
	javadoc -d doc -version -author \
	  `find de/mud -type d -print | \
	    grep -v CVS | grep -v '^de/mud$$' | sed 's/\//./g'`

run:	app
	$(JAVA) $(JFLAGS) de.mud.jta.Main

jar:	app
	-mkdir jar
	$(JAR) cvf jar/jta.jar `find $(SRCDIR) -name *.class` \
	  `find $(SRCDIR) -name defaults.\*`

dist:	clean doc
	-mkdir jar
	(cvs -Q -d $(CVSROOT) export -D now -d telnet-v20 telnet && \
	  $(JAR) cvMf jar/jta-20-source.jar telnet-v20; rm -rf telnet-v20)
# 
# application dependencies
#
app:
	@find $(SRCDIR) -name \*.java | sed 's/java$$/class/' | xargs make

clean:
	-find . -name *.class -print | xargs rm > /dev/null 2>&1
	-find . -name *~ -print | xargs rm > /dev/null 2>&1
