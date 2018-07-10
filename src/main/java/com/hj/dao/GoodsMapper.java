package com.hj.dao;

import com.hj.po.Goods;
import com.hj.po.User;
import com.hj.po.easyui.PageHelper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Created by hongjin on 2018/6/28.
 */
public interface GoodsMapper {
    void addGoods(Goods goods);
    void editGoods(Goods goods);
    List<Goods> datagridGood(@Param("page") PageHelper page, @Param("good") Goods good);
    public  Long getDatagridTotal(@Param("good") Goods good);
}
