1.redis-benchmark

redis-benchmark -h 127.0.0.1 -p 6379 -c 100 -n 100000 
100个并发连接，100000个请求

redis-benchmark -h 127.0.0.1 -p 6379 -q -d 100 
存取大小为100字节的数据包

redis-benchmark -t set,lpush -n 100000 -q
只测试某些操作的性能

redis-benchmark -n 100000 -q script load “redis.call(‘set’,‘foo’,‘bar’)”
只测试某些数值存取的性能


2.打war包
（1）修改pom
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-tomcat</artifactId>
	<scope>provided</scope>
</dependency>
<finalName>${project.artifactId}</finalName>    
<plugin>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-war-plugin</artifactId>
	<configuration>
		<failOnMissingWebXml>false</failOnMissingWebXml>
	</configuration>
</plugin>
            
（2）修改启动类

public class MainApplication extends SpringBootServletInitializer{
	    @Override
	    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
	        return builder.sources(MainApplication.class);
	    }
}


3.命令行压测
（1）
<plugin>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-maven-plugin</artifactId>
</plugin>


nohup java -jar -server -Xmx2048m -Xms2048m  miaosha.jar &

jmeter.sh -n -t XXX.jmx -l result.jtl

（1）列表页压测-记录QPS
（2）秒杀压测，记录QPS，模拟多用户卖超，改sql，同一个用户卖超加主键

