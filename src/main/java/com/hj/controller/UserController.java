package com.hj.controller;
import com.alibaba.fastjson.JSONObject;
import com.hj.dao.DBContextHolder;
import com.hj.po.APPResponseModel;
import com.hj.po.User;
import com.hj.po.UserRole;
import com.hj.po.easyui.DataGrid;
import com.hj.po.easyui.Json;
import com.hj.po.easyui.PageHelper;
import com.hj.service.SysroleService;
import com.hj.service.UserService;
import com.hj.utils.StringCatagroy;
import com.hj.utils.redistakes.UserRedisTakes;
import com.sun.org.apache.bcel.internal.generic.NEW;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;


/**
 * Created by hongjin on 2017/11/13.
 */
@Controller
public class UserController extends BaseController{
    private final Logger log = LoggerFactory.getLogger(UserController.class);
    @Autowired
    private UserService userService;
    @Autowired
    private SysroleService sysroleService;
    @Resource(name = "UserRedisTakes")
    private UserRedisTakes userRedisTakes;
    @RequestMapping("/userQuery")
    public ModelAndView userQuery() throws Exception{
        User redisUser = userRedisTakes.getObj("User","1");
        User user = null;
        if (redisUser == null) {
          user  = userService.findUserById(1);
          if (user != null){
              userRedisTakes.addObj("User","1",user);
          }

        }else {
            user = redisUser;

        }

        ModelAndView modelAndView = new ModelAndView();
        if (user != null){
            modelAndView.addObject("username",user.getNAME());
        }

        modelAndView.setViewName("test");
        return modelAndView;
    }

    @RequestMapping(value = "/user/findUser")
    public String findUserMessage(){
      User user = userService.findUserById(1);
        return "";
    }
    /**
     * 跳转到用户表格页面
     * @return
     */
   @RequestMapping(value = "/user/list",method = RequestMethod.GET)
    public String  userList(Model model){
        return "user/list";
   }
   /*
   *跳转到用户表格界面（tree）
    */
   @RequestMapping(value = "/user/listtree",method = RequestMethod.GET)
    public String userListTree(Model model){
       return "user/list_tree";
   }
   //用户表格
//    @ResponseBody
    @RequestMapping(value = "/user/datagrid",method = RequestMethod.POST)
    public void datagrid(PageHelper page,User user,HttpServletResponse response){
        DBContextHolder.setDbType(DBContextHolder.DB_TYPE_RW);
        DataGrid dg = new DataGrid();
        dg.setTotal(userService.getDatagridTotal(user));
//        List<User> userList = userService.datagridUser(page,user);
        List<UserRole> userList = userService.datagridUserRole(page,user);
        dg.setRows(userList);
        String json = JSONObject.toJSONString(dg);
//        return dg;
        this.write(response,json);
    }
    //新增用户
    @ResponseBody
    @RequestMapping(value = "/user/saveUser",method = RequestMethod.POST)
    public Json addUser(UserRole user){
        Json j = new Json();
        try {
            if (user.getUID() == null ||user.getUID() == 0){
                j.setMsg("用户新增成功");
            }else {
                j.setMsg("用户编辑成功");
            }
            userService.save(user);

            if (user.getRoleId() != null && user.getRoleId()!=0){
            sysroleService.save(user);
            }


            j.setSuccess(true);
            j.setObj(user);
        }catch (Exception e){
        log.info("增加用户出错"+e.getMessage());
            j.setMsg(e.getMessage());
        }
        return j;
    }
    //删除用户
    @ResponseBody
    @RequestMapping(value = "/user/deleteUser",method = RequestMethod.POST)
    public Json deleteuser(User user){
        Json j = new Json();
        try {
            userService.deleteUser(user.getUID());
            sysroleService.deleteUserRole(user.getUID());
            j.setMsg("删除用户成功");
            j.setSuccess(true);
        }catch (Exception e){
            j.setMsg(e.getMessage());
        }
        return j;
    }
    @RequestMapping(value = "/app/updateUser",method = RequestMethod.POST)
    public void updateUser(@RequestBody UserRole user,HttpServletResponse response){
        HashMap hashMap = new HashMap();
        APPResponseModel model = new APPResponseModel();
        User tmpUser = new User();
        try {
            tmpUser = userService.findUserById(user.getUID());
            if (tmpUser == null){
                model.setMessage("该账号不存在");
                model.setCode(201);
            }else {
//                if (tmpUser.getPASSWORD() == user.getPASSWORD()){
//                    model.setMessage("登录成功");
//                    model.setCode(200);
//                }else {
//                    model.setMessage("密码错误");
//                    model.setCode(202);
//                }
                userService.save(user);
                tmpUser = userService.findUserById(user.getUID());
                model.setMessage("修改成功");
                model.setCode(200);
            }


        }catch (Exception e){
            model.setCode(300);
            model.setMessage(e.getMessage());
        }
        hashMap.put("head",model);
        hashMap.put("data",tmpUser);
        String json = JSONObject.toJSONString(hashMap);
        this.write(response,json);
    }
    //用户登录
//    @ResponseBody
    @RequestMapping(value = "/app/login",method = RequestMethod.POST)
    public void login(@RequestBody User user, HttpServletResponse response){
        HashMap hashMap = new HashMap();
        APPResponseModel model = new APPResponseModel();
        User tmpUser;
        try {
      tmpUser = userService.findUserByACCOUNT(user.getACCOUNT());
            if (tmpUser == null){
                model.setMessage("该账号不存在");
                model.setCode(201);
                tmpUser = new User();
            }else {
                if (tmpUser.getPASSWORD().equals(user.getPASSWORD())){
                    model.setMessage("登录成功");
                    model.setCode(200);
                }else {
                    model.setMessage("密码错误");
                    tmpUser = new User();
                    model.setCode(202);
                }
            }


        }catch (Exception e){
            tmpUser = new User();
            model.setCode(300);
            model.setMessage(e.getMessage());
        }
        hashMap.put("head",model);
        hashMap.put("data",tmpUser);
        String json = JSONObject.toJSONString(hashMap);
        this.write(response,json);
    }

    //用户注册
//    @ResponseBody
    @RequestMapping(value = "/app/registerUser",method = RequestMethod.POST)
    public void register(@RequestBody UserRole user,HttpServletResponse response){
        HashMap hashMap = new HashMap();
        APPResponseModel model = new APPResponseModel();
        User tmpUser = new User();
        if (user.getACCOUNT() == null || user.getACCOUNT() == ""){
            model.setMessage("账号不能为空");
            model.setCode(203);
        }else if (user.getNAME() == null || user.getNAME() == ""){
            model.setMessage("用户名不能为空");
            model.setCode(204);
        }else if (user.getPASSWORD()== null || user.getPASSWORD() == ""){
            model.setMessage("密码不能为空");
            model.setCode(205);
        }else {
user.setRoleId(2);

        try {
            tmpUser = userService.findUserByACCOUNT(user.getACCOUNT());
            if (tmpUser == null){
                tmpUser = userService.getUserByName(user.getNAME());
                if (tmpUser == null){
                    userService.save(user);
                    model.setMessage("注册成功");
                    model.setCode(200);
                }else {
                    model.setMessage("用户名已存在");
                    model.setCode(202);
                }


            }else {
                    model.setMessage("账号已存在");
                    model.setCode(201);

            }


        }catch (Exception e){
            model.setCode(300);
            model.setMessage(e.getMessage());
        }
        }
        hashMap.put("head",model);
        hashMap.put("data",user);
        String json = JSONObject.toJSONString(hashMap);
        this.write(response,json);
    }
}
