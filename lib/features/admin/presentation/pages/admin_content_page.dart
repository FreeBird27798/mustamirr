import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../../../core/utils/confirm_dialog.dart';
import '../../../../core/utils/file_type_style.dart';
import '../../domain/entities/admin_content_entity.dart';
import '../bloc/content/content_bloc.dart';
import '../bloc/content/content_event.dart';
import '../bloc/content/content_state.dart';

class AdminContentPage extends StatelessWidget {
  const AdminContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContentBloc>()..add(LoadContentEvent()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.dark,
            centerTitle: true,
            title: const Text('إدارة المحتوى'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: BlocBuilder<ContentBloc, ContentState>(
                builder: (context, state) {
                  if (state is ContentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContentError) {
                    return Center(child: Text(state.message));
                  } else if (state is ContentLoaded) {
                    if (state.content.isEmpty) {
                      return const Center(child: Text('لا يوجد محتوى'));
                    }
                    return ListView.separated(
                      itemCount: state.content.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _ContentCard(content: state.content[index]),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final AdminContentEntity content;
  const _ContentCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      content.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${content.subject} • ${content.teacherName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: FileTypeStyle.colorFor(content.fileType),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    FileTypeStyle.labelFor(content.fileType),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final bloc = context.read<ContentBloc>();
                  final confirmed = await showConfirmDialog(
                    context,
                    title: 'حذف الدرس',
                    message: 'هل أنت متأكد من حذف "${content.title}"؟',
                    confirmText: 'حذف',
                    confirmColor: Colors.red,
                  );
                  if (confirmed) {
                    bloc.add(DeleteContentEvent(contentId: content.id));
                  }
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () => showComingSoon(context),
                icon: const Icon(
                  Icons.visibility_outlined,
                  color: AppColors.glow,
                ),
              ),
              const Spacer(),
              Text(
                '${content.downloadsCount} طالب نزل الدرس',
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
