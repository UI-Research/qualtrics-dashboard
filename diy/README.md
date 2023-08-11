# Create Your Own Survey Data Dashboard
These instructions assume you are comfortable with GitHub. If you are new to GitHub or would like a refresher, check out <a href="https://ui-research.github.io/reproducibility-at-urban/git-workflow.html" target="blank">this guide</a>. Key sections of the guide are also hyperlinked in the relevant steps below. 

Watch this <a href="https://urbanorg.box.com/s/5yxqzflxwnsh78o3xeqs01ac41eoeqyh" target="_blank">video walkthrough</a> of us building a survey data dashboard for additional guidance, and feel free to post questions in the <a href="https://theurbaninstitute.slack.com/archives/CNUG9ELE5" target="_blank">#qualtrics</a> and <a href="https://theurbaninstitute.slack.com/archives/CF56VD6CX" target="_blank">#r-users-group</a> Slack channels!

1. <a href="https://ui-research.github.io/reproducibility-at-urban/git-workflow.html" target="blank">Create a new GitHub repository</a> (repo) for your dashboard.\
   a. Select "Add a README file."\
   b. If you plan to use a <a href="https://ui-research.github.io/reproducibility-at-urban/git-workflow.html#cloning-an-existing-repository
" target="blank">virtual environment</a>, select ".gitignore template: None."\
   c. If you do **not** plan to use a virtual environment, select ".gitignore template: R."

2. <a href="https://ui-research.github.io/reproducibility-at-urban/git-workflow.html#cloning-an-existing-repository" target="blank">Clone the repo</a> you created in Step 1 to your computer. At this point your repo should be a single folder (the "root" directory) with a file called `README.md` in it. It will also have a hidden `.gitignore` file if you selected a .gitignore template in Step 1.\
  a. To see your `.gitignore` on Windows computer, go to Folder Properties for your repo and select "Show All File Extensions."\
  b. To see your `.gitignore` on a Mac, use the command + shift + . keyboard shortcut.

3. **OPTIONAL** If you want to use <a href="https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects" target="blank">RStudio Projects</a>, create your project now:\
   a. Open RStudio.\
   b. Click "File" > "New Project..." > "Existing Directory."\
   c. Specify your dashboard repo as the project's working directory.\
   d. Click "Create Project."

4. **OPTIONAL** If you want to use a virtual environment, <a href="https://ui-research.github.io/reproducibility-at-urban/virtual-environments.html#how-do-i-set-up-a-virtual-environment" target="blank">initialize it</a> now:\
   a. Go to your dashboard repo in RStudio\
   b. Run `install.packages("renv")` in your console\
   c. Run `renv::init()` in your console\
   d. Download `renv.lock`, which specifies dependencies for the dashboard template, and save it in your root folder. Your computer will probably ask you to confirm that you want to replace the existing `renv.lock` file, which R created when you initialized the virtual environment. You do.\
   e. Run `renv::restore()` in your console to activate the virtual environment.

6. Download the dashboard template, `app.R`, and save it in your root folder. Do **not** change the file name – you need a file called `app.R` to build a Shiny app.

7. Create a folder called `www` in your root directory. (You have to name the folder `www` so Shiny will know to look there for a stylesheet.) Download `shiny.css` and save it in your new `www` folder.

At this point, your repo should have the following structure:
```{r}
YOUR_REPO_NAME/ # Whatever you named your repo in Step 1
   app.R
   README.md
   www/
      shiny.css
   YOUR_REPO_NAME.Rproj # if using RStudio Projects
   renv/ # if using renv
      activate.R
      settings.json
   renv.lock # if using renv
```

7. Open the template, `app.R`. The template comes with "starter code" for fetching Qualtrics data and building a simple dashboard. Throughout the file, `TODO` indicates where you need to provide additional code before you can run your app. Reference the demo and <a href="https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/index.html" target="blank">Shiny Basics</a> for concrete code examples.

8. When you are done adding code to `app.R`, launch your dashboard by clicking "Run App" in the top right of your <a href="https://teacherscollege.screenstepslive.com/a/1426910-panes-in-rstudio" target="blank">source editor</a> or running `runApp()` in your console.

9. If you want to host your dashboard online for other people to access via URL, follow these instructions to <a href="https://urbanorg.box.com/s/2h476c9gfwr5umvestihijb5gvspm5wp" target="blank">publish your app</a>.

Acknowledgement: `shiny.css` is lightly adapted from <a href="https://github.com/UrbanInstitute/urbnthemes" target="blank">urbnthemes.</a>
