// This “router.dart” is not covered by License because it is a package from another source.
import 'package:flutter/cupertino.dart';
import 'package:watashi_qr/pages/menu_creator/page_barcode_form.dart';
import 'package:watashi_qr/pages/menu_creator/page_qrcode_form.dart';
import 'package:watashi_qr/pages/menu_history/page_code_view.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_scanner/page_image_scan.dart';
import 'package:watashi_qr/pages/menu_settings/page_about_view.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_form.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_view.dart';
import 'package:watashi_qr/pages/menu_nav_bar.dart';

/// 把'Type'名轉成String
String _typeName(Type type) => type.toString();

const Type _$HOME_ = MenuNavBar;
final Map<String, WidgetBuilder> _$ROUTES_ = <Type, WidgetBuilder>{
  _$HOME_: (_) => MenuNavBar(),
  //menu_scanner
  PageImageScan: (_) => PageImageScan(),
  //menu_creator
  PageQrcodeForm: (_) => PageQrcodeForm(),
  PageBarcodeForm: (_) => PageBarcodeForm(),
  //menu_history
  PageItemView: (_) => PageItemView(),
  PageCodeView: (_) => PageCodeView(),
  //menu_settings
  PageCustomurlsView: (_) => PageCustomurlsView(),
  PageAboutView: (_) => PageAboutView(),
  PageCustomurlsForm: (_) => PageCustomurlsForm(),
}.map((key, value) => MapEntry(key.toString(), value));

/// 路由集中管理器
/// @author xbaistack
final class MyRouter {
  MyRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => navigatorKey.currentContext!;
  static NavigatorState get navigator => navigatorKey.currentState!;

  /// 单实例对象
  static final MyRouter _instance = MyRouter._();

  /// 路由默认主页
  static final String $INDEX = _typeName(_$HOME_);

  static final $ROUTES = _$ROUTES_;

  /// 用于临时接收路由参数,当路由关闭后会自动销毁对应参数
  ///
  /// * @param [arguments] 对应的路由参数
  /// * @return [MyRouter] 返回当前管理对象,以便于设置了参数后可以继续调用实例方法。
  static MyRouter _withArguments(dynamic arguments) =>
      _instance.._arguments = arguments;

  /// 通过反射类型查找对应的路由页面对象,此方法可以利用编辑器的提示功能方便的设置路由参数。
  /// 只有当需要设置路由参数时调用此方法,普通跳转请调用 [routeTo] 方法。
  ///
  /// * @param [context] 上下文构建对象
  /// * @return [RT] 页面路由类型 (Route Type)
  static RT of<RT extends RouterBridge>(BuildContext context) {
    assert(RT != RouterBridge<dynamic>, "You must specify the route type, for example: of<Page>(context)");
    final String name = _typeName(RT);
    assert(hasName(name), "Route \"$RT\" is not registered.");
    _instance._context = context;
    _instance._routeName = name;
    final WidgetBuilder builder = _$ROUTES_[name]!;
    return builder.call(context) as RT;
  }

  /// 替换页面或跳转，不应把参数，如有参数请在参数，请通过 [of] 方法进行跳转。
  ///
  /// * @param [context] 上下文构建对象
  /// * @param [router] 页面路由类型，对页面页面必须是入 [RouterBridge] 对象。
  /// * @return [Future] 异步 Future 对象，用于接收页面返回值。
  static Future<T?> routeTo<T extends Object?>(BuildContext context, Type router) {
    assert(router == RouterBridge<dynamic>, "Your route must be of type RouterBridge");
    final String name = _typeName(router);
    assert(hasName(name), "Route \"$router\" is not registered.");
    return Navigator.pushNamed<T>(context, name);
  }

  /// 检测是否包含某路由定之类型
  ///
  /// * @param [route] 所由的南面类型
  /// * @return [bool] 检测结果
  static bool hasRouter(Type route) => hasName(_typeName(route));

  /// 检测是否包含指定路由名
  ///
  /// * @param [routeName] 定义的路由类型名
  /// * @return [bool] 检测结果
  static bool hasName(String routeName) => _$ROUTES_.containsKey(routeName);

  /// 用干构建页面未知路由，当面路由找不到时会进入到此方法中。
  /// 参数 [settings] 路由的配置参数。
  ///
  /// * @param [settings] 路由配置参数
  /// * @return [CupertinoPageRoute] 页面路由对象
  static CupertinoPageRoute onUnknownRoute<T>(RouteSettings settings) =>
      MyRouter.onGenerateRoute(settings);

  /// 用于构建页面路由,参数 [settings] 是路由的配置参数。
  ///* @param [settings] 路由配置参数
  /// * @return [CupertinoPageRoute] 页面略由对象
  static CupertinoPageRoute onGenerateRoute<T>(RouteSettings settings) {
    final WidgetBuilder builder = _$ROUTES_[settings.name] ?? _$ROUTES_[$INDEX]!;
    return CupertinoPageRoute<T>(builder: builder, settings: settings);
  }

  /// 临时变量
  Object? _arguments;
  String? _routeName;
  BuildContext? _context;

  /// 重置临时变量
  void _resetVariables() {
    _context = null;
    _arguments = null;
    _routeName = null;
  }

  /// 通过 [of] 找到路由对象并设置参数后,需要使用此方法执行页面跳转
  ///
  /// * @return [Future] 异步 Future 对象,用于接收页面返回值。
  Future<T?> to<T extends Object?>() {
    assert(_context != null);
    assert(_routeName != null);
    return Navigator.pushNamed<T>(
      _context!,
      _routeName!,
      arguments: _arguments,
    ).whenComplete(_resetVariables);
  }
}

/// 路由桥接混入类，专门用于桥接路由跳转中的参数处理部分，
/// 使得路由跳转时更便利的感知页面需要接收的参数类型。
/// @author tangxbai
mixin RouterBridge<RT_ARG_TYPE> {
  MyRouter arguments(RT_ARG_TYPE args) => MyRouter._withArguments(args);

  RT_ARG_TYPE? argumentOf(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    return arguments == null ? null : arguments as RT_ARG_TYPE;
  }
}

extension Context on BuildContext {
  Future<T?> routeTo<T extends Object?>(Type router) =>
      Navigator.pushNamed(this, _typeName(router));

  RT routeOf<RT extends RouterBridge>() {
    assert(RT != RouterBridge<dynamic>, "You must specify the route type, for example: \"context.routeOf<Page>()\";");
    return MyRouter.of<RT>(this);
  }
}
