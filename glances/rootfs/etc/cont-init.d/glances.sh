#!/usr/bin/env bashio
# ==============================================================================
# Home Assistant Community Add-on: Glances
# Configures Glances
# ==============================================================================
declare protocol
bashio::require.unprotected

# Ensure the configuration exists
if bashio::fs.file_exists '/config/glances/glances.conf'; then
    cp -f /config/glances/glances.conf /etc/glances.conf
else
    mkdir -p /config/glances \
        || bashio::exit.nok "Failed to create the Glances configuration directory"

    # Copy in template file
    cp /etc/glances.conf /config/glances/
fi

# Export Glances data to InfluxDB
if bashio::config.true 'influxdb.enabled'; then
    protocol='http'
    if bashio::config.true 'influxdb.ssl'; then
    protocol='https'
    fi
    # Modify the configuration
    {
        echo "[influxdb]"
        echo "host=$(bashio::config 'influxdb.host')"
        echo "port=$(bashio::config 'influxdb.port')"
        echo "user=$(bashio::config 'influxdb.username')"
        echo "password=$(bashio::config 'influxdb.password')"
        echo "db=$(bashio::config 'influxdb.database')"
        echo "prefix=$(bashio::config 'influxdb.prefix')"
        echo "protocol=${protocol}"
    } >> /etc/glances.conf
fi

if bashio::config.true 'influxdb2.enabled'; then
    protocol='http'
    if bashio::config.true 'influxdb.ssl'; then
    protocol='https'
    fi
    # Modify the configuration
    {
        echo "[influxdb2]"
        echo "host=$(bashio::config 'influxdb2.host')"
        echo "port=$(bashio::config 'influxdb2.port')"
        echo "user=$(bashio::config 'influxdb2.org')"
        echo "password=$(bashio::config 'influxdb2.token')"
        echo "db=$(bashio::config 'influxdb2.bucket')"
        echo "prefix=$(bashio::config 'influxdb2.prefix')"
        echo "protocol=${protocol}"
    } >> /etc/glances.conf
fi
