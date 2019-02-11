
1.优化秒杀接口，目标：2000并发 QPS 4000
思路：要减少数据库的访问，没必要每次都查询数据库
(1)系统初始化，把商品库存数量加载到redis
(2)收到请求，首先看redis的标志，如果已经结束，直接返回，否则进入(3)
(3)入队缓冲，直接返回，并不是返回成功，而是返回排队中，客户端不能直接提示秒杀成功，而是启动定时器，过一段时间再去查是否成功
(4)出队，修改库存，修改结束标志

2.安装RabbitMQ
(1)安装erlang

http://www.erlang.org/downloads OTP 20.1 Source File 

yum install  ncurses-devel
tar xf otp_src_20.1.tar.gz
cd otp_src_20.1
./configure --prefix=/usr/local/erlang20 --without-javac --with-ssl
 make
 make install
 erl验证

(2)安装RabbitMQ
安装python
yum install python -y
安装simplejson
yum install xmlto -y
yum install python-simplejson -y

下载源码：http://www.rabbitmq.com/download.html
Generic Unix -> rabbitmq-server-generic-unix-3.6.14.tar.xz

xz -d rabbitmq-server-generic-unix-3.6.14.tar.xz
tar xf rabbitmq-server-generic-unix-3.6.14.tar
mv rabbitmq_server-3.6.14 /usr/local/rabbitmq

修改环境变量：/etc/profile:
export PATH=$PATH:/usr/local/ruby/bin:/usr/local/erlang20/bin:/usr/local/rabbitmq/sbin
source /etc/profile
./rabbitmq-server启动rabbitMQ server 5672端口监听
rabbitmqctl stop 停止

第二节：
1.SpringBoot集成RabbitMQ
（1）添加依赖
<dependency>  
<groupId>org.springframework.boot</groupId>  
<artifactId>spring-boot-starter-amqp</artifactId>  
</dependency>  

（2）.添加配置：
spring.rabbitmq.host=10.110.3.62
spring.rabbitmq.port=5672
spring.rabbitmq.username=guest
spring.rabbitmq.password=guest
spring.rabbitmq.virtual-host=/
#消费者数量
spring.rabbitmq.listener.simple.concurrency= 10
spring.rabbitmq.listener.simple.max-concurrency= 10
#消费者每次从队列获取的消息数量
spring.rabbitmq.listener.simple.prefetch= 1
#消费者自动启动
spring.rabbitmq.listener.simple.auto-startup=true
#消费失败，自动重新入队
spring.rabbitmq.listener.simple.default-requeue-rejected= true
#启用发送重试
spring.rabbitmq.template.retry.enabled=true 
spring.rabbitmq.template.retry.initial-interval=1000 
spring.rabbitmq.template.retry.max-attempts=3
spring.rabbitmq.template.retry.max-interval=10000
spring.rabbitmq.template.retry.multiplier=1.0

(3)MQSender创建发送者

(4)MQReceiver:创建消费者

2.为了让guest用户能远程连接，修改rabbitmq的配置/usr/local/rabbitmq/etc/rabbitmq/rabbitmq.config
添加：[{rabbit, [{loopback_users, []}]}].
重新启动
http://www.rabbitmq.com/access-control.html

启用管理控制台
./sbin/rabbitmq-plugins enable rabbitmq_management
重启rabbitmq。

3.添加demo测试

4.admin
rabbitmq-plugins enable rabbitmq_management 

5.4种exchange交换机
FanoutExchange: 将消息分发到所有的绑定队列，无routingkey的概念  
HeadersExchange ：通过添加属性key-value匹配  
DirectExchange:  按照routingkey分发到指定队列  
TopicExchange:  多关键字匹配  

第三节：
1.修改秒杀接口
(1)系统初始化，把商品库存加载到redis，是否结束的标记放内存
MiaoshaService implements InitializingBean
(2)收到请求，首先查看内存标记，然后减少redis的库存，如果已经结束，设置标记，直接返回，否则进入(3)
(3)入队缓冲，直接返回，并不是返回成功，而是返回排队中，客户端不能直接提示秒杀成功，而是启动定时器，过一段时间再去查是否成功
(4)出队，修改实际库存
(5)添加查询接口

layer.confirm('恭喜你，秒杀成功！查看订单?', 
	{btn: ['否','是'] }, 
	function(){
		layer.closeAll();
	}, 
	function(){
		layer.closeAll();
		window.location.href="/order/detail/"+status;
	}
);

2.再压测
压测秒杀接口 再压测获取秒杀结果接口

3.Nginx水平扩展，压测 

