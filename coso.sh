
function cosoBoot() {
  echo "Starting Docker..."
  cd ~/Projects/coso_java/com/coso/coso20-docker-images/coso-insights-server/dev;
  docker-compose up $1;
}

function coso() {
  PROJECT_FOLDER=~/Projects/coso_java/com/coso
  JSX_FOLDER=~/Projects/cosocloud

  if [[ $1 == "build" ]]; then
    coso jsx;
    npm run build;
  elif [[ $1 == "jsx" ]]; then
    cd -- $JSX_FOLDER;
  elif [[ $1 == "ssh" ]]; then
    ACTION=${3:-"sh"}
    docker exec -it $2 ${ACTION}
  elif [[ $1 == "boot" ]]; then
    cosoBoot $2
  elif [[ $1 == "down" ]]; then
    coso docker;
    cd coso-insights-server/dev/;
    docker-compose down;
  elif [[ $1 == "server" ]]; then
    cd -- $PROJECT_FOLDER/coso20-server
    if [[ $2 == "package" ]]; then
      echo "linking coso common. ensure it is the latest build...";
      mvn install:install-file -Dfile=../coso20-common/target/common-0.0.1-SNAPSHOT.jar -DgroupId=coso -DartifactId=common -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar
      mvn install:install-file -Dfile=../coso20-dev-client/target/2.0-netty-dev-bootstrapper-0.0.1-SNAPSHOT.jar -DgroupId=coso -DartifactId=dev-client -Dversion=0.0.1 -Dpackaging=jar

    fi
  elif [[ $1 == "common" ]]; then
    cd -- $PROJECT_FOLDER/coso20-common
  elif [[ $1 == "dev" ]]; then
    cd -- $PROJECT_FOLDER/coso20-dev-client
  elif [[ $1 == "insights" ]]; then
    cd -- $PROJECT_FOLDER/coso20-insights-server
    if [[ $2 == "package" ]]; then
      echo "linking coso20-common. ensure it is the latest version...";
      mvn install:install-file -Dfile=../coso20-common/target/common-0.0.1-SNAPSHOT.jar -DgroupId=coso -DartifactId=common -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar
      mvn package;
    fi
  elif [[ $1 == "docker" ]]; then
    cd -- $PROJECT_FOLDER/coso20-docker-images
  elif [[ $1 == "mvn" ]]; then
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$BRANCH" != "master" ]]; then
      git stash;
      git checkout master;
      git pull origin master;
    fi
    if [[ "$BRANCH" != "master" ]]; then
      git checkout $BRANCH;
      git merge master;
      git stash pop;
    fi
    mvn install; mvn $2;
  elif [[ $1 == "nginx" ]]; then
    coso docker;
    cd nginx;
    ./prod.sh
    ./build.sh
    if [[ $2 == "push" ]]; then
      ./push
    fi
  elif [[ $1 == "tour" ]]; then
    TOURING="Touring through the "
    echo "====================="
    echo $TOURING + "dev client"
    echo "====================="
    coso dev;
    coso mvn install;
    echo "====================="
    echo $TOURING + "common client"
    echo "====================="
    coso common;
    coso mvn install;
    echo "====================="
    echo $TOURING + "server"
    echo "====================="
    coso server;
    mvn install:install-file -Dfile=../coso20-common/target/common-0.0.1-SNAPSHOT.jar -DgroupId=coso -DartifactId=common -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar
    coso mvn package;
    echo "====================="
    echo $TOURING + "insights"
    echo "====================="
    coso insights;
    coso mvn package;

    echo "====================="
    echo $TOURING + "docker"
    echo "====================="
    coso docker;
    git pull origin master;
    cd -- $PROJECT_FOLDER
    echo "finished...."
    echo "Run coso boot or './start.sh' to kick off freshly build docker images";
  else
      printf "%-30s | %-30s | %-30s" "coso jsx" "React root directory" "~/cosocloud"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso build" "CD to React root and build" "npm run build"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso nginx" "move jsx build files to nginx/html" "rm -rf html/ cp -r .../build/* html/"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso boot" "Start docker containers, option -d for detached" "~/coso20-docker-images; ./start.sh"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso dev" "Dev client root directory" "~/coso20-dev-client"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso common" "Common client root directory" "~/coso20-common"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso server" "Server root directory" "~/coso20-server"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso insights" "Insights root directory" "~/coso20-insights"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso docker" "Docker root directory" "~/coso20-docker-images"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso mvn <mvn-goal>" "Update to latest and mvn goal" "git stash; git checkout master; git pull; mvn <goal>"
      echo -e "\n"
      printf "%-30s | %-30s | %-30s" "coso tour" "Visit, update, & dockerify" "Once more around the sun"
      echo -e "\n"
      printf "%-30s | %-30s | %30s" "coso down" "Tear down the docker containers" "docker-compose down"
      echo -e "\n"
      printf "%-30s | %-30s | %30s" "coso ssh" "ssh into local sever" "ssh IP, option POINT for xx.xxx.xx.POINT"
  fi
}

