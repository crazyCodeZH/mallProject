<%--
  Created by IntelliJ IDEA.
  User: hongjin
  Date: 2018/6/29
  Time: 下午2:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>商品管理</title>
    <%@include file="/WEB-INF/jsp/include/easyui_core.jsp"%>
    <script>

        $(function () {

            $('#datagrid').datagrid({
                fit: true,
                url: "${path}/goods/datagrid",
                title: "商品界面",
                loadMsg: "正在加载商品数据，请稍等...",
                idField: 'sid',
                pagination: true,
                border: false,
                nowrap: false,
                fitColumns: true,
                singleSelect: true,
                striped: true,
                rownumbers: true,
                columns: [[
                    { title: '商品名称', field: 'gname', width: 100 },
                    { title: '商品价格', field: 'price', width: 35,},
                    { title: '卖出数量', field: 'salesvol', width: 100 },
                    { title: '剩余数量', field: 'reserve', width: 100 },
                    { title: '商品类型', field: 'brand',formatter:formatterBrand, width: 100 },
                    { title: '是否推荐', field: 'isRecommand', align: "center",formatter:formatterTime, width: 90 }
                ]],
                onLoadSuccess: function (data) {
                    debugger
                    console.log(data)
                    if (data.rows.length > 0) {
                        $('#datagrid').datagrid("selectRow", 0);
                    }else{
                        $.messager.alert("提示","无相关数据","error");
                    }
                }
            });
        })

        var url = "";
        var msgContent = "";
        function formatterTime(value,row,index) {
            if(value == 1){
                return "是";
            }
            return "否";
        }
        function formatterBrand(value,row,index) {
            return value.brandName;
        }
        function addUser() {
            $('#fm').form('clear');
            url = path+"/goods/saveGood";
            msgContent = "编辑成功";


            $('#dlg').dialog('open').dialog('setTitle','新增用户');
        }
        function editUser() {
            $('#fm').form('clear');
            var row = $('#datagrid').datagrid('getSelected');

            if (row){
                var id = row.sid;
                if (row.picUrl != null && row.picUrl != ""){
                    var imgUrl = path+"/Images/file/"+row.picUrl
                    console.log(imgUrl);
                    $('#tmpImgShowE').attr("src",imgUrl);
                }

                $('#dlg').dialog('open').dialog('setTitle','编辑商品');
                $('#fm').form('load',row);
                $('#brandIDInput').combobox({  //为下拉框赋值
                    url:path+"/brand/allType?ver="+Math.random(),
                    valueField: 'brandID',
                    loadMsg: "正在加载，请稍等...",
                    textField: 'brandName',
                    panelWidth: 150,
                    panelHeight: 'auto',
                    value:"无",
                    onLoadSuccess: function (data) {
                        // var json = eval("("+data+")");
//                        var first = data[0];
                        // debugger
                        $(this).combobox('setValue',row.brandID);


                    }
                });


                url = path+"/goods/saveGood?sid="+id;
                msgContent = "编辑商品成功";
            }else{
                $.messager.alert('提示','请选择要编辑得商品','error');

            }
        }
        function deleteUser() {
            var row = $('#datagrid').datagrid('getSelected');
            if (row){
                var id = row.UID;
                $('#dlg_delete').dialog('open').dialog('setTitle','删除用户');
//                $('#deletefm').form('load',row);
                url = path+"/user/deleteUser?UID="+id;
                msgContent = "删除用户成功";
            }else {
                $.messager.alert('提示','请选择要删除的用户','error');
            }
        }

        function saveUser() {


            uplode()
        }

        function saveUser_del() {
            $('#deletefm').form('submit',{
                url:url,
                success:function (result) {
                    var result = eval('('+result+')');
                    if (result.success){
                        $('#dlg_delete').dialog('close');
                        $('#datagrid').datagrid('reload');
                    } else {
                        msgContent = '删除用户失败';
                    }
                    $.messager.show({
                        title: msgContent,
                        msg: result.msg
                    });
                }
            })
        }
        function reload() {
            $('#datagrid').datagrid('reload');
        }
        function FindData() {
            var searchValue = $('#search_username').val();
            if(searchValue == null || searchValue == ""){
                $.messager.alert("提示","不能为空",'error');
            }else{

                initDatagrid($('#datagrid'),"${path}/goods/datagrid?gname="+searchValue)
            }
        }
        function cancelSearch() {

            initDatagrid($('#datagrid'),"${path}/goods/datagrid")

        }
        //选了图片后
        function chooseImgClick(element) {
            var tmpfile = element.files[0];
//			  var name = element.files[i].name;
            var objUrl;
            if(navigator.userAgent.indexOf("MSIE")>0){
                objUrl = element.value;
            }else{
                objUrl = hj_getFileURL(tmpfile);

            }

            $("#tmpImgShowE").attr("src",objUrl);
        }
        //根据选中的图片获取到imgURL
        function hj_getFileURL(file) {
            var url = null ;
            if (window.createObjectURL!=undefined) { // basic
                url = window.createObjectURL(file) ;
            } else if (window.URL!=undefined) { // mozilla(firefox)
                url = window.URL.createObjectURL(file) ;
            } else if (window.webkitURL!=undefined) { // webkit or chrome
                url = window.webkitURL.createObjectURL(file) ;
            }
            return url ;
        }
