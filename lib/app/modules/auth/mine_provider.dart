import 'package:inspector/app/config/api.dart';
import 'package:inspector/app/data/address_entity.dart';
import 'package:inspector/app/data/apply_info_entity.dart';
import 'package:inspector/app/data/area_list_entity.dart';
import 'package:inspector/app/data/bank_entity.dart';
import 'package:inspector/app/data/bill_entity.dart';
import 'package:inspector/app/data/bind_pay_entity.dart';
import 'package:inspector/app/data/public_model.dart';
import 'package:inspector/app/data/user_info_entity.dart';
import 'package:inspector/app/data/wallet_entity.dart';
import 'package:inspector/app/tools/public_provider.dart';

class MineProvider {
  //获取验证码
  Future<BaseModel<dynamic>> takeCode(bool isEmail, String account, int? area) {
    return PublicProvider.request<dynamic>(
        path: isEmail ? Api.takeEmailCode : Api.takeSmsCode,
        params: {'phoneOrEmail': account, 'areaCode': area});
  }

  //登录
  Future<BaseModel<UserInfoEntity>> loginAccount<T>(
      String email, String code, int? areaCode, bool isEmail) {
    if (isEmail) {
      return PublicProvider.request<UserInfoEntity>(
          path: Api.emailLogin, params: {'code': code, 'email': email});
    } else {
      return PublicProvider.request<UserInfoEntity>(
          path: Api.mobileLogin,
          params: {'phone': email, 'code': code, 'areaCode': areaCode});
    }
    // return PublicProvider.request<UserInfoEntity>(
    //     path: isEmail ? Api.emailLogin : Api.mobileLogin,
    //     params: {'email': email, 'code': code, 'areaCode': areaCode});
  }

  //注册
  Future<BaseModel<T?>> register<T>(
      String email, String password, String code) {
    return PublicProvider.request<T>(
      path: Api.register,
      params: {'account': email, 'pwd': password, 'code': code},
    );
  }

  //重置密码
  Future<BaseModel<T?>> resetPassword<T>(
      String email, String password, String code) {
    return PublicProvider.request<T>(
      path: Api.resetPassword,
      params: {'email': email, 'pwd': password, 'code': code},
    );
  }

  //国区列表
  Future<BaseModel<List<AreaListEntity>>> areaList<T>() {
    return PublicProvider.request<List<AreaListEntity>>(
      path: Api.areaList,
      isPost: false,
    );
  }

  //个人信息
  Future<BaseModel<UserInfoEntity>> takeMineInfo() {
    return PublicProvider.request<UserInfoEntity>(
        path: Api.mineInfo, isPost: false);
  }

  //推荐
  Future<BaseModel<dynamic>> takeRecommend(String email) {
    return PublicProvider.request<dynamic>(
        path: Api.recommend, params: {'email': email});
  }

  //绑定手机号
  Future<BaseModel<UserInfoEntity>> bindMobile(
      String mobile, String areaCode, String code) {
    var params = {};
    params['phoneOrEmail'] = mobile;
    params['areaCode'] = areaCode;
    params['code'] = code;
    return PublicProvider.request<UserInfoEntity>(
        path: Api.bindMobile, params: params);
  }

  //更新用户信息
  Future<BaseModel<dynamic>> editInfo(
      String phone, String wechatNum, String email, String head, String name) {
    var params = {};
    if (phone.isNotEmpty) {
      params['phone'] = phone;
    }
    if (wechatNum.isNotEmpty) {
      params['wechatNum'] = wechatNum;
    }
    if (email.isNotEmpty) {
      params['email'] = email;
    }
    if (head.isNotEmpty) {
      params['head'] = head;
    }
    if (name.isNotEmpty) {
      params['name'] = name;
    }
    return PublicProvider.request<dynamic>(path: Api.editInfo, params: params);
  }

  //审核员验证
  Future<BaseModel<dynamic>> apply(
    String nick,
    String sex,
    String birthday,
    String province,
    String city,
    String area,
    String price,
    String education,
    String idCardNum,
    String idCardFront,
    String idCardBack,
    String content,
    int accountType,
    bool socialSecurity,
  ) {
    return PublicProvider.request<dynamic>(path: Api.apply, params: {
      'province': province,
      'city': city,
      'area': area,
      'price': price,
      'education': education,
      'idCardNum': idCardNum,
      'idCardFront': idCardFront,
      'idCardBack': idCardBack,
      'content': content,
      'accountType': accountType,
      'socialSecurity': socialSecurity,
    });
  }

  //身份证验证
  Future<BaseModel<dynamic>> authIDCard(String url, String type) {
    return PublicProvider.request<dynamic>(
        path: Api.authIDCard, params: {'imgUrl': url, 'type': type});
  }

  //身份证验证
  Future<BaseModel<ApplyInfoEntity>> applyInfo() {
    return PublicProvider.request<ApplyInfoEntity>(
        path: Api.applyIno, isPost: false);
  }

