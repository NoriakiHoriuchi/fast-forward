#!/bin/bash
## Fast Forward

# Check if the Heroku account exists.


# Check if the GitHub account exists.


# Check if the project name is available at Heroku.


# Check if the project name is available at GitHub.


# Create a new Play Framework project with sbt.
sbt new playframework/play-scala-seed.g8 --name=$1

cd $1

# Remove Gradle
rm build.gradle 
rm -rf gradle/
rm gradlew
rm gradlew.bat 

# Add settings for Play's secret
echo "play.http.secret.key=\"changeme\"" >> conf/application.conf 
echo "play.http.secret.key=\${?APPLICATION_SECRET}" >> conf/application.conf

# Add security settings
echo "play.filters.hosts.allowed = [\"$1.herokuapp.com\", \"localhost:9000\"]" >> conf/application.conf
echo "play.filters.headers.contentSecurityPolicy = \"default-src 'self' $1.herokuapp.com\"" >> conf/application.conf

# Initialize as a new Git repository.
git init .
git commit -m "first commit"

git add .
git commit -m "create a new Play Framework project"

# Create repository at GitHub.
hub create -p $1


# Push to GitHub.
git push -u origin master

# Create project and push to Heroku.
heroku apps:create $1

# Generate Play's secret for Heroku
PLAY_SECRET=$(sbt playGenerateSecret | grep "secret")
PLAY_SECRET=$(echo ${PLAY_SECRET##* })

# TODO Set Play's secret.
echo $PLAY_SECRET
heroku config:set APPLICATION_SECRET=$PLAY_SECRET

# Push to Heroku
git push heroku master
