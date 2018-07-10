package com.hj.service;

import com.hj.dao.GoodsMapper;
import com.hj.po.Goods;
import com.hj.po.User;
import com.hj.po.UserRole;
import com.hj.po.easyui.PageHelper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by hongjin on 2018/6/29.
 */
@Service
public class GoodsService {
    @Resource
    GoodsMapper goodsMapper;
    public void save(Goods goods){

        if(goods.getSid() == null){
//            if(user.getHEADURL() == null){
//                user.setHEADURL("test.jpg");
//            }
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
//            System.out.println());// new Date()为获取当前系统时间
            String nowDay =  df.format(new Date());
            goods.setAddTime(nowDay);
            goodsMapper.addGoods(goods);

        }else {
//            userMapper.editUser(user);
            goodsMapper.editGoods(goods);
        }

    }

    public List<Goods> datagridGood(@Param("page") PageHelper page, @Param("good") Goods good){
        page.setStart((page.getPage()-1)*page.getRows());
        page.setEnd(page.getRows());
          return goodsMapper.datagridGood(page,good);
    }
    public Long getDatagridTotal(Goods goods){

        return goodsMapper.getDatagridTotal(goods);
    }
}
