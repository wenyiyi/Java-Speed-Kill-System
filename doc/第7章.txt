1.隐藏接口地址
请求秒杀接口之前先去请求秒杀路径

2.数学公式验证码, 生成数学计算题，SriptEngine
错峰请求秒杀接口
请求完了详情接口之后，接着去请求获取验证码的接口
在点击秒杀获取路径的时候，去验证验证码

public BufferedImage createVerifyCodeImage(long userId, long goodsId) {
	int width = 80;
	int height = 32;
	//create the image
	BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
	Graphics g = image.getGraphics();
	// set the background color
	g.setColor(new Color(0xDCDCDC));
	g.fillRect(0, 0, width, height);
	// draw the border
	g.setColor(Color.black);
	g.drawRect(0, 0, width - 1, height - 1);
	// create a random instance to generate the codes
	Random rdm = new Random();
	// make some confusion
	for (int i = 0; i < 50; i++) {
		int x = rdm.nextInt(width);
		int y = rdm.nextInt(height);
		g.drawOval(x, y, 0, 0);
	}
	// generate a random code
	String verifyCode = createVerifyCode();
	g.setColor(new Color(0, 100, 0));
	g.setFont(new Font("Candara", Font.BOLD, 24));
	g.drawString(verifyCode, 8, 24);
	g.dispose();
	//把验证码存到redis中
	int rnd = calc(verifyCode);
	redisService.set(MiaoshaKey.verify_code, userId+","+goodsId, rnd);
	//输出图片	
	return image;
}

BufferedImage image = miaoshaService.createVerifyCodeImage(user.getId(), goodsId);
response.setContentType("image/jpeg");
OutputStream out = response.getOutputStream();
ImageIO.write(image, "jpeg", out);
out.close();
return null;

<div class="row">
				<div class="form-inline">  
					<img id="verifyCodeImg" width="80" height="32" style="display:none" onclick="refreshVerifyCode()"/>
					<input class="form-control" type="text" name="verifyCode" id="verifyCode" style="display:none" />
				    <button class="btn btn-primary" id="buyButton" onclick="doMiaosha()">立即秒杀</button>
				    <input type="hidden" name="goodsId"  id="goodsId" />
				</div>
			</div>

3.接口防刷，针对需要用户登录的接口做限流
比如：限制10秒以内对某个接口最多请求10次，还是用redis
以秒杀接口为例，可以把用户和限流用拦截器来做

4.回仓：30分钟不支付订单自动取消
30分钟以后，扫描下秒杀订单，看有哪些还没支付，把订单状态置为已经取消，可秒杀数量+1，redis的秒杀结束的标志位还原，内存的数量还原
不演示了
