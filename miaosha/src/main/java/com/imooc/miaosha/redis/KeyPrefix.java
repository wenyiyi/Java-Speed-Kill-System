package com.imooc.miaosha.redis;
//key前缀接口
public interface KeyPrefix {
		
	public int expireSeconds();
	
	public String getPrefix();
	
}
