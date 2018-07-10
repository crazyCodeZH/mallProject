<%--
  Created by IntelliJ IDEA.
  User: hongjin
  Date: 2018/6/28
  Time: 下午10:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jsp/include/easyui_core.jsp"%>
<html>
<head>
    <title>上传商品</title>
</head>

<body class="easyui-layout" fit="true">
<form method="post" id="fm">
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
    <div class="fitem">
        <label>是否推荐:</label><input class="easyui-radio"  type="radio" value="1" name="isRecommand">是<input class="easyui-radio" type="radio" value="0" checked="checked" name="isRecommand">否
    </div>
    <div class="fitem" >
        <label>商品类型:</label> <input name="brandID" id="brandIDInput"  />
    </div>
    <div class="fitem" style="overflow: hidden;display: none">
       <input class="easyui-textbox" name="picUrl"  id="goodPicName">

    </div>
    <div class="fitem">
        <img src="" style="width: 200px;height: 200px" id="tmpImgShowE" alt="">
        <input type="file"  class="file" id="fileField" accept="image/png, image/jpeg, image/gif, image/jpg" size="28" onchange="chooseImgClick(this)" />
    </div>

</form>
<button class="easyui-button" style="width:120px" type="button" onclick="submitGood()">提交</button>
</body>



<script>
$(function () {
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
            var first = data[0];
            // debugger
            $(this).combobox('setValue',first.brandID);


        }
    });
})
    function onloading(){
        $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body");
        $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
    }
    function removeload() {
        $(".datagrid-mask").remove();
        $(".datagrid-mask-msg").remove();
    }

    function uplode() {
        var formData = new FormData();

        var file = $('#fileField')[0].files[0];
        if (file != null){
            formData.append("file",file);


            onloading();
            hj_ajaxUploadPic("${path}/file/upload",formData,listenProgress,function(res) {
                var json = eval("("+res+")")
                if(json.success){
                    var fileName = json.obj.fileName;
                    var nowdate=getNowDate();
                    comitGoodsMsg(fileName);
                }else {
                    removeload();
                    alert("上传文件失败")
                    $.messager.progress('close');
                }
            },function(res) { removeload(); $.messager.progress('close'); alert("上传失败");});
        }else {
            comitGoodsMsg("");
        }
    }
    //上传商品信息
    function comitGoodsMsg(fileName) {
//        var selectEl = $("#goodPicName")[0];

//        selectEl.value = fileName;
        //只有这种赋值才成功 坑爹啊我错在哪里了
        $("input[name=picUrl]").val(fileName)
//        var value1 =  $("#goodPicName").val();
//        debugger
        var  url = path+"/goods/saveGood"
        var  msgContent = "新增商品成功";
//        debugger
        $('#fm').form('submit',{
            url:url,
            onSubmit:function () {
                return $(this).form('validate');
            },
            success:function (result) {
                removeload();
               result = (result.split("<embed"))[0];

                var result = eval('('+result+')');

                if (result.success){
//                                $('#dlg').dialog('close');
//                                $('#datagrid').datagrid('reload')
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
    //监听进度
    function listenProgress() {

    }
    function submitGood() {
        uplode();
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
</script>
</html>
