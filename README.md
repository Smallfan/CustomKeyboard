# CustomKeyboard
只是为了回答TalkCod论坛上一位同学提出的[iOS 微信支付密码界面数字键盘问题](http://talkcode.cc/topics/53)

微信等主流产品需要自定义开发键盘，基于两方面考虑：
+ 系统键盘每次触发都会在沙盒里留下缓存数据，在越狱环境下这是十分危险的，所以支付密码必须使用自定义键盘（其实额外还要增加更多防监听，这里就不详细展开了）
+ 为了自定义更多功能键如有些身份证号末尾的X字母等
