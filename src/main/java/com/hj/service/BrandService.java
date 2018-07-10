package com.hj.service;

import com.hj.dao.BrandMapper;
import com.hj.dao.GoodsMapper;
import com.hj.po.Brand;
import com.hj.po.Goods;
import com.hj.po.easyui.PageHelper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by hongjin on 2018/7/3.
 */
@Service
public class BrandService  {
    @Resource
    BrandMapper brandMapper;
    public void save(Brand brand){

        if(brand.getBrandID() == null){

            brandMapper.addBrand(brand);

        }else {

            brandMapper.editBrand(brand);
        }

    }

    public List<Brand> datagridGood(@Param("page") PageHelper page, @Param("good") Brand brand){
        if (page != null){
            page.setStart((page.getPage()-1)*page.getRows());
            page.setEnd(page.getRows());
        }

        return brandMapper.datagridGood(page,brand);
    }
    public Long getDatagridTotal(Brand brand){

        return brandMapper.getDatagridTotal(brand);
    }
}
