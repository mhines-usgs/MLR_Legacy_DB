#!/bin/ash 

# Restart postgres to make sure we can connect
pg_ctl -D "$PGDATA" -m fast -o "$LOCALONLY" -w restart

# superuser scripts
${LIQUIBASE_HOME}/liquibase \
--defaultsFile=${LIQUIBASE_HOME}/mlr-legacy-liquibase/mlr-liquibase/postgres.properties \
--classpath=${LIQUIBASE_HOME}/lib/postgresql.jar \
--changeLogFile=${LIQUIBASE_HOME}/mlr-legacy-liquibase/mlr-liquibase/postgres/changeLog.yml \
--logLevel=debug \
update \
-DMLR_LEGACY_PASSWORD=${MLR_LEGACY_PASSWORD} 

# application database create scripts
${LIQUIBASE_HOME}/liquibase \
--defaultsFile=${LIQUIBASE_HOME}/mlr-legacy-liquibase/mlr-liquibase/databaseCreate.properties \
--classpath=${LIQUIBASE_HOME}/lib/postgresql.jar \
--changeLogFile=${LIQUIBASE_HOME}/mlr-legacy-liquibase/mlr-liquibase/database/changeLog.yml \
--logLevel=debug \
update \
-DMLR_LEGACY_PASSWORD=${MLR_LEGACY_PASSWORD} 

# application scripts
${LIQUIBASE_HOME}/liquibase \
--defaultsFile=${LIQUIBASE_HOME}/mlr-legacy-liquibase/mlr-liquibase/liquibase.properties \
--classpath=${LIQUIBASE_HOME}/lib/postgresql.jar \
--changeLogFile=${LIQUIBASE_HOME}/mlr-legacy-liquibase/mlr-liquibase/changeLog.yml \
--logLevel=debug \
update \
-DMLR_LEGACY_DATA_PASSWORD=${MLR_LEGACY_DATA_PASSWORD} -DMLR_LEGACY_USER_PASSWORD=${MLR_LEGACY_USER_PASSWORD} 

echo "data load scripts"
${LIQUIBASE_HOME}/liquibase \
--defaultsFile=${LIQUIBASE_HOME}/mlr-legacy-liquibase/mlr-liquibase/liquibase.properties \
--classpath=${LIQUIBASE_HOME}/lib/postgresql.jar \
--changeLogFile=${LIQUIBASE_HOME}/mlr-legacy-liquibase/mlr-liquibase/mlrLegacy/testData/changeLog.yml \
--logLevel=debug \
update 
