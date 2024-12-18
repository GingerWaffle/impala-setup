# Docker Quickstart with docker-compose
Based on [https://github.com/apache/impala/tree/master/docker](https://github.com/apache/impala/tree/master/docker)
Various docker-compose files in this directory provide a convenient way to run
a basic Impala service with a single Impala Daemon and minimal set of supporting
services. A Hive MetaStore service is used to manage metadata. All filesystem data
is stored in Docker volumes. The default storage location for tables is in the
`impala-quickstart-warehouse` volume, i.e. if you create a table in Impala, it will
be stored in that volume by default.

## Starting the cluster:

To start the base quickstart cluster and load data in background into Parquet and raw formats:

```bash
  docker-compose up -d
```

To follow the data loading process, you can use the `docker logs` command, e.g.:

```bash
  docker logs -f docker_data-loader_1
```

## Connecting to the cluster:

The impala service can be connected to `localhost` or your
machine's host name.

## Connecting with containerized impala-shell:

```bash
  docker run --network=quickstart-network -it \
     ${IMPALA_QUICKSTART_IMAGE_PREFIX}impala_quickstart_client impala-shell
```

Or with a pre-installed impala-shell:

```bash
  impala-shell -i ${QUICKSTART_IP}
```

## Accessing the Warehouse volume
If you want to directly interact with the contents of the warehouse in the
`impala-quickstart-warehouse` Docker volume or copy data from the host into the
quickstart warehouse, you can mount the volume in another container. E.g. to run
an Ubuntu 18.04 container with the warehouse directory mounted at
`/user/hive/warehouse` and your home directory mounted at `/host_dir`, you
can run the following command:

```bash
docker run -v ~:/host_dir -v docker_impala-quickstart-warehouse:/user/hive/warehouse \
    -it ubuntu:18.04 /bin/bash
```

In the container, you can find the external and managed tablespaces stored in
the `impala-quickstart-warehouse` volume, for example:

```
root@377747c68bfa:/# ls /user/hive/warehouse/external/tpcds_raw/
call_center       customer_demographics   inventory  store_returns  web_sales
catalog_page      date_dim                item       store_sales    web_site
catalog_returns   dbgen_version           promotion  time_dim
catalog_sales     generated               reason     warehouse
customer          household_demographics  ship_mode  web_page
customer_address  income_band             store      web_returns
t@377747c68bfa:/# head -n2 /user/hive/warehouse/external/tpcds_raw/time_dim/time_dim.dat
0|AAAAAAAABAAAAAAA|0|0|0|0|AM|third|night||
1|AAAAAAAACAAAAAAA|1|0|0|1|AM|third|night||
```

It is then possible to copy data files from the host into an external table.
In impala-shell, create an external table:
```sql
create external table quickstart_example(s string)
stored as textfile
location '/user/hive/warehouse/external/quickstart_example';
```

Then in the host and container shells, create a text file and copy it into the
external table directory.
```bash
# On host:
echo 'hello world' > ~/hw.txt

# In container:
cp /host_dir/hw.txt /user/hive/warehouse/external/quickstart_example
```

You can then refresh the table to pick up the data file and query the table:
```sql
refresh quickstart_example;
select * from quickstart_example;
```

## Environment Variable Overrides:

The following environment variables influence the behaviour of the various
quickstart docker compose files.
* `IMPALA_QUICKSTART_IMAGE_PREFIX` - defaults to using local images, change to
   to a different prefix to pick up prebuilt images.
* `QUICKSTART_LISTEN_ADDR` - can be set to either `$QUICKSTART_IP` to listen on
  only the docker network interface, or `0.0.0.0` to listen on all interfaces.
