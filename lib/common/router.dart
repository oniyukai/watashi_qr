import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:watashi_qr/pages/menu_creator/page_barcode_form.dart';
import 'package:watashi_qr/pages/menu_creator/page_qrcode_form.dart';
import 'package:watashi_qr/pages/menu_history/page_code_view.dart';
import 'package:watashi_qr/pages/menu_history/page_item_view.dart';
import 'package:watashi_qr/pages/menu_scanner/page_image_scan.dart';
import 'package:watashi_qr/pages/menu_settings/page_about_view.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_form.dart';
import 'package:watashi_qr/pages/menu_settings/page_customurls_view.dart';
import 'package:watashi_qr/pages/menu_nav_bar.dart';

typedef _InitialPage = MenuNavBar;

/// 針對 Web 平台或路徑原因如需讓路徑固定, 請將改為 false, 且注意無法同頁面命名
const bool _useIndexPrefix = true;

class _RouteEntry {
  final String route;
  final WidgetBuilder builder;
  const _RouteEntry(this.route, this.builder);
}

final Map<Type, _RouteEntry> _routingTable = Map.fromEntries(<Type, WidgetBuilder>{
  _InitialPage: (_) => const _InitialPage(),
  // menu_scanner/
  PageImageScan: (_) => const PageImageScan(),
  // menu_creator/
  PageQrcodeForm: (_) => const PageQrcodeForm(),
  PageBarcodeForm: (_) => const PageBarcodeForm(),
  // menu_history/
  PageItemView: (_) => const PageItemView(),
  PageCodeView: (_) => const PageCodeView(),
  // menu_settings/
  PageCustomurlsView: (_) => const PageCustomurlsView(),
  PageAboutView: (_) => const PageAboutView(),
  PageCustomurlsForm: (_) => const PageCustomurlsForm(),
}.entries.mapIndexed((index, entry) => MapEntry(
  entry.key, _RouteEntry(
    '/${_useIndexPrefix ? '$index-' : ''}${entry.key}',
    entry.value))));

String _pageTypeName(Type pageType) {
  final _RouteEntry? routeEntry = _routingTable[pageType];
  assert(routeEntry != null, '_routingTable not included Type<$pageType>, Please register $pageType Route.');
  return routeEntry!.route;
}

/// 基於 Navigator 1.0 設計的頁面路由器,
/// 不用自行維護路由命名, 統一採用 [Type] 路由, 可接受同頁面命名
///
/// - [PA] 只有在帶參數路由且鏈式調用時指定所前往的頁面型別時, [_instance] 才會儲存 [PA]
final class MyRouter<PA extends RouterBridge> {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final String initialRoute = _pageTypeName(_InitialPage);
  static final Map<String, WidgetBuilder> routes = _routingTable.map((k, v) => MapEntry(v.route, v.builder));

  static Route<T> onGenerateRoute<T>(RouteSettings settings) {
    final WidgetBuilder builder = routes[settings.name] ?? routes[initialRoute]!;
    return MaterialPageRoute<T>(builder: builder, settings: settings);
  }

  static Route<T> onUnknownRoute<T>(RouteSettings settings) => MyRouter.onGenerateRoute(settings);

  /// 不帶路由參數地 push 新頁面, 如有參數請透過 [routeToPass]
  ///
  /// * @param [context]
  /// * @param [pageType] 頁面型別, 頁面不管是否可以或需要路由參數
  /// * @return [Future] 用於接收頁面跳回時的回傳
  static Future<R?> routeTo<R extends Object?>(BuildContext context, Type pageType) =>
      Navigator.pushNamed<R>(context, _pageTypeName(pageType));

  /// 帶路由參數地 push 新頁面, 如無參數轉請透過 [routeTo]
  ///
  /// 平替鏈式寫法: [of] 建立臨時實例後, [_to] 帶參數 push 頁面, 請參照 [RoutableContext]
  ///
  /// * @param [context]
  /// * @param [args] 攜帶過去的路由參數
  /// * @return [Future] 用於接收頁面跳回時的回傳
  static Future<R?> routeToPass<R extends Object?, P extends RouterBridge<A>, A>(BuildContext context, A args) {
    assert(P != RouterBridge<dynamic>, 'Routing parameters cannot be specified as dynamic.');
    return Navigator.pushNamed<R>(context, _pageTypeName(P), arguments: args);
  }

  /// 臨時實例位址, 生命週期僅從每次的 [of] 到 [_to] 為止
  static MyRouter? _instance;

  final BuildContext _context;

  const MyRouter._(this._context);

  /// 透過泛型型別尋找對應頁面型別並建立實例, 只在需要路由參數方法時呼叫, 否則請透過 [routeTo]
  ///
  /// * @param [context]
  /// * @return [P] 頁面實例
  static P of<P extends RouterBridge>(BuildContext context) {
    assert(P != RouterBridge<dynamic>, 'You must specify the route type, for example: of<Page>(context)');
    final String route = _pageTypeName(P);
    final WidgetBuilder builder = routes[route]!;
    _instance = MyRouter<P>._(context);
    return builder(context) as P;
  }

  /// 先 [of] 後, 使用該方法代理執行 [routeToPass],
  /// 該方法只有在 [RouterBridge] 實例才有呼叫的渠道
  ///
  /// * @param [args] 傳遞的頁面參數
  /// * @return [Future] 用於接收頁面跳回時的回傳
  Future<R?> _to<R extends Object?, A>(A args) {
    _instance = null;
    return routeToPass<R, PA, dynamic>(_context, args);
  }
}

extension RoutableContext on BuildContext {
  Future<R?> routeTo<R extends Object?>(Type pageType) => MyRouter.routeTo<R>(this, pageType);

  /// 用法:  [RoutableContext].[routeOf]\<[P]\>().toPass(args);
  P routeOf<P extends RouterBridge>() {
    assert(P != RouterBridge<dynamic>, 'You must specify the route type, for example: context.routeOf<Page>()');
    return MyRouter.of<P>(this);
  }
}

/// with 於可帶路由參數的頁面型別,
/// 專門用於橋接路由跳轉中的參數處理, 使得路由跳轉時更便利地感知頁面需要接收的參數型別
mixin RouterBridge<A> {
  Future<R?> toPass<R>(A args) => MyRouter._instance!._to<R, A>(args);

  A? getArgs(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    return arguments == null ? null : arguments as A;
  }
}
