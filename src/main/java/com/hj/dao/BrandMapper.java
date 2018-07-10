package com.hj.dao;

import com.hj.po.Brand;
import com.hj.po.Goods;
import com.hj.po.easyui.PageHelper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Created by hongjin on 2018/7/3.
 */
public interface BrandMapper {
    void addBrand(Brand brand);
    void editBrand(Brand brand);
    List<Brand> datagridGood(@Param("page") PageHelper page, @Param("brand") Brand brand);
    public  Long getDatagridTotal(@Param("brand") Brand brand);
}
