From: Andrew Beekhof <abeekhof@suse.de>
Date: Tue, 18 Nov 2008 11:18:42 +0100
Subject: [Ocfs2-devel] [Patch 2/3] ocfs2-tools: ocfs2_controld leaves
	std(in|out|err) unassigned
Message-ID: <C9B96C29-B614-4113-8126-EF3D7496FE0A@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Leaving std(in|out|err) unassigned causes havoc when included code (in  
this case openais libraries) print to std(err|out).
Specifically, this often leads to memory corruption since the output  
is sent to IPC sockets.

The safest approach is to reopen std(in|out|err) and have them point  
to /dev/null

Signed-off-by: Andrew Beekhof <abeekhof@suse.de>

--- upstream/ocfs2_controld/main.c	2008-10-27 14:55:50.000000000 +0100
+++ dev/ocfs2_controld/main.c	2008-10-27 14:57:24.000000000 +0100
@@ -1027,6 +1027,7 @@ static void lockfile(void)

  static void daemonize(void)
  {
+	int fd;
  	pid_t pid = fork();
  	if (pid < 0) {
  		perror("main: cannot fork");
@@ -1040,6 +1041,18 @@ static void daemonize(void)
  	close(0);
  	close(1);
  	close(2);
+	fd = open("/dev/null", O_RDWR);
+	if (fd >= 0) {
+		/* dup2 to 0 / 1 / 2 (stdin / stdout / stderr) */
+		dup2(fd, STDIN_FILENO);  /* 0 */
+		dup2(fd, STDOUT_FILENO); /* 1 */
+		dup2(fd, STDERR_FILENO); /* 2 */
+
+		/* Should be 0, but just in case it isn't... */
+		if (fd > 2) {
+			close(fd);
+		}
+	}
  	openlog("ocfs2_controld", LOG_PID, LOG_DAEMON);

  	lockfile();
