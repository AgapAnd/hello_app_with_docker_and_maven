@echo off
cls
echo "Hello World" application
echo.


if not exist logs (
	md logs
)

set log_file=logs/hello_app.log

rem: > %log_file%


echo Step 1. Checking necessary conditions for compiling and running app...
echo.
echo [%date%, %time:~,-3%] INFO Step 1. Checking necessary conditions for compiling and running application >> %log_file%

if not exist ../application/src/main/java/ru/agapov/app/Hello.java (
	echo File "Hello.java" was not found
	echo [%date%, %time:~,-3%] ERROR File "Hello.java" was not found >> %log_file%
	goto end
)
echo [%date%, %time:~,-3%] INFO File "Hello.java" - exists >> %log_file%

if not exist ../application/pom.xml (
	echo File "pom.xml" was not found
	echo [%date%, %time:~,-3%] ERROR File "pom.xml" was not found >> %log_file%
	goto end
)
echo [%date%, %time:~,-3%] INFO File "pom.xml" - exists >> %log_file%


echo Step 2. Packaging application... (It can take more than 1 minute)
echo.
echo [%date%, %time:~,-3%] INFO Step 2. Packaging application. >> %log_file%

docker run --rm -it -v "%cd%/..:/mnt" maven:3.6.3-openjdk-8-slim /usr/bin/mvn -q -f /mnt/application/pom.xml clean package
echo [%date%, %time:~,-3%] INFO File "Hello.jar" was packaged >> %log_file%


echo Step 3. Running application...
echo.
echo [%date%, %time:~,-3%] INFO Step 3. Running application >> %log_file%

docker run --rm -it -v "%cd%/..:/mnt" maven:3.6.3-openjdk-8-slim /usr/local/openjdk-8/bin/java -jar /mnt/application/target/hello-app-1.0-SNAPSHOT.jar
echo [%date%, %time:~,-3%] INFO Application was successfully runned >> %log_file%
echo.


: end
pause