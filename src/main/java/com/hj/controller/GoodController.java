package com.hj.controller;

import com.alibaba.fastjson.JSONObject;
import com.hj.dao.DBContextHolder;
import com.hj.po.*;
import com.hj.po.easyui.DataGrid;
import com.hj.po.easyui.Json;
import com.hj.po.easyui.PageHelper;
import com.hj.service.GoodsService;
import com.hj.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by hongjin on 2018/6/29.
 */
@Controller
@RequestMapping("/goods")
public class GoodController extends BaseController {
    private final Logger log = LoggerFactory.getLogger(UserController.class);
    @Autowired
    private GoodsService goodService;
    /**
     * 跳转到增加商品界面
     * @return
     */
    @RequestMapping(value = "/addGoodsUI",method = RequestMethod.GET)
    public String  addGood(Model model){
        return "GOODS/addGood";
    }
    /**
     * 跳转到增加商品界面
     * @return
     */
    @RequestMapping(value = "/goodList",method = RequestMethod.GET)
    public String  goodList(Model model){
        return "GOODS/GoodList";
    }
    @ResponseBody
    @RequestMapping(value = "/saveGood",method = RequestMethod.POST)
    public Json addUser(Goods goods){
        Json j = new Json();
        try {
            if (goods.getSid() == null ||goods.getSid() == 0){
                j.setMsg("商品新增成功");
            }else {
                j.setMsg("商品编辑成功");
            }
            goodService.save(goods);

//            if (user.getRoleId() != null && user.getRoleId()!=0){
//                sysroleService.save(user);
//            }


            j.setSuccess(true);
            j.setObj(goods);
        }catch (Exception e){
            log.info("增加商品出错"+e.getMessage());
            j.setMsg(e.getMessage());
        }
        return j;
    }

    @RequestMapping(value = "/app/recommand",method = RequestMethod.GET)
    public void recommand(PageHelper page, HttpServletResponse response){
//        DBContextHolder.setDbType(DBContextHolder.DB_TYPE_RW);
        page = new PageHelper();
        page.setPage(1);
        page.setRows(5);
        page.setOrder("desc");
        page.setSort("sid");
        Goods goods = new Goods();
        goods.setIsRecommand(1);
        HashMap hashMap = new HashMap();
        APPResponseModel model = new APPResponseModel();
        List<Goods> goodList = new ArrayList<Goods>();
        try {
//            DataGrid dg = new DataGrid();
//            dg.setTotal(goodService.getDatagridTotal(goods));

        goodList = goodService.datagridGood(page,goods);
//            dg.setRows(goodList);
            model.setCode(200);
            model.setMessage("");



        }catch (Exception e){
            log.info("查询商品出错"+e.getMessage());
            model.setCode(300);
            model.setMessage(e.getMessage());
//            hashMap.put("head",model);
//            hashMap.put("data",);
//            j.setMsg(e.getMessage());
//            this.write(response,null);
        }
        hashMap.put("head",model);
        hashMap.put("data",goodList);
        String json = JSONObject.toJSONString(hashMap);
        this.write(response,json);
    }
    @RequestMapping(value = "/datagrid",method = RequestMethod.POST)
    public void datagrid(PageHelper page, Goods goods, HttpServletResponse response){
//        DBContextHolder.setDbType(DBContextHolder.DB_TYPE_RW);
        try {
            DataGrid dg = new DataGrid();
            dg.setTotal(goodService.getDatagridTotal(goods));

            List<Goods> goodList = goodService.datagridGood(page,goods);
            dg.setRows(goodList);
            String json = JSONObject.toJSONString(dg);

            this.write(response,json);
        }catch (Exception e){
            log.info("查询商品出错"+e.getMessage());
//            j.setMsg(e.getMessage());
            this.write(response,null);
        }

    }


    @RequestMapping(value = "/app/getGoods",method = RequestMethod.GET)
    public void getAppType(PageHelper page,Goods brand,HttpServletResponse response){
//        Goods brand = new Goods();
        if (brand == null){
            brand = new Goods();
        }
        HashMap hashMap = new HashMap();
        APPResponseModel model = new APPResponseModel();
        List<Goods> goodList = new ArrayList<Goods>();
        try {

            goodList = goodService.datagridGood(page,brand);
            model.setCode(200);
            model.setMessage("");

        }catch (Exception e){
            log.info("查询商品出错"+e.getMessage());
            model.setCode(300);
            model.setMessage(e.getMessage());
        }

        hashMap.put("head",model);
        hashMap.put("data",goodList);
        String json = JSONObject.toJSONString(hashMap);
        this.write(response,json);

    }

}
