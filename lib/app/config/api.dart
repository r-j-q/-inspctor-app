class Api {
  //login
  static final takeSmsCode = 'code/sms';
  static final takeEmailCode = 'code/email';
  static final register = 'login/register';
  static final bindMobile = 'login/bind/phone';
  static final emailLogin = 'login/email/login';
  static final mobileLogin = 'login/mobile/login';
  static final resetPassword = 'login/forget/pwd';
  static final areaList = 'config/area/list';
  static final userGps = 'user/gps';

  //个人信息
  static final mineInfo = 'user/info';
  //更新信息
  static final editInfo = 'user/editInfo';
  //审核信息提交
  static final apply = 'user/inspector/apply';
  //审核信息
  static final applyIno = 'user/inspectorInfo';
  //钱包信息
  static final wallet = 'user/wallet';
  //支付绑定信息
  static final bindPay = 'user/bing/pay';
  //银行卡列表
  static final bankList = 'user/bank/list';
  //添加银行卡
  static final addBank = 'user/addBank';
  //删除银行卡
  static final deleteBank = 'user/bank/delById';
  //推荐
  static final recommend = 'introduced/introduced';

  //验货列表
  static final orderList = 'grab/order/searchList';
  //验货标准价格
  static final standPrice = 'grab/order/price';
  //申请记录
  static final applyList = 'grab/order/applyList';
  //抢单
  static final orderApply = 'grab/order/apply';
  //一口价
  static final onlyPrice = 'welfare/autoPrice/search';
  //vip价格
  static final vipPrice = 'grab/order/calculation';
  //提交订单
  static final submitOrder = 'grab/order/submit';
  //支付订单
  static final payOrder = 'pay/payOrder';
  //充值支付
  static final payCharge = 'pay/recharge/payOrder';
  //充值
  static final chargeOrder = 'wallet/recharge';
  //提现
  static final cash = 'wallet/apply';
  //账单列表
  static final billList = 'wallet/capital/list';
  //提现列表
  static final cashList = 'wallet/list';
  //充值列表
  static final chargeList = 'wallet/recharge/list';

  //我发布的单
  static final publishList = 'grab/order/push/list';
  //我验货的订单
  static final inspectionList = 'grab/order/inspection/list';
  //订单详情
  static final orderDetail = 'grab/order';
  //开始验货
  static final startOrder = 'grab/order/inspection/start';
  //客户取消订单
  static final cancelOrder = 'grab/order';
  //验货员取消订单
  static final cancelInsOrder = 'grab/order/inspection';
  //报告查询
  static final reportInfo = 'inspection/search';
  //提交报告报告
  static final reportSave = 'inspection/submit';
  //编辑订单
  static final orderEdit = 'grab/order/edit';
  //服务评价
  static final orderComment = 'comment/orderCommentAdd';
  //发起群聊
  static final imGroup = 'grab/order/group/create';

  //保存地址
  static final addressSave = 'address/save';
  //地址列表
  static final addressList = 'address/list';
  //地址删除
  static final addressDelete = 'address/delete';
  //地址编辑
  static final addressEdit = 'address/edit';

  //验证身份证
  static final authIDCard = 'sdk/ocrIdCard';
  //更新app
  static final updateApp = 'config/splash/app';
  //获取百度token
  static final bdToken =
      'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=gUvKmoPQVlCECodlXz8WGHPZ&client_secret=IwKG8AhVUiCkobillxRpCAK0lK2uEnvl';
  //百度地址解析
  static final bdAddress = 'https://aip.baidubce.com/rpc/2.0/nlp/v1/address';
  //高德获取经纬度
  static final gdLat =
      'http://restapi.amap.com/v3/geocode/geo?key=e6cbde4afde7707f3da9e5af69ea5c68';

  //图片上传
  static final uploadImage = 'upload/files';
}
