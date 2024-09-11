// import 'dart:async';
//
//
// import 'package:_fe_analyzer_shared/src/macros/api.dart';
//
//
// macro
//
// class RoutePage implements ClassDeclarationsMacro {
//
//   const RoutePage();
//
//   @override
//   FutureOr<void> buildDeclarationsForClass(IntrospectableClassDeclaration clazz,
//       MemberDeclarationBuilder builder) async {
//     final className = clazz.identifier.name;
//     _buildRoute(className, builder);
//   }
//
//
//   void _buildRoute(className,
//
//       MemberDeclarationBuilder builder,) {
//     final code =
//     """
//       static const GoRoute path =         GoRoute( path: "/waitlist",   builder: (context, state) {
//     return   $className();
//     },
//     ),
//     """
//     ;
//     builder.declareInType(DeclarationCode.fromString(code));
//   }
// }
