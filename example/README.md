# Deploy a python package as an AWS Lamda function

This example deploys the python package under the `src` folder to AWS Lambda service. Custom dependencies inside the `src/requirements.txt` file are also installed and deployed alongside the package.

> You need to configure aws provider before running this demo. If you haven't configured yet, please follow [this tutorial](https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started).

Once deployed, this example creates a lambda function where the given parameter `password` is hashed. Function returns the hashed password with key `hash`. To run it, create a test and provide a password like below, then run the test.


```
{
  "password": "test"
}
```

Running above test will return the hash of `test` as follows:

```
{
  "hash": "$2b$10$W52tyS90XKO8Mnt5LtQXVe01L50tK/m5QPjYTI1eTtuD3vVhG1ZTS"
}
```

> For demonstration purposes, `bcrpyt`'s default work factor was lowered to 10 (from 12) in order to avoid possible lambda timeouts.