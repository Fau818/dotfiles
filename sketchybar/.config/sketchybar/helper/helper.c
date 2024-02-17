#include "sketchybar.h"
#include <CoreFoundation/CoreFoundation.h>
#include <time.h>

static int last_day = -1;

void clock_updater(CFRunLoopTimerRef timer, void* info) {
  time_t current_time;
  time(&current_time);
  struct tm *local_time = localtime(&current_time);

  if (last_day != -1 && last_day != local_time->tm_mday) sketchybar("--trigger system_woke");
  last_day = local_time->tm_mday;

  const char* format = "%H:%M:%S";
  char buffer[64];
  strftime(buffer, sizeof(buffer), format, local_time);

  uint32_t message_size = sizeof(buffer) + 64;
  char message[message_size];
  snprintf(message, message_size, "--set calendar label=\"%s\"", buffer);
  sketchybar(message);
}


void handler(env env) {
  // Environment variables passed from sketchybar can be accessed as seen below
  // char* name = env_get_value_for_key(env, "NAME");
  // char* sender = env_get_value_for_key(env, "SENDER");
  // char* info = env_get_value_for_key(env, "INFO");

  // Clock
  CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, (int64_t)CFAbsoluteTimeGetCurrent() + 1.0, 1.0, 0, 0, clock_updater, NULL);
  CFRunLoopAddTimer(CFRunLoopGetMain(), timer, kCFRunLoopDefaultMode);
  CFRunLoopRun();
}

int main (int argc, char** argv) {
  if (argc < 2) {
    printf("Usage: provider \"<bootstrap name>\"\n");
    exit(1);
  }

  event_server_begin(handler, argv[1]);
  return 0;
}
