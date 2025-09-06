# Azure_Sales_Customer_Pipelining

sales customer dataset from [kaggle](https://www.kaggle.com/datasets/ukveteran/adventure-works)

# Objective
The objective of this project will be to dynamically extract data from HTTP, and transform in such a way that it'll be viable for reporting via PowerBI.

As such, this will be the architecture, which follows the medallion architecture
![Data Pipeline Architecture](/Architecture.png?raw=true)




### 1. Create hierarchal data lake
![Datalake containers](/Steps/1_Hierarchal_data_lake.png?raw=true)
    Here I set up the datalake, ensuring it is in hierarchal namespace mode in order to allow for folders, which I promptly named bronze, silver, gold to organize the medallion architecture

### 2. Set up Data Factory & create Linked Services (Bronze Layer)
![Linked services](/Steps/2_Linked_Services.png?raw=true)
Next I set up Data Factory, and created linked services which act as a config/instructions for whenever our activity wants to access a source/sink (in this case: HTTP, Data Lake)

### 3. Create Pipeline in Datafactory (Bronze Layer)
![Linked services](/Steps/3_Pipeline.png?raw=true)
This would be where I did the extracting part of the ETL process.
    a. Upload parameter arguments by storing them in a git json file in our data lake
    b. Searched for and loaded the parameter arguments json file into data factory
    c. Sequentially looped through each object in the parameter arguments
    d. Using these parameters, searched github (via HTTP linked service) for each csv dataset, and loaded them into their respective folders under the bronze folder (via Data Lake linked service)


### 4. Set up app in MS Entra ID (Silver Layer)
![App registration](/Steps/4_App_registration.png?raw=true)
Now I want to authenticate databricks such that it can access the Data Lake. 
Due to this, I registered a service principal (app) so that permissions are isolated to that specific app, rather than being connect to the tenant (user admin i.e. me)


### 5. Set up and connect Databricks to Data Lake (Silver Layer)
![Data Bricks CLI](/Steps/4_App_registration.png?raw=true)
In the actual Databricks studio, I still had to connect to the data lake with its credentials from this side (in a way, this would be the client side since it's one way). 
There were 2 ways to do this:
1. Unity Catalog, an app/tool in Databricks that stores permissions in a metadata db, and uses it provide permissions for who can access what storage across multiple Databricks workspaces.
2. Secret scope, works kind of like how API secrets are held

I picked option 2 as I wanted to mess with the databricks CLI :>
The code regarding the connection of itcan be found in the first note here [Silver_Transformation.ipynb](Silver_Transformation.ipynb)


### 6. Transform the data (Silver Layer)
    Here, I would:
    a. Load the data
    b. Transform the data

The code and process can be found in [Silver_Transformation.ipynb](Silver_Transformation.ipynb)

### 7. Set up Synapse Analytics (Gold Layer)


### 8. Create SQL scripts to load the parquet files
I did this by making 3 scripts
Schema_creation
1. [Create the gold schema](/SQL_Scripts/Schema_creation.sql)

2. [Create view tables to be accessed by PowerBI](/SQL_Scripts/View_creation.sql). View tables rather than raw tables as
    a. They're always up to date since they're just an abstraction for a query statement that's ran at run-time
    b. Limited and granular access to columns/rows that could be confidential, because although we trust our data analysts, we DON'T trust hackers who might take control of their user permissions.

    Typically you would do more complex transformations here in order to finetune the view tables to be what your end user wants.

3. [Upload these view tables into our datalake](/SQL_Scripts/External_Table_Creation.sql)


### 9. Lastly, connect PowerBI to Synapse
![PowerBI Connection](/Steps/9_PowerBI_connection.png?raw=true)
![PowerBI Data](/Steps/9_PowerBI_data.png?raw=true)
    I did this by connecting via the serverless synapse url, and inputting the required synapse admin credentials (i.e. the password made when creating synapse, and the username typically being sqladminuser if you're the admin (found in synapse Overview)).


<br><br><br>
Some terminology I found confusing along the way.
<br>

Security terms:
* Service principal = An app that acts as a user, can give permission to this "user" to gain a specified amount of access to the desired resources. Typically for external apps/tools
* System assigned Managed Identities = service principal except its secrets are managed (e.g. you don't have to store connect w/ the secret key like I did with DataBricks); can toggle on/off for a resource. Only possible for Azure apps/tools. Typically when you want to connect a specific Azure (only) resource to another (i.e. one-to-one)
* User assigned Managed Identities = System assigned Managed Identities except it's generic, i.e. multiple resources can be assigned this "user". Typically when you want to connect multiple Azure (only) resource to another or more (i.e. many-to-many)
<br>

Data terms
* Datalake = a massive database that stores various kinds of data types (raw, unstructures, semi-structured) as objects, and stores their metadata in order for read/write to and from the lake to be possible
* Data warehouse = a giant database that stores structured data, similar to SQL databases except it has tools for analytics
* Datalakehouse = basically uses data warehouse to query from the Datalake by using its metadata files
