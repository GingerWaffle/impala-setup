ARG IMPALA_QUICKSTART_IMAGE_PREFIX="apache/impala:81d5377c2-"
FROM ${IMPALA_QUICKSTART_IMAGE_PREFIX}impala_quickstart_client

# Install necessary packages for building C++ code
USER root
RUN apt-get update && apt-get install -y build-essential cmake libboost-all-dev
# libimpala-udf-dev

# Copy UDF/UDAF source files
COPY udf_src/my-impala-udf /udf_source
COPY udf_src/impala_udf /usr/include/impala_udf

# Build UDF shared library
RUN cd /udf_source && cmake . && make

# Copy the UDF libraries to a directory where entrypoint script can put it to where Impala can load it
RUN mkdir -p /usr/lib/impala/lib/ && cp /udf_source/build/* /usr/lib/impala/lib/
COPY udf_src/java/libs/impala-udfs-1.jar /usr/lib/impala/lib

# Add additional SQL file to the image
COPY data/additional_test_data.sql /opt/impala/sql/additional_test_data.sql

# Uncomment below to check contents of the directory in runtime
# RUN ls -l /usr/lib/impala/lib/ && sleep 30

# Modify the entrypoint script to execute the additional SQL file
RUN sed -i '/${IMPALA_SHELL} -f \/opt\/impala\/sql\/load_tpcds_parquet.sql/a mkdir -p ${WAREHOUSE_EXTERNAL_DIR}/udfs \n \\cp -rf /usr/lib/impala/lib/* ${WAREHOUSE_EXTERNAL_DIR}/udfs \n ${IMPALA_SHELL} -f \/opt\/impala\/sql\/additional_test_data.sql' /data-load-entrypoint.sh

USER impala
# Set the modified entrypoint script as the entrypoint (if it's not already set)
ENTRYPOINT ["/data-load-entrypoint.sh"]