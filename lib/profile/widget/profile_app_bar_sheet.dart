import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/auth_cubit.dart';

// TODO: 다국어 지원 시 수정 필요
class ProfileAppBarSheet extends StatelessWidget {
  const ProfileAppBarSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        // 왼쪽 정렬
        alignment: Alignment.centerLeft,
        child: Material(
          // Material 위젯으로 감싸서 그림자 효과 및 배경색 적용
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Instagram 설정',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                // 구분선
                const Divider(height: 1),
                // 로그아웃
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('로그아웃'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    await context.read<AuthCubit>().signOut();
                  },
                ),
                const Divider(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
