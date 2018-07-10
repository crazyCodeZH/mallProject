package com.hj.po;

import java.io.Serializable;
import java.util.HashMap;

/**
 * Created by hongjin on 2018/7/5.
 */
public class APPResponseModel implements Serializable {
       private String message;
       private Integer code;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }
}
