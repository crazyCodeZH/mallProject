package com.hj.dao;

import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;



/**
 * Created by hongjin on 2018/2/24.
 */
public class DynamicDataSource extends AbstractRoutingDataSource {


    /**
     *
     * override determineCurrentLookupKey
     * <p>
     * Title: determineCurrentLookupKey
     * </p>
     * <p>
     * Description: 自动查找datasource
     * </p>
     *
     * @return
     */
    @Override
    protected Object determineCurrentLookupKey() {
        return DBContextHolder.getDbType();
    }
}