//监听进度方法
function listenProgress() {

}
        function uplode() {
            showProgress();
            var formData = new FormData();

            var file = $('#fileField')[0].files[0];
            if (file != null){
                formData.append("file",file);


                hj_ajaxUploadPic("${path}/file/upload",formData,listenProgress,function(res) {
                    var json = eval("("+res+")")
                    if(json.success){
                        var fileName = json.obj.fileName;
                        var nowdate=getNowDate();
                        comitGoodsMsg(fileName);
                    }else {
                        closeProgress();
                        alert("上传文件失败")
                        $.messager.progress('close');
                    }
                },function(res) { closeProgress(); $.messager.progress('close'); alert("上传失败");});
            }else {
                comitGoodsMsg("");
            }
        }
        //上传商品信息
        function comitGoodsMsg(fileName) {

            //只有这种赋值才成功 坑爹啊我错在哪里了
            $("input[name=picUrl]").val(fileName)

            $('#fm').form('submit',{
                url:url,
                onSubmit:function () {
                    return $(this).form('validate');
                },
                success:function (result) {
                    closeProgress();
                    var result = eval('('+result+')');
                    if (result.success){
                                $('#dlg').dialog('close');
                                $('#datagrid').datagrid('reload')
                    }else {
                        msgContent = "新增商品失败";
                    }
                    $.messager.show({
                        title:msgContent,
                        msg:result.msg
                    })
                }
            })
        }
    </script>
</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">

    <!-- 员工列表 -->
    <table id="datagrid" toolbar="#toolbar"></table>
    <!-- 按钮 -->
    <div id="toolbar">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-reload" plain="true" onclick="reload();">刷新</a>
        <%--<a href="javascript:void(0);" class="easyui-linkbutton"--%>
           <%--iconCls="icon-add" plain="true" onclick="addUser();">新增</a>--%>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-edit" plain="true" onclick="editUser();">编辑</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="deleteUser();">删除</a>
        <span>商品名:</span><input name="search_username" id="search_username" value="" size=10 />
        <a href="javascript:FindData()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancelSearch();" >取消查询</a>
        <%--<a href="javascript:void(0);" class="easyui-linkbutton"--%>
        <%--iconCls="icon-jright" plain="true" onclick="searchUser();">查询</a>--%>
    </div>

    <!-- 添加/修改对话框 -->
    <div id="dlg" class="easyui-dialog"
         style="width:400px;height:400px;padding:30px 20px" closed="true"
         buttons="#dlg-buttons">
        <form id="fm" method="post">
            <div class="fitem">
                <label>商品名称:</label> <input name="gname" class="easyui-textbox" required="true">
            </div>
            <div class="fitem">
                <label>商品价格:</label> <input validtype="number" name="price" class="easyui-textbox" required="true">
            </div>
            <div class="fitem">
                <label>商品描述:</label> <input  name="DESCRIPTION" class="easyui-textbox" data-options="mutiline:true" style="height:60px" required="true">
            </div>
            <div class="fitem">
                <label>商品总量:</label> <input name="reserve" validtype="number" class="easyui-numberbox" required="true">
            </div>
            <div class="fitem" >
                <label>商品类型:</label> <input name="brandID" id="brandIDInput"  />
            </div>
            <div class="fitem">
                <label>是否推荐:</label><input type="radio" value="1" name="isRecommand">是<input  type="radio" value="0" checked="checked" name="isRecommand">否
            </div>
            <div class="fitem" style="overflow: hidden;display: none">
                <input class="easyui-textbox" name="picUrl"  id="goodPicName">
            </div>
            <div class="fitem">
                <img src="" style="width: 200px;height: 200px" id="tmpImgShowE" alt="">
                <input type="file"  class="file" id="fileField" accept="image/png, image/jpeg, image/gif, image/jpg" size="28" onchange="chooseImgClick(this)" />
            </div>
        </form>
    </div>

    <!-- 添加/修改对话框按钮 -->
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveUser()" style="width:90px">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton"
           iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"
           style="width:90px">取消</a>
    </div>


    <!-- 删除对话框 -->
    <div id="dlg_delete" class="easyui-dialog"
         style="width:300px;height:200px;padding:30px 20px" closed="true"
         buttons="#dlg-del-buttons">
        <div class="ftitle">请谨慎操作</div>
        <form id="deletefm" method="post" novalidate>
            <label>确定删除用户吗？</label>
        </form>
    </div>

    <!-- 删除对话框按钮 -->
    <div id="dlg-del-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveUser_del()" style="width:90px">删除</a>
        <a href="javascript:void(0)" class="easyui-linkbutton"
           iconCls="icon-cancel" onclick="javascript:$('#dlg_delete').dialog('close')"
           style="width:90px">取消</a>
    </div>
    <!-- 查询对话框 -->
    <div id="dlgsearch" class="easyui-dialog"
         style="width:400px;height:380px;padding:30px 20px" closed="true"
         buttons="#dlgsearch-buttons">
        <form id="fmsearch" method="post" novalidate>
            <div class="fitem">
                <label>名称:</label> <input name="NAME" class="easyui-textbox" >
            </div>

            <div class="fitem">
                <label>性别:</label>
                <input type="radio" name="gender" id="gender" value="" style="width:30px;">全部</input>
                <input type="radio" name="gender" id="gender" value="男" style="width:30px;">男</input>
                <input type="radio" name="gender" id="gender" value="女" style="width:30px;">女</input>
            </div>
            <div class="fitem">
                <label>入职时间:</label> <input name="regtime" type="text" class="easyui-datebox" />
            </div>
            <div class="fitem">
                <label>至</label> <input name="regtime" type="text" class="easyui-datebox" />
            </div>

        </form>
    </div>

    <!-- 查询对话框按钮 -->
    <div id="dlgsearch-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="searchUser()" style="width:90px">查询</a>
        <a href="javascript:void(0)" class="easyui-linkbutton"
           iconCls="icon-cancel" onclick="javascript:$('#dlgsearch').dialog('close')"
           style="width:90px">取消</a>
    </div>


</div>
</body>
</html>
