import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/data/order_detail_entity.dart';
import 'package:inspector/app/modules/home/controllers/home_controller.dart';
import 'package:inspector/app/modules/home/list_detail/controllers/list_detail_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ListDetailView extends GetView<ListDetailController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back(result: controller.isChange);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.order_detail_title.tr),
          centerTitle: true,
          actions: [
            Obx(() {
              final status = controller.detailEntity.value.status ?? 0;
              final isSelf = controller.detailEntity.value.isSelf ?? false;
              if ((status <= 3 || status == 9) && isSelf) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    controller.detailEntity.value.orderId = controller.orderId;
                    Get.toNamed(Routes.INSPECTION_INFO,
                            arguments: controller.detailEntity.value)
                        ?.then((value) {
                      controller.fetchOrderDetail();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '编辑',
                      style: MFont.medium16.apply(color: MColor.xFF333333),
                    ),
                  ),
                );
              }
              return Container();
            }),
          ],
        ),
        body: Stack(
          children: [
            Container(
              color: MColor.xFFF4F5F7,
              child: Obx(() {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          _baseInfoView,
                          _relatedInfoView,
                          _otherInfoView,
                        ],
                      ),
                    ),
                    _bottomView,
                    SizedBox(height: 30),
                  ],
                );
              }),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  controller.fetchImGroup();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: MColor.skin, width: 2),
                    color: Colors.white.withOpacity(0.6),
                  ),
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 16),
                  child: Center(
                    child: Icon(
                      Icons.group_add_sharp,
                      size: 20,
                      color: MColor.skin,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _relatedInfoView {
    OrderDetailEntity model = controller.detailEntity.value;
    if (model.timeBeans != null && model.timeBeans!.length >= 1) {
      return Column(
        children: [
          _cardView([
            _titleView(Assets.imagesProductNote,
                LocaleKeys.order_detail_related_info.tr),
            for (OrderDateEntity entity in model.timeBeans!) ...{
              _relatedDateView(entity),
            }
          ])
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _relatedDateView(OrderDateEntity model,
      {MainAxisAlignment alignment = MainAxisAlignment.spaceEvenly}) {
    return Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 10),
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            Text(
              model.date ?? '-',
              style: MFont.regular13.apply(color: MColor.xFF838383),
            ),
            Container(color: MColor.xFFDDDDDD, width: 1, height: 24),
            Text(
              LocaleKeys.home_unit.trArgs(['${model.inspectNum ?? 0}', '1']),
              style: MFont.regular13.apply(color: MColor.xFF838383),
            ),
          ],
        ));
  }

  get _baseInfoView {
    OrderDetailEntity model = controller.detailEntity.value;
    var address = model.provinceCity ?? '';
    address += model.address ?? '';
    address += model.factoryName ?? '';
    var priceText = '￥';
    if (model.userAccount == 2) {
      priceText = '\$';
    }
    priceText += '${model.price ?? ''}';
    final isSelf = model.isSelf ?? false;

    // 待验货 3  取消验货
    // 验货中（正在验货，待提交报告） 6  验货报告提交
    // 已完成  4    查看验货报告
    final otherStatus = controller.detailEntity.value.status ?? 0;
    //可以打电话
    var canCall =
        (otherStatus == 3 || otherStatus == 4 || otherStatus == 6) && !isSelf;
    //是否已申请验货
    final isApply = controller.detailEntity.value.isApply ?? false;

    return Column(
      children: [
        _cardView(
          [
            _titleView(Assets.imagesProductNote,
                LocaleKeys.order_detail_inspection_info.tr),
            _infoView(LocaleKeys.order_detail_inspection_product.tr,
                model.productName ?? ''),
            _infoView(LocaleKeys.order_create_time.tr, model.createdTime ?? ''),
            _infoView(LocaleKeys.order_detail_inspection_time.tr,
                model.inspectTime ?? ''),
            Visibility(
              visible: !controller.isApply,
              child: _infoView(LocaleKeys.order_detail_inspection_factory.tr,
                  model.factoryName ?? ''),
            ),
            _infoView(LocaleKeys.order_detail_inspection_address.tr, address),
            Visibility(
              visible: !controller.isApply,
              child: _infoView(LocaleKeys.order_detail_inspection_person.tr,
                  model.name ?? ''),
            ),
            Visibility(
              visible: !controller.isApply,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if ((model.phone ?? '').isNotEmpty && canCall) {
                    launchUrlString('tel:${model.phone}');
                  }
                },
                child: _infoView(LocaleKeys.order_detail_inspection_phone.tr,
                    model.phone ?? '',
                    canAction: canCall ? true : false),
              ),
            ),
            Visibility(
              visible: !controller.isApply,
              child: _infoView(LocaleKeys.order_detail_inspection_email.tr,
                  model.email ?? ''),
            ),
            Visibility(
              visible: controller.isApply,
              child: _infoView(LocaleKeys.order_detail_inspection_day.tr,
                  '${controller.days}${LocaleKeys.publish_day.tr}'),
            ),
            Visibility(
              visible: controller.isApply,
              child: _infoView(LocaleKeys.order_detail_inspection_number.tr,
                  '${controller.peoples}${LocaleKeys.publish_people.tr}'),
            ),
          ],
        ),
        Visibility(
          visible: !controller.isApply,
          child: _cardView(
            [
              _titleView(Assets.imagesProductFactory,
                  LocaleKeys.order_detail_inspection_amount.tr),
              _infoView(LocaleKeys.order_detail_inspection_day.tr,
                  '${controller.days}${LocaleKeys.publish_day.tr}'),
              _infoView(LocaleKeys.order_detail_inspection_number.tr,
                  '${controller.peoples}${LocaleKeys.publish_people.tr}'),
              _infoView(LocaleKeys.order_detail_inspection_price.tr, priceText),
            ],
          ),
        ),
      ],
    );
  }

  get _otherInfoView {
    OrderDetailEntity model = controller.detailEntity.value;
    return Column(
      children: [
        if (controller.detailEntity.value.imageFile.isNotEmpty) ...{
          for (String url in controller.detailEntity.value.imageFile) ...{
            _cardView([
              Container(
                child: Text(
                  LocaleKeys.order_detail_inspection_image.tr,
                  style: MFont.medium15.apply(color: MColor.xFF3D3D3D),
                ),
                padding: EdgeInsets.only(left: 12),
              ),
              _imageView(url),
            ])
          },
        },
        if (controller.detailEntity.value.file.isNotEmpty) ...{
          for (String url in controller.detailEntity.value.file) ...{
            _cardView([
              Container(
                child: Text(
                  LocaleKeys.order_detail_inspection_file.tr,
                  style: MFont.medium15.apply(color: MColor.xFF3D3D3D),
                ),
                padding: EdgeInsets.only(left: 12),
              ),
              _fileView(url),
            ]),
          },
        },
        if ((controller.detailEntity.value.remark ?? '').isNotEmpty) ...{
          _cardView([
            _titleView(Assets.imagesProductTips, LocaleKeys.order_tips.tr),
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              child: Text(
                model.remark ?? '',
                style: MFont.regular13.apply(color: MColor.xFF666666),
              ),
            ),
          ]),
        },
      ],
    );
  }

  get _bottomView {
    // 待支付 ---1 支付
    // 待安排--2  取消订单
    // 验货中(验货当天，验货员开始验货，并启动验货按钮，以便客户和验货员在验货中沟通、包括等待报告中）---6
    // 待评价（已收到报告后未评价）--8    查看报告    去评价
    // 已完成--4  查看报告
    // 已取消（包括取消和退款）---9    继续支付
    // 待验货 3  取消验货
    // 验货中（正在验货，待提交报告） 6  验货报告提交
    // 已完成  4    查看验货报告
    return Obx(() {
      final status = controller.detailEntity.value.status ?? 0;
      //是否已申请验货
      final isApply = controller.detailEntity.value.isApply ?? false;
      //是否可操作
      final isLook = controller.detailEntity.value.isLookInspection ?? false;
      final model = controller.detailEntity.value;
      final isSelf = controller.detailEntity.value.isSelf ?? false;
      if (isSelf) {
        if (status == 1 || status == 9) {
          return Row(
            children: [
              Expanded(
                  child: _textButton(LocaleKeys.contact_bnt.tr, action: () {
                Get.toNamed(Routes.REVIEW, arguments: controller.orderId!)
                    ?.then((value) {
                  controller.fetchOrderDetail();
                });
              })),
              Expanded(
                  child: _textButton(LocaleKeys.order_need_pay.tr, action: () {
                controller.payAction();
              })),
            ],
          );
          // return _textButton(LocaleKeys.order_need_pay.tr, action: () {
          //   controller.payAction();
          // });
        } else if (status == 2) {
          return Row(
            children: [
              Expanded(
                  child: _textButton(LocaleKeys.contact_bnt.tr, action: () {
                Get.toNamed(Routes.REVIEW, arguments: controller.orderId!)
                    ?.then((value) {
                  controller.fetchOrderDetail();
                });
              })),
              Expanded(
                  child: _textButton(LocaleKeys.order_cancel.tr, action: () {
                controller.fetchCancel();
              })),
            ],
          );
          // return _textButton(LocaleKeys.order_cancel.tr, action: () {
          //   controller.fetchCancel();
          // });
        } else if (status == 8) {
          return Row(
            children: [
              Expanded(
                  child: _textButton(LocaleKeys.order_look.tr, action: () {
                Get.toNamed(Routes.CHECK, arguments: controller.orderId!);
              })),
              Expanded(
                  child: _textButton(LocaleKeys.review_next.tr, action: () {
                Get.toNamed(Routes.REVIEW, arguments: controller.orderId!)
                    ?.then((value) {
                  controller.fetchOrderDetail();
                });
              })),
            ],
          );
        } else if (status == 4) {
          return _textButton(LocaleKeys.order_look.tr, action: () {
            Get.toNamed(Routes.CHECK, arguments: controller.orderId!);
          });
        }
      } else {
        if (status == 2) {
          if (isApply) {
            return _textButton(LocaleKeys.order_applying.tr, action: () {
              Get.find<HomeController>()
                  .fetchPrice(controller.orderId ?? 0, false);
            });
          } else {
            return _textButton(LocaleKeys.order_apply.tr, action: () {
              Get.find<HomeController>()
                  .fetchPrice(controller.orderId ?? 0, true);
            });
          }
        } else if (status == 3) {
          return Row(
            children: [
              Expanded(
                  child: _textButton(LocaleKeys.order_cancel.tr, action: () {
                controller.fetchCancel();
              })),
              Expanded(
                  child:
                      _textButton(LocaleKeys.order_inspection.tr, action: () {
                controller.fetchStart();
              })),
            ],
          );
        } else if (status == 4) {
          return _textButton(LocaleKeys.order_look.tr, action: () {
            Get.toNamed(Routes.CHECK, arguments: controller.orderId!);
          });
        } else if (status == 6) {
          return _textButton(LocaleKeys.order_report_next.tr, action: () {
            Get.toNamed(Routes.CHECK, arguments: controller.orderId!);
          });
        }
      }
      return Container();
    });
  }

  Widget _cardView(List<Widget> itemViews) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: 10),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: itemViews,
      ),
    );
  }

  Widget _titleView(String icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 20,
            height: 20,
          ),
          Expanded(
            child: Text(
              text,
              style: MFont.medium15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoView(String title, String value, {bool canAction = false}) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 17, right: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            child: Text(
              '$title:',
              style: MFont.regular13.apply(color: MColor.xFF838383),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: MFont.regular13.apply(
                  color: canAction ? MColor.xFF0081E7 : MColor.xFF666666,
                  heightFactor: 1.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageView(final imageUrl) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final imageProvider = Image.network(imageUrl).image;
            showImageViewer(
              Get.context!,
              imageProvider,
              onViewerDismissed: () {
                print("dismissed");
              },
              immersive: false,
              useSafeArea: true,
            );
          },
          child: Container(
            color: MColor.xFFF4F5F7,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (ctx, _) {
                return Center(
                  child: SpinKitCircle(
                    color: MColor.skin,
                    size: 40.0,
                  ),
                );
              },
              errorWidget: (ctx, a1, a2) {
                return Center(
                  child: SpinKitCircle(
                    color: MColor.skin,
                    size: 40.0,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _fileView(final fileUrl) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (fileUrl.isNotEmpty) {
          launchUrlString(fileUrl);
          return;
        }
      },
      child: Container(
        height: 30,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 5, left: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Text(fileUrl.split('/').last),
          ),
        ),
      ),
    );
  }

  Widget _textButton(String title,
      {@required VoidCallback? action, Color? color}) {
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 18),
      child: TextButton(
        onPressed: () {
          action!();
        },
        child: Text(
          title,
          style: MFont.medium18.apply(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color ?? MColor.skin),
          shape: MaterialStateProperty.all(StadiumBorder()),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
          visualDensity: VisualDensity.compact,
          maximumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
        ),
      ),
    );
  }
}