  //保存地址
  Future<BaseModel<dynamic>> addressSave(
    String factoryName,
    String name,
    String phone,
    String? email,
    String province,
    String city,
    String area,
    String address,
    double? lat,
    double? lon,
    int? addressId,
  ) {
    Map<String, dynamic> params = {
      'factoryName': factoryName,
      'name': name,
      'phone': phone,
      'province': province,
      'city': city,
      'area': area,
      'address': address,
    };
    if (email != null) {
      params['email'] = email;
    }
    if (lat != null) {
      params['lat'] = lat;
    }
    if (lon != null) {
      params['lon'] = lon;
    }
    if (addressId != null) {
      params['id'] = addressId;
      return PublicProvider.request<dynamic>(
          path: Api.addressEdit, params: params);
    } else {
      return PublicProvider.request<dynamic>(
          path: Api.addressSave, params: params);
    }
  }

  //地址列表
  Future<BaseModel<AddressEntity>> addressList(int page, int limit) {
    return PublicProvider.request<AddressEntity>(
        path: Api.addressList, params: {'limit': limit, 'page': page});
  }

  //删除地址
  Future<BaseModel<dynamic>> addressDelete(int id) {
    return PublicProvider.request<dynamic>(
        path: Api.addressDelete + '/$id', isPost: false);
  }

  //编辑地址
  Future<BaseModel<dynamic>> addressEdit(int id) {
    return PublicProvider.request<dynamic>(
        path: Api.addressEdit, params: {'id': id});
  }

  //获取钱包信息
  Future<BaseModel<WalletEntity>> wallet() {
    return PublicProvider.request<WalletEntity>(
        path: Api.wallet, isPost: false);
  }

  //获取支付绑定信息
  Future<BaseModel<List<BindPayEntity>>> bindPayInfo() {
    return PublicProvider.request<List<BindPayEntity>>(
        path: Api.bindPay, isPost: false);
  }

  //支付绑定
  Future<BaseModel<dynamic>> bindPay(
      String account, String image, String name, int type) {
    return PublicProvider.request<dynamic>(path: Api.bindPay, params: {
      'account': account,
      'image': image,
      'name': name,
      'type': type
    });
  }

  //获取银行卡列表
  Future<BaseModel<List<BankEntity>>> bankList() {
    return PublicProvider.request<List<BankEntity>>(path: Api.bankList);
  }

  //删除银行卡
  Future<BaseModel<dynamic>> deleteBank(int id) {
    return PublicProvider.request<dynamic>(
        path: Api.deleteBank + '/$id', isPost: false);
  }

  //删除银行卡
  Future<BaseModel<dynamic>> addBank(String bankAddress, String bankCode,
      String bankHang, String bankName, String userName) {
    return PublicProvider.request<dynamic>(path: Api.addBank, params: {
      'bankAddress': bankAddress,
      'bankCode': bankCode,
      'bankHang': bankHang,
      'bankName': bankName,
      'userName': userName
    });
  }

  //充值订单
  // 充值方式 rechargeMode 1-系统充值 2-PayPai 3-Veem 4-微信 5-支付宝 6-其他
  Future<BaseModel<dynamic>> recharge(
      num price, int rechargeMode, int userAccount) {
    return PublicProvider.request<dynamic>(path: Api.chargeOrder, params: {
      'price': price,
      'rechargeMode': rechargeMode,
      'userAccount': userAccount
    });
  }

  //充值
  Future<BaseModel<dynamic>> payRecharge(String orderId, int payType) {
    return PublicProvider.request<dynamic>(
        path: Api.payCharge, params: {'orderId': orderId, 'payType': payType});
  }

  //充值列表
  Future<BaseModel<dynamic>> rechargeList(int page) {
    return PublicProvider.request<dynamic>(
        path: Api.chargeList, params: {'limit': 20, 'page': page});
  }

  //提现
  Future<BaseModel<dynamic>> takeCash(
      int accountType, int bankId, double price, int type) {
    var params = {};
    // if (accountId > 0) {
    // params['accountId'] = '0';
    // }
    params['accountType'] = accountType;
    if (bankId > 0) {
      params['bankId'] = bankId;
    }
    params['price'] = price;
    params['type'] = type;
    return PublicProvider.request<dynamic>(path: Api.cash, params: params);
  }

  //提现记录
  Future<BaseModel<dynamic>> takeCashList(int page) {
    return PublicProvider.request<dynamic>(
        path: Api.cashList, params: {'limit': 20, 'page': page});
  }

  //账单记录
  Future<BaseModel<BillEntity>> takeBillList(int startTime, int endTime) {
    return PublicProvider.request<BillEntity>(
        path: Api.billList,
        params: {'startTime': startTime, 'endTime': endTime});
  }
}
