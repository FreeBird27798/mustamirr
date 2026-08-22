import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../domain/entities/subject_entity.dart';
import '../bloc/subjects/subjects_bloc.dart';
import '../bloc/subjects/subjects_event.dart';
import '../bloc/subjects/subjects_state.dart';
import '../widgets/student_header.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SubjectsBloc>()..add(LoadSubjectsEvent()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const StudentHeader(),
                  const SizedBox(height: 20),
                  const Text(
                    'المواد الدراسية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<SubjectsBloc, SubjectsState>(
                      builder: (context, state) {
                        if (state is SubjectsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is SubjectsError) {
                          return Center(child: Text(state.message));
                        } else if (state is SubjectsLoaded) {
                          if (state.subjects.isEmpty) {
                            return const Center(
                              child: Text('لا توجد مواد بعد'),
                            );
                          }
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.1,
                                ),
                            itemCount: state.subjects.length,
                            itemBuilder: (context, index) =>
                                _SubjectTile(subject: state.subjects[index]),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  final SubjectEntity subject;
  const _SubjectTile({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.inputBackground,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.lessonsPath(subject.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                subject.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${subject.lessonCount} درسًا',
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
