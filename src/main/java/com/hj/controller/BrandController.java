package com.hj.controller;

import com.alibaba.fastjson.JSONObject;
import com.hj.po.APPResponseModel;
import com.hj.po.Brand;
import com.hj.po.Goods;
import com.hj.po.easyui.DataGrid;
import com.hj.po.easyui.Json;
import com.hj.po.easyui.PageHelper;
import com.hj.service.BrandService;
import com.hj.service.GoodsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by hongjin on 2018/7/3.
 */
@Controller
@RequestMapping("/brand")
public class BrandController extends BaseController {
    private final Logger log = LoggerFactory.getLogger(UserController.class);
    @Autowired
    private BrandService brandService;
    /**
     * 跳转到增加商品界面
     * @return
     */
    @RequestMapping(value = "/brandUI",method = RequestMethod.GET)
    public String  addGood(Model model){
        return "Brand/brand";
    }
    /**
     * 跳转到增加商品界面
     * @return
     */
//    @RequestMapping(value = "/goodList",method = RequestMethod.GET)
//    public String  goodList(Model model){
//        return "GOODS/GoodList";
//    }
    @ResponseBody
    @RequestMapping(value = "/saveBrand",method = RequestMethod.POST)
    public Json addUser(Brand brand){
        Json j = new Json();
        try {
            if (brand.getBrandID() == null ||brand.getBrandID() == 0){
                j.setMsg("商品新增成功");
            }else {
                j.setMsg("商品编辑成功");
            }
            brandService.save(brand);

//            if (user.getRoleId() != null && user.getRoleId()!=0){
//                sysroleService.save(user);
//            }


            j.setSuccess(true);
            j.setObj(brand);
        }catch (Exception e){
            log.info("增加商品类型出错"+e.getMessage());
            j.setMsg(e.getMessage());
        }
        return j;
    }

    @RequestMapping(value = "/datagrid",method = RequestMethod.POST)
    public void datagrid(PageHelper page, Brand brand, HttpServletResponse response){
//        DBContextHolder.setDbType(DBContextHolder.DB_TYPE_RW);
        try {
            DataGrid dg = new DataGrid();
            dg.setTotal(brandService.getDatagridTotal(brand));

            List<Brand> goodList = brandService.datagridGood(page,brand);
            dg.setRows(goodList);
            String json = JSONObject.toJSONString(dg);

            this.write(response,json);
        }catch (Exception e){
            log.info("查询商品类型出错"+e.getMessage());
//            j.setMsg(e.getMessage());
            this.write(response,null);
        }

    }




    @RequestMapping(value = "/allType",method = RequestMethod.POST)
    public void allType(PageHelper page, Brand brand, HttpServletResponse response){
//        DBContextHolder.setDbType(DBContextHolder.DB_TYPE_RW);
        try {
//            DataGrid dg = new DataGrid();
//            dg.setTotal(brandService.getDatagridTotal(brand));

            List<Brand> goodList = brandService.datagridGood(page,brand);
//            dg.setRows(goodList);
            String json = JSONObject.toJSONString(goodList);

            this.write(response,json);
        }catch (Exception e){
            log.info("查询商品类型出错"+e.getMessage());
//            j.setMsg(e.getMessage());
            this.write(response,null);
        }

    }

    @RequestMapping(value = "/app/getType",method = RequestMethod.GET)
    public void getAppType(PageHelper page,HttpServletResponse response){
        Brand brand = new Brand();
        HashMap hashMap = new HashMap();
        APPResponseModel model = new APPResponseModel();
        List<Brand> goodList = new ArrayList<Brand>();
        try {

            goodList = brandService.datagridGood(page,brand);
            model.setCode(200);
            model.setMessage("");

        }catch (Exception e){
            log.info("查询商品类型出错"+e.getMessage());
            model.setCode(300);
            model.setMessage(e.getMessage());
        }

        hashMap.put("head",model);
        hashMap.put("data",goodList);
        String json = JSONObject.toJSONString(hashMap);
        this.write(response,json);

    }



}
