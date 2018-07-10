<%--
  Created by IntelliJ IDEA.
  User: hongjin
  Date: 2017/11/20
  Time: 下午10:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>类型管理</title>
    <%@include file="/WEB-INF/jsp/include/easyui_core.jsp"%>

</head>
<body class="easyui-layout" fit = "true">
<div region="center" border="false" style="overflow: hidden;">
    <table id="datagrid" class="easyui-datagrid" fit="true"
           url="${path}/brand/datagrid"
           toolbar="#toolbar"
           pagination="true"
           fitColumns="true"
           singleSelect="true"
           rownumbers="true"
           striped="true"
           border="false"
           nowrap="false"
    >
        <thead>
        <tr>
            <th field="brandID" width="100">序号</th>
            <th field="brandName" width="100">类型名称</th>

        </tr>
        </thead>
    </table>

    <div id="toolbar">
        <a href="javascript:void(0)"  class="easyui-linkbutton"
           iconCls="icon-reload" plain="true" onclick="reload();">刷新</a>
        <a href="javascript:void(0)"  class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="add();">新增类型</a>
        <a href="javascript:void(0)"  class="easyui-linkbutton"
           iconCls="icon-edit" plain="true" onclick="edit();">编辑类型</a>
        <%--<a href="javascript:void(0)"  class="easyui-linkbutton"--%>
           <%--iconCls="icon-remove" plain="true" onclick="dtl();">删除类型</a>--%>
    </div>

    <div id="dlg" class="easyui-dialog"
         style="width:400px;height:200px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate>
            <div class="fitem">
                <label>类型名称:</label><input name="brandName" class="easyui-textbox" required="true">
            </div>
            <%--<div class="fitem">--%>
                <%--<label>资源地址:</label><input name="url" class="easyui-textbox" required="true">--%>
            <%--</div>--%>
        </form>
    </div>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="save()" style="width:90px">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')" style="width:90px">取消</a>
    </div>


    <!-- 删除对话框 -->
    <div id="dlg_delete" class="easyui-dialog"
         style="width:300px;height:200px;padding:10px 20px" closed="true"
         buttons="#dlg-del-buttons">
        <div class="ftitle">请谨慎操作</div>
        <form id="delfm" method="post" novalidate>
            <label>确定删除类型吗(将删除所属商品)？</label>
        </form>
    </div>

    <!-- 删除对话框按钮 -->
    <div id="dlg-del-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="save_del()" style="width:90px">删除</a>
        <a href="javascript:void(0)" class="easyui-linkbutton"
           iconCls="icon-cancel" onclick="javascript:$('#dlg_delete').dialog('close')"
           style="width:90px">取消</a>
    </div>

</div>
</body>
<script>
    var url;
    var mesTitle;
    function add(){
        $('#dlg').dialog('open').dialog('setTitle','新增类型');
        $('#fm').form('clear');
//        var row = $('#datagrid').datagrid('getSelected');
        url = path+"/brand/saveBrand";
        mesTitle = '新增类型成功';
    }

    function edit() {
        var row = $('#datagrid').datagrid('getSelected');
        if (row){
            var id = row.brandID;
            $('#dlg').dialog('open').dialog('setTitle','编辑类型');
            $('#fm').form('load',row);
            url=path+"/brand/saveBrand?brandID="+id+"";
            mesTitle = '编辑类型成功';
        }else {
            $.messager.alert('提示','请选择要编辑的记录','error');
        }
    }

    function dtl() {
        var row = $('#datagrid').datagrid('getSelected');
        if (row){
            var id = row.brandID;
            $('#dlg_delete').dialog('open').dialog('setTitle','删除类型');
            $('#delfm').form('load',row);
            url = path+"/brand/del?brandID="+id;
            mesTitle = "删除类型成功";
        }else {
            $.messager.alert('提示','请选择要删除的记录','error');
        }
    }
    function save() {
        $('#fm').form('submit',{
            url:url,
            onSubmit:function () {
                return $(this).form('validate');
            },
            success:function (result) {
                var result = eval("("+result+")");
                if (result.success){
                    $('#dlg').dialog('close');
                    $('#datagrid').datagrid('reload');
                }else {
                    mesTitle = "新增菜单失败";
                }
                $.messager.show({
                    title:mesTitle,
                    msg:result.msg
                })
            }
        })
    }

    function save_del() {
        $('#delfm').form('submit',{
            url:url,
            success:function (result) {
                var result = eval("("+result+")");
                if (result.success){
                    $("#dlg_delete").dialog('close');
                    $('#datagrid').datagrid('reload');
                }else {
                    mesTitle = '删除菜单失败';
                }
                $.messager.show({
                    title:mesTitle,
                    msg:result.msg
                })
            }
        })
    }
    function reload() {
        $('#datagrid').datagrid('reload');
    }
</script>
</html>
