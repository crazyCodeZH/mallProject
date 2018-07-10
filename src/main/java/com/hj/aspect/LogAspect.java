package com.hj.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.*;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.Arrays;

/**
 * Created by hongjin on 2018/1/7.
 */
@Order(value = 1)
@Aspect
@Component
public class LogAspect {
    //将所有的execution抽取出来 注意.*之间不能有空格 这里才是切点
    @Pointcut(value = "execution(* com.hj.controller.*.*(..))")
//    @Pointcut(value = "execution(* com.hj.controller.ArticleController.*(..))")
    public void myPoint() {
    };

    // 第一个*表示返回类型， 第二个*表示全类名
    @Before(value = "myPoint()")
    public void logStart(JoinPoint joinPoint) {
        // 获取参数列表
        Object[] args = joinPoint.getArgs();
        // 获取方法签名
        Signature signature = joinPoint.getSignature();
        // 获取方法名
        String name = signature.getName();
        System.out.println("日志【" + name + "】" + "开始执行" + "参数列表："
                + Arrays.asList(args));
    }

    @After(value = "myPoint()")
    public void logEnd(JoinPoint joint) {
        String name = joint.getSignature().getName();
        System.out.println("日志【" + name + "】最终执行完成");
    }

    @AfterReturning(value = "myPoint()", returning = "rt")
    public void logReturn(JoinPoint joinPoint, Object rt) {
        String name = joinPoint.getSignature().getName();
        System.out.println("日志【" + name + "】方法正常返回" + "返回值：" + rt);
    }

    @AfterThrowing(value = "myPoint()", throwing = "e")
    public void logException(JoinPoint joinPoint, Exception e) {
        String name = joinPoint.getSignature().getName();
        System.out.println("日志【" + name + "】出现异常" + e);
    }
}
