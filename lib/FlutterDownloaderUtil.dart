import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class FlutterDownloaderUtil {
  FlutterDownloaderUtil() {
    initDownLoader();
    registCallback();
  }

  Future<void> initDownLoader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );
  }
}

void registCallback() {
  FlutterDownloader.registerCallback(
          (String id, DownloadTaskStatus status, int progress) {
        final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
        send!.send([id, status, progress]);
      });
}

void unbindBackgroundIsolate() {
  IsolateNameServer.removePortNameMapping('downloader_send_port');
}

//返回任务id
Future<String?> requestDownload(String url, String savedDir,
    {required String fileName,
      bool showNotification = true,
      bool openFileFromNotification = true}) async {
  return await FlutterDownloader.enqueue(
      url: url,
      headers: {"auth": "test_for_sql_encoding"},
      savedDir: savedDir,
      fileName: fileName,
      showNotification: showNotification,
      openFileFromNotification: openFileFromNotification);
}

Future<bool> isLoadTaskFileExist(String url) async {
  return isLoad(url).then((value) {
    DownloadTask task = value!;
    File file = File("${task.savedDir}/${task.filename}");
    file.exists().then((value) {
      print("文件存在否 $value");
    });
    return file.exists();
  });
}

// 如果taskRe为null 没有下载过 如果不为null则下载过
Future<DownloadTask?> isLoad(String url) async {
  return getLoadTasks().then((List<DownloadTask>? tasks) {
    DownloadTask taskRe;
    tasks!.forEach((DownloadTask task) {
      if (task.url == url) {
        taskRe = task;
        print("下载过文件查找结果： ${task.toString()}");
      }
    });
  });
}

Future<List<DownloadTask>?> getLoadTasks() async {
  return await FlutterDownloader.loadTasks();
}

void cancelDownload(String taskId) async {
  await FlutterDownloader.cancel(taskId: taskId);
}

void pauseDownload(String taskId) async {
  await FlutterDownloader.pause(taskId: taskId);
}

// 返回新任务id
Future<String?> resumeDownload(DownloadTask task) async {
  return await FlutterDownloader.resume(taskId: task.taskId);
}

Future<String?> retryDownload(String taskId) async {
  return await FlutterDownloader.retry(taskId: taskId);
}

Future<bool> openDownloadedFile(String? taskId) {
  return FlutterDownloader.open(taskId: taskId!);
}

void delete(String taskId) async {
  await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
}

/*
class TaskInfo {
  String taskId;
  DownloadTaskStatus status;
  int progress;
  String url;
  String filename;
  String savedDir;
  int timeCreated;
}
*/