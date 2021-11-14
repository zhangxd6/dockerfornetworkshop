# Setup Environment

This section describes the hardware and software needed for this workshop, and how to configure them.
This workshop is designed for a BYOL (Bring Your Own Laptop) style hands-on-lab.

## Hardware & Software

- Memory: At least 4 GB+, strongly preferred 8 GB
- Operating System: Mac OS X (10.10.3+), Windows 10 Pro+ 64-bit, Ubuntu 12+, CentOS 7+.

## Install Docker

Docker runs natively on Mac, Windows and Linux.
This lab will use Docker Desktop
Download the Docker Descktop for your machine from the [Docker Website](Docker Desktop for Mac and Windows | Docker).



## Other Software

The softwares in this section are specific to certain parts of the workshop.
Install them only if you plan to attempt them.

- Install [git](https://git-scm.com)
- Download and install a code editor of your choice:
   - [Visual Studio Code](https://code.visualstudio.com/download)


S.No. | Name of Software | Link to Follow | 
:------------ | :-------------| :-------------|
1 |  Git | [Link](https://git-scm.com)  |
2 |  Dotnet | [Link](https://dotnet.microsoft.com)  |
3 |  Visual Studio Code | [Link](https://code.visualstudio.com/download)  |

## Download Dotnet 

You can download the latest version of Dotnet (5.0) from the below links:

- [Windows](https://download.visualstudio.microsoft.com/download/pr/78a6328f-f563-4a7f-a478-3ed0f2ce8ec6/5beb762f64d8a018a5b9e590bc1531e0/dotnet-sdk-5.0.201-win-x64.exe)
- [MacOS ](https://download.visualstudio.microsoft.com/download/pr/de613120-9306-4867-b504-45fcc81ba1b6/2a03f18c549f52cf78f88afa44e6dc6a/dotnet-sdk-5.0.201-osx-x64.pkg)
- [Linux](https://docs.microsoft.com/dotnet/core/install/linux)


### Check Installation


After you've installed, open a new terminal and run the following command:

```bash
dotnet

```

You should be able to see the output like

```
Usage: dotnet [options]
Usage: dotnet [path-to-application]

Options:
-h|--help         Display help.
--info            Display .NET information.
--list-sdks       Display the installed SDKs.
--list-runtimes   Display the installed runtimes.

path-to-application:
The path to an application .dll file to execute.

```


##  Basics of Docker

This section introduces the basic terminology of Docker.

Docker is a platform for developers and sysadmins to build, ship, and run applications. Docker lets you quickly assemble applications from components and eliminates the friction that can come when shipping code. Docker lets you test and deploy your code into production as fast as possible.

Docker simplifies software delivery by making it easy to build and share images that contain your application’s entire environment, or _application operating system_.

## What does it mean by an application operating system ?

Your application typically requires a specific version of operating system, application server, runtime, and database server. It may also require configuration files, and multiple other dependencies. The application may need binding to specific ports and certain amount of memory. The components and configuration together required to run your application is what is referred to as application operating system.

You can certainly provide an installation script that will download and install these components. Docker simplifies this process by allowing to create an image that contains your application and infrastructure together, managed as one component. These images are then used to create Docker containers which run on the container virtualization platform, provided by Docker.

## Main Components of Docker System

Docker has three main components:

- Images are the *build component* of Docker and are the read-only templates defining an application operating system.
- Containers are the *run component* of Docker and created from images. Containers can be run, started, stopped, moved, and deleted.
- Images are stored, shared, and managed in a registry and are the *distribution component* of Docker. 
- DockerHub is a publicly available registry and is available at http://hub.docker.com.

In order for these three components to work together, the *Docker Daemon* (or Docker Engine) runs on a host machine and does the heavy lifting of building, running, and distributing Docker containers. In addition, the *Client* is a Docker binary which accepts commands from the user and communicates back and forth with the Engine.

![docker-architecture](https://docs.docker.com/engine/images/architecture.svg)


The Client communicates with the Engine that is either co-located on the same host or on a different host. Client uses the `pull` command to request the Engine to pull an image from the registry. The Engine then downloads the image from Docker Store, or whichever registry is configured. Multiple images can be downloaded from the registry and installed on the Engine. Client uses the `run` run the container.

## Docker Image

We've already seen that Docker images are read-only templates from which Docker containers are launched. Each image consists of a series of layers. Docker makes use of union file systems to combine these layers into a single image. Union file systems allow files and directories of separate file systems, known as branches, to be transparently overlaid, forming a single coherent file system.

One of the reasons Docker is so lightweight is because of these layers. When you change a Docker image—for example, update an application to a new version— a new layer gets built. Thus, rather than replacing the whole image or entirely rebuilding, as you may do with a virtual machine, only that layer is added or updated. Now you don't need to distribute a whole new image, just the update, making distributing Docker images faster and simpler.

Every image starts from a base image, for example `ubuntu`, a base Ubuntu image, or `fedora`, a base Fedora image. You can also use images of your own as the basis for a new image, for example if you have a base Apache image you could use this as the base of all your web application images.

NOTE: By default, Docker obtains these base images from Docker Store.

Docker images are then built from these base images using a simple, descriptive set of steps we call instructions. Each instruction creates a new layer in our image. Instructions include actions like:

- Run a command
- Add a file or directory
- Create an environment variable
- Run a process when launching a container

These instructions are stored in a file called a Dockerfile. Docker reads this Dockerfile when you request a build of an image, executes the instructions, and returns a final image.

## Docker Container

A container consists of an operating system, user-added files, and meta-data. As we've seen, each container is built from an image. That image tells Docker what the container holds, what process to run when the container is launched, and a variety of other configuration data. The Docker image is read-only. When Docker runs a container from an image, it adds a read-write layer on top of the image (using a union file system as we saw earlier) in which your application can then run.

## Docker Engine

Docker Host is created as part of installing Docker on your machine. Once your Docker host has been created, it then allows you to manage images and containers. For example, the image can be downloaded and containers can be started, stopped and restarted.

### Docker Client

The client communicates with the Docker Host and let's you work with images and containers.

Check if your client is working using the following command:

```
docker -v
```

It shows the output:

```
Docker version 20.10.2, build 2291f61
```

NOTE: The exact version may differ based upon how recently the installation was performed.

The exact version of Client and Server can be seen using `docker version` command. This shows the output as:

```
 docker version
Client: Docker Engine - Community
 Cloud integration: 1.0.7
 Version:           20.10.2
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        2291f61
 Built:             Mon Dec 28 16:12:42 2020
 OS/Arch:           darwin/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.2
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       8891c58
  Built:            Mon Dec 28 16:15:28 2020
  OS/Arch:          linux/amd64
  Experimental:     true
 containerd:
  Version:          1.4.3
  GitCommit:        269548fa27e0089a8b8278fc4fc781d7f65a939b
 runc:
  Version:          1.0.0-rc92
  GitCommit:        ff819c7e9184c13b7c2607fe6c30ae19403a7aff
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
ajeetraina@Ajeets-MacBook-Pro realtime-sensor-jetson % 
```

The complete set of commands can be seen using `docker --help`.


## Build a Docker Image

This section explains how to create a Docker image.

## Dockerfile

Docker build images by reading instructions from a _Dockerfile_. A _Dockerfile_ is a text document that contains all the commands a user could call on the command line to assemble an image. `docker image build` command uses this file and executes all the commands in succession to create an image.

`build` command is also passed a context that is used during image creation. This context can be a path on your local filesystem or a URL to a Git repository.

Dockerfile is usually called Dockerfile. The complete list of commands that can be specified in this file are explained at https://docs.docker.com/reference/builder/. The common commands are listed below:

## Common commands for Dockerfile

| Command | Purpose | Example |
:------------ | :-------------| :-------------|
| FROM | First non-comment instruction in _Dockerfile_ | `FROM ubuntu`
| COPY | Copies mulitple source files from the context to the file system of the container at the specified path | `COPY .bash_profile /home`
| ENV | Sets the environment variable | `ENV HOSTNAME=test`
| RUN | Executes a command | `RUN apt-get update`
| CMD | Defaults for an executing container | `CMD ["/bin/echo", "hello world"]`
| EXPOSE | Informs the network ports that the container will listen on | `EXPOSE 8093`

## Create your first image

Create a new directory `hellodocker`.

In that directory, create a new text file `Dockerfile`. Use the following contents:

```
FROM ubuntu:latest

CMD ["/bin/echo", "hello world"]
```

This image uses `ubuntu` as the base image. `CMD` command defines the command that needs to run. It provides a different entry point of `/bin/echo` and an argument "`hello world`".

## Build the image

```
  docker image build . -t helloworld
```

`.` in this command is the context for the command `docker image build`. `-t` adds a tag to the image.

The following output is shown:

```
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM ubuntu:latest
latest: Pulling from library/ubuntu
9fb6c798fa41: Pull complete 
3b61febd4aef: Pull complete 
9d99b9777eb0: Pull complete 
d010c8cf75d7: Pull complete 
7fac07fb303e: Pull complete 
Digest: sha256:31371c117d65387be2640b8254464102c36c4e23d2abe1f6f4667e47716483f1
Status: Downloaded newer image for ubuntu:latest
 ---> 2d696327ab2e
Step 2/2 : CMD /bin/echo hello world
 ---> Running in 9356a508590c
 ---> e61f88f3a0f7
Removing intermediate container 9356a508590c
Successfully built e61f88f3a0f7
Successfully tagged helloworld:latest
```

## List the images 

You can list the images available using `docker image ls`:

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
helloworld          latest              e61f88f3a0f7        3 minutes ago       122MB
ubuntu              latest              2d696327ab2e        4 days ago          122MB
```

Other images may be shown as well but we are interested in these two images for now.

Run the container using the command:

```
docker container run helloworld
```

to see the output:

```
hello world
```

If you do not see the expected output, check your Dockerfile that the content exactly matches as shown above. Build the image again and now run it.

Change the base image from `ubuntu` to `busybox` in `Dockerfile`. Build the image again:

```  
docker image build -t helloworld:2 .
```

and view the images using `docker image ls` command:

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
helloworld          2                   7fbedda27c66        3 seconds ago       1.13MB
helloworld          latest              e61f88f3a0f7        5 minutes ago       122MB
ubuntu              latest              2d696327ab2e        4 days ago          122MB
busybox             latest              54511612f1c4        9 days ago          1.13MB
```

`helloworld:2` is the format that allows to specify the image name and assign a tag/version to it separated by `:`.

## Create a dotnet application

1. In your terminal, type the following command

```
dotnet new console -o myApp
```
You should see the output in terminal

```
# dotnet new console -o myApp
Getting ready...
The template "Console Application" was created successfully.

Processing post-creation actions...
Running 'dotnet restore' on myApp/myApp.csproj...
  Determining projects to restore...
  Restored /myApp/myApp.csproj (in 90 ms).
Restore succeeded.
```

this will bootstrap a new console application from template shipped with dotnet sdk. The -o parameter creates a directory named myApp where your app is stored.


2. Navigate to the application directory

```
cd myApp
```
you will have a Program.cs file

```
using System;

namespace myApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
```

3. In your terminal, type the following command to run your application

```
dotnet run
```
you would expect the "Hello World" will be printed out in terminal

4. Put the application in the container

Create Dockerfile with following content:

```
FROM mcr.microsoft.com/dotnet/sdk as build
COPY . ./src
WORKDIR /src
RUN dotnet build -o /app

FROM mcr.microsoft.com/dotnet/runtime as base
COPY --from=build  /app /app
WORKDIR /app
CMD ["./myApp"]

```

Now that we have defined everything we need to run in our Dockerfile we can now build an image using this file. In order to do that, we’ll need to run the following command:

```
$ docker build -t myapp .
[+] Building 8.4s (13/13) FINISHED
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 37B                                        0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load metadata for mcr.microsoft.com/dotnet/runtime:latest   4.2s
 => [internal] load metadata for mcr.microsoft.com/dotnet/sdk:latest       0.0s
 => [internal] load build context                                          0.0s
 => => transferring context: 359B                                          0.0s
 => CACHED [build 1/4] FROM mcr.microsoft.com/dotnet/sdk                   0.0s
 => CACHED [base 1/3] FROM mcr.microsoft.com/dotnet/runtime@sha256:8fbb07  0.0s
 => [build 2/4] COPY . ./src                                               0.0s
 => [build 3/4] WORKDIR /src                                               0.0s
 => [build 4/4] RUN dotnet build -o /app                                   3.6s
 => [base 2/3] COPY --from=build  /app /app                                0.0s
 => [base 3/3] WORKDIR /app                                                0.0s
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:51886aa5cafd278e6cd2b2ea3ed586dac675b4aaae606  0.0s
 => => naming to docker.io/library/myapp                                   0.0s

```

We can now verify that our image exists on our machine by using `docker images` command:

```
$ docker images
REPOSITORY                                                 TAG       IMAGE ID       CREATED          SIZE
myapp                                                      latest    51886aa5cafd   31 seconds ago   186MB
```

In order to run this newly created image, we can use the docker run command and pass in the ports we want to map to and the image we wish to run.

```
$ docker run --rm myapp
Hello World
```


- `-it` - This flag specifies that we want to run this image in interactive mode with a tty for this container process.
- `--rm` - This flag will clean the container after it runs
- `myapp ` - This is the name of the image that we want to run in a container.

Now we have a dockerized dotnet application.


## Create a .Net application

1. In your terminal, type the following command

```
dotnet new webApp -o myWebApp --no-https
```
You should see the output in terminal

```
# dotnet new webApp -o myWebApp --no-https
Getting ready...
The template "ASP.NET Core Web App" was created successfully.
This template contains technologies from parties other than Microsoft, see https://aka.ms/aspnetcore/5.0-third-party-notices for details.

Processing post-creation actions...
Running 'dotnet restore' on myWebApp/myWebApp.csproj...
  Determining projects to restore...
  Restored /myWebApp/myWebApp.csproj (in 90 ms).
Restore succeeded.
```

this will bootstrap a new web application from template shipped with dotnet sdk. The -o parameter creates a directory named myWebApp where your app is stored.


2. Navigate to the application directory

```
cd myWebApp
```
you will have a list of files

```
# ls
Pages  Program.cs  Properties  Startup.cs  appsettings.Development.json  appsettings.json  bin	myWebApp.csproj  obj  wwwroot
```

3. In your terminal, type the following command to run your application

```
dotnet run
```
The applciation will start to listen on port 5000 for requests

```
# dotnet run
Building...
warn: Microsoft.AspNetCore.DataProtection.Repositories.FileSystemXmlRepository[60]
      Storing keys in a directory '/root/.aspnet/DataProtection-Keys' that may not be persisted outside of the container. Protected data will be unavailable when container is destroyed.
warn: Microsoft.AspNetCore.Server.Kestrel[0]
      Unable to bind to http://localhost:5000 on the IPv6 loopback interface: 'Cannot assign requested address'.
info: Microsoft.Hosting.Lifetime[0]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Development
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /src
```

4. Test the application

now we can use the curl to test the connection of our web application

```
# curl http://localhost:5000
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Home page - myWebApp</title>
    <link rel="stylesheet" href="/lib/bootstrap/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/css/site.css" />
</head>
<body>
    <header>
        <nav class="navbar navbar-expand-sm navbar-toggleable-sm navbar-light bg-white border-bottom box-shadow mb-3">
            <div class="container">
                <a class="navbar-brand" href="/">myWebApp</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target=".navbar-collapse" aria-controls="navbarSupportedContent"
                        aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="navbar-collapse collapse d-sm-inline-flex justify-content-between">
                    <ul class="navbar-nav flex-grow-1">
                        <li class="nav-item">
                            <a class="nav-link text-dark" href="/">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-dark" href="/Privacy">Privacy</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>
    <div class="container">
        <main role="main" class="pb-3">

<div class="text-center">
    <h1 class="display-4">Welcome</h1>
    <p>Learn about <a href="https://docs.microsoft.com/aspnet/core">building Web apps with ASP.NET Core</a>.</p>
</div>

        </main>
    </div>

    <footer class="border-top footer text-muted">
        <div class="container">
            &copy; 2021 - myWebApp - <a href="/Privacy">Privacy</a>
        </div>
    </footer>

    <script src="/lib/jquery/dist/jquery.min.js"></script>
    <script src="/lib/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/site.js?v=4q1jwFhaPaZgr8WAUSrux6hAuh0XDg9kPS3xIVq36I0"></script>


</body>
</html>
```

5. Put the application in the container

Create Dockerfile with following content:

```
FROM mcr.microsoft.com/dotnet/sdk as build
COPY . ./src
WORKDIR /src
RUN dotnet build -o /app
RUN dotnet publish -o /publish

FROM mcr.microsoft.com/dotnet/aspnet as base
COPY --from=build  /publish /app
WORKDIR /app
EXPOSE 80
CMD ["./myWebApp"]

```

This is a multistage docker file. The build stage uses sdk image to build the appliation and create final articfacts in the publish folder. Then final stage copy artifacts from build stage to app folder, expose port 80 to incoming request and specify the command to run the application **myWebApp**

Now that we have defined everything we need to run in our Dockerfile we can now build an image using this file. In order to do that, we’ll need to run the following command:

```
$ docker build -t mywebapp .
[+] Building 6.0s (14/14) FINISHED
 => [internal] load build definition from Dockerfile                                                                                0.0s
 => => transferring dockerfile: 37B                                                                                                 0.0s
 => [internal] load .dockerignore                                                                                                   0.0s
 => => transferring context: 2B                                                                                                     0.0s
 => [internal] load metadata for mcr.microsoft.com/dotnet/sdk:latest                                                                0.0s
 => [internal] load metadata for mcr.microsoft.com/dotnet/aspnet:latest                                                             0.4s
 => [internal] load build context                                                                                                   0.0s
 => => transferring context: 7.38kB                                                                                                 0.0s
 => CACHED [build 1/5] FROM mcr.microsoft.com/dotnet/sdk                                                                            0.0s
 => CACHED [base 1/3] FROM mcr.microsoft.com/dotnet/aspnet@sha256:2132b0cbc71eb09dae6d9063849e5d8094777eac1e59c33238026ce7fd2cf355  0.0s
 => [build 2/5] COPY . ./src                                                                                                        0.1s
 => [build 3/5] WORKDIR /src                                                                                                        0.0s
 => [build 4/5] RUN dotnet build -o /app                                                                                            2.6s
 => [build 5/5] RUN dotnet publish -o /publish                                                                                      2.2s
 => [base 2/3] COPY --from=build  /publish /app                                                                                     0.1s
 => [base 3/3] WORKDIR /app                                                                                                         0.0s
 => exporting to image                                                                                                              0.1s
 => => exporting layers                                                                                                             0.0s
 => => writing image sha256:6acc7ebf3a1d54c7205b2881eca9f3b7cbb6b47927420e117d22aa52f7a67941                                        0.0s
 => => naming to docker.io/library/mywebapp                                                                                         0.0s

```

We can now verify that our image exists on our machine by using `docker images` command:

```
$ docker images
REPOSITORY                                                 TAG       IMAGE ID       CREATED              SIZE
mywebapp                                                   latest    6acc7ebf3a1d   25 seconds ago       210MB
```

In order to run this newly created image, we can use the docker run command and pass in the ports we want to map to and the image we wish to run.

```
$ docker run --rm  -p 5000:80 myweapp
```


- `-p 5000:80` - This exposes our application which is running on port 80 within our container on http://localhost:5000 on our local machine.
- `--rm` - This flag will clean the container after it runs
- `myweapp ` - This is the name of the image that we want to run in a container.

Now we start the brower and put http://localhost:5000 to address bar

![mywebapp](https://contribute.docker.com/docs/communityleaders/eventhandbooks/dotnet/dotnetwebapp/mywebapp.png)


## What is Docker Compose


Docker Compose is a tool for defining and running complex applications with Docker. With Compose, you define a multi-container application in a single file, then spin your application up in a single command which does everything that needs to be done to get it running.

An application using Docker containers will typically consist of multiple containers. With Docker Compose, there is no need to write shell scripts to start your containers. All the containers are defined in a configuration file using _services_, and then `docker-compose` script is used to start, stop, and restart the application and all the services in that application, and all the containers within that service. The complete list of commands is:

| Command | Purpose |
:------------ | :-------------| 
| `build` | Build or rebuild services |
| `help` | Get help on a command |
| `kill` | Kill containers|
| `logs` | View output from containers|
| `port` | Print the public port for a port binding|
| `ps` | List containers|
| `pull` | Pulls service images|
| `restart` | Restart services|
| `rm` | Remove stopped containers|
| `run` | Run a one-off command|
| `scale` | Set number of containers for a service|
| `start` | Start services|
| `stop` | Stop services|
| `up` | Create and start containers|

The application used in this section is built based on myWebapp communicating with a Postgresql database. When the page is loaded, it will query the Student table for the record with ID and display the name of student on the page.

The myWebApp and Postgresql will be running in two separate containers, and thus making this a multi-container application.

## Update the myWebapp 

1. adding package to allow app taking to database

```
cd myWebapp
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL
```

2. create student model

- Create a Models folder in the project folder

- Create Models/Student.cs with the following code:

```
using System;
using System.Collections.Generic;

namespace myWebApp.Models
{
    public class Student
    {
        public int ID { get; set; }
        public string LastName { get; set; }
        public string FirstMidName { get; set; }
        public DateTime EnrollmentDate { get; set; }

    }
}
```
3. Create the SchoolContext with the following code

```
using Microsoft.EntityFrameworkCore;

namespace myWebApp.Data
{
    public class SchoolContext : DbContext
    {
        public SchoolContext (DbContextOptions<SchoolContext> options)
            : base(options)
        {
        }

        public DbSet<Models.Student> Students { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            modelBuilder.Entity<Models.Student>().ToTable("Student");
        }
    }
}
```

4. Regsister SchoolContext to DI in Startup.cs

```

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<myWebApp.Data.SchoolContext>(options =>
            options.UseNpgsql(Configuration.GetConnectionString("SchoolContext")));

            services.AddRazorPages();
        }

```

5. Adding database connectionstring to appsettings.json

```
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Information"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "SchoolContext": "Host=db;Database=my_db;Username=postgres;Password=example"
  }
}
```
6. Boostrap the table if it does not exist in Program.cs

```
 public static void Main(string[] args)
        {
           var host= CreateHostBuilder(args).Build();
           CreateDbIfNotExists(host);
           host.Run();
        }
      private static void CreateDbIfNotExists(IHost host)
        {
            using (var scope = host.Services.CreateScope())
            {
                var services = scope.ServiceProvider;
                try
                {
                    var context = services.GetRequiredService<Data.SchoolContext>();
                    context.Database.EnsureCreated();
                    // DbInitializer.Initialize(context);
                }
                catch (Exception ex)
                {
                    var logger = services.GetRequiredService<ILogger<Program>>();
                    logger.LogError(ex, "An error occurred creating the DB.");
                }
            }
        }
```

let update the UI

Index.cshtml

```
<div class="row mb-auto">
    <p>Student Name is @Model.StudentName</p>
</div>
```

and 
Index.cshtml.cs

``` 
    public class IndexModel : PageModel
    {
        public string StudentName { get; private set; } = "PageModel in C#";
         private readonly ILogger<IndexModel> _logger;
        private readonly myWebApp.Data.SchoolContext _context;

        public IndexModel(ILogger<IndexModel> logger, myWebApp.Data.SchoolContext context)
        {
            _logger = logger;
            _context= context;
        }

        public void OnGet()
        {
            var s =_context.Students.Where(d=>d.ID==1).FirstOrDefault();
            this.StudentName = $"{s?.FirstMidName} {s?.LastName}";
           
        }
    }

```



## Configuration file

The entry point to Docker Compose is a Compose file, usually called `docker-compose.yml`. In project directory, create a new file `docker-compose.yml` in it. Use the following contents:

```
services:

  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: example
    volumes:
      - postgres-data:/var/lib/postgresql/data
  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
  app:
    build:
      context: .
      dockerfile: ./Dockerfile
    ports:
      - 5000:80
      
    depends_on:
    - db
volumes:
  postgres-data:
    
```

In this Compose file:

- Two services in this Compose are defined by the name `db` and `web` attributes; the adminer service is a helper for us to access db 
- Image name for each service defined using `image` attribute
- The `postgres` image starts the Postgres server.
- `environment` attribute defines environment variables to initialize postgres server.
  -   `POSTGRES_PASSWORD` are used set that default user,**postgres** password. This user will be granted superuser permissions for the database **my_db** in the connectionstring.
- app application uses the `db` service as specified in the connection string
- The app image is built using the Dockerfile in the project directory
- Port forwarding is achieved using `ports` attribute.
- `depends_on` attribute allows to express dependency between services. In this case, Postgres will be started before app. Application-level health check are still user's responsibility.

## Start application

All services in the application can be started, in detached mode, by giving the command:

```
docker-compose up -d
```

An alternate Compose file name can be specified using `-f` option.

An alternate directory where the compose file exists can be specified using `-p` option.

This shows the output as:

```
docker-compose up -d
Starting mywebapp_adminer_1 ... done
Starting mywebapp_db_1      ... done
Starting mywebapp_app_1     ... done
```

The output may differ slightly if the images are downloaded as well.

Started services can be verified using the command `docker-compose ps`:

```
docker-compose ps
       Name                     Command               State           Ports
------------------------------------------------------------------------------------
mywebapp_adminer_1   entrypoint.sh docker-php-e ...   Up      0.0.0.0:8080->8080/tcp
mywebapp_app_1       ./myWebApp                       Up      0.0.0.0:5000->80/tcp
mywebapp_db_1        docker-entrypoint.sh postgres    Up      5432/tcp
```

This provides a consolidated view of all the services, and containers within each of them.

Alternatively, the containers in this application, and any additional containers running on this Docker host can be verified by using the usual `docker container ls` command:

```
docker container ls
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS              PORTS                    NAMES
ee35a9399b80   mywebapp_app   "./myWebApp"             29 minutes ago   Up About a minute   0.0.0.0:5000->80/tcp     mywebapp_app_1
0fc85278791c   postgres       "docker-entrypoint.s…"   30 minutes ago   Up About a minute   5432/tcp                 mywebapp_db_1
a9c725d0e684   adminer        "entrypoint.sh docke…"   30 minutes ago   Up About a minute   0.0.0.0:8080->8080/tcp   mywebapp_adminer_1

```

Service logs can be seen using `docker-compose logs` command, and looks like:

```
docker container logs mywebapp_db_1

PostgreSQL Database directory appears to contain a database; Skipping initialization

2021-03-16 04:19:51.862 UTC [1] LOG:  starting PostgreSQL 13.2 (Debian 13.2-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
2021-03-16 04:19:51.863 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2021-03-16 04:19:51.863 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2021-03-16 04:19:51.868 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2021-03-16 04:19:51.875 UTC [29] LOG:  database system was shut down at 2021-03-16 04:19:04 UTC
2021-03-16 04:19:51.884 UTC [1] LOG:  database system is ready to accept connections
2021-03-16 04:20:03.442 UTC [1] LOG:  received fast shutdown request
2021-03-16 04:20:03.444 UTC [1] LOG:  aborting any active transactions
2021-03-16 04:20:03.446 UTC [1] LOG:  background worker "logical replication launcher" (PID 35) exited with exit code 1
2021-03-16 04:20:03.447 UTC [30] LOG:  shutting down
2021-03-16 04:20:03.473 UTC [1] LOG:  database system is shut down

PostgreSQL Database directory appears to contain a database; Skipping initialization

2021-03-16 04:20:53.597 UTC [1] LOG:  starting PostgreSQL 13.2 (Debian 13.2-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
2021-03-16 04:20:53.597 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2021-03-16 04:20:53.597 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2021-03-16 04:20:53.601 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2021-03-16 04:20:53.606 UTC [26] LOG:  database system was shut down at 2021-03-16 04:20:03 UTC
2021-03-16 04:20:53.618 UTC [1] LOG:  database system is ready to accept connections
2021-03-16 04:21:31.054 UTC [38] ERROR:  invalid input syntax for type timestamp: "" at character 91
2021-03-16 04:21:31.054 UTC [38] STATEMENT:  INSERT INTO "Student" ("LastName", "FirstMidName", "EnrollmentDate")
	VALUES ('YHH', 'HH', '')
2021-03-16 04:33:09.323 UTC [1] LOG:  received fast shutdown request
2021-03-16 04:33:09.325 UTC [1] LOG:  aborting any active transactions
2021-03-16 04:33:09.327 UTC [1] LOG:  background worker "logical replication launcher" (PID 32) exited with exit code 1
2021-03-16 04:33:09.329 UTC [27] LOG:  shutting down
2021-03-16 04:33:09.342 UTC [1] LOG:  database system is shut down

PostgreSQL Database directory appears to contain a database; Skipping initialization

2021-03-16 04:49:23.844 UTC [1] LOG:  starting PostgreSQL 13.2 (Debian 13.2-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
2021-03-16 04:49:23.844 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2021-03-16 04:49:23.844 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2021-03-16 04:49:23.849 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2021-03-16 04:49:23.855 UTC [26] LOG:  database system was shut down at 2021-03-16 04:33:09 UTC
2021-03-16 04:49:23.862 UTC [1] LOG:  database system is ready to accept connections
```

## Verify application

Let's access the application. In your browser address bar type http://localhost:5000

you will see the page show no student name since the database is empty.

![no record](https://contribute.docker.com/docs/communityleaders/eventhandbooks/dotnet/compose/nostudent.png)

now open another tab with address http://localhost:8080 and you will be asked to login 

![login](https://contribute.docker.com/docs/communityleaders/eventhandbooks/dotnet/compose/adminerlogin.png)

use **postgres** and **example** as username/passowrd to login my_db.

once you are logged in, you can create a new student record

![add record](https://contribute.docker.com/docs/communityleaders/eventhandbooks/dotnet/compose/addnewstudent.png)

Now, refresh the app page at http://localhost:5000, the new added student name will be there,

![studnet](https://contribute.docker.com/docs/communityleaders/eventhandbooks/dotnet/compose/student1.png)
## Shutdown application

Shutdown the application using `docker-compose down`:

```
docker-compose down
Stopping mywebapp_app_1     ... done
Stopping mywebapp_db_1      ... done
Stopping mywebapp_adminer_1 ... done
Removing mywebapp_app_1     ... done
Removing mywebapp_db_1      ... done
Removing mywebapp_adminer_1 ... done
Removing network mywebapp_default
```

This stops the container in each service and removes all the services. It also deletes any networks that were created as part of this application.
