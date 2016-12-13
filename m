From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:34 +0800
Subject: [Ocfs2-devel] [PATCH 16/17] inline data: fix build error
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-17-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/defrag-test/frager.c             | 2 +-
 programs/directio_test/directio_test.c    | 2 +-
 programs/discontig_bg_test/spawn_inodes.c | 2 +-
 programs/dx_dirs_tests/index_dir.c        | 2 +-
 programs/inline-data/inline-data.c        | 2 +-
 programs/inline-data/inline-dirs.c        | 2 +-
 programs/reflink_tests/reflink_test.c     | 2 +-
 programs/xattr_tests/xattr-test.c         | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/programs/defrag-test/frager.c b/programs/defrag-test/frager.c
index f510dde..473c31c 100755
--- a/programs/defrag-test/frager.c
+++ b/programs/defrag-test/frager.c
@@ -86,7 +86,7 @@ static int usage(void)
 static void sigchld_handler()
 {
 	pid_t   pid;
-	union wait status;
+	int status;
 
 	while (1) {
 		pid = wait3(&status, WNOHANG, NULL);
diff --git a/programs/directio_test/directio_test.c b/programs/directio_test/directio_test.c
index 7ec5278..21bc32c 100755
--- a/programs/directio_test/directio_test.c
+++ b/programs/directio_test/directio_test.c
@@ -214,7 +214,7 @@ static int teardown(void)
 static void sigchld_handler()
 {
 	pid_t pid;
-	union wait status;
+	int status;
 
 	while (1) {
 		pid = wait3(&status, WNOHANG, NULL);
diff --git a/programs/discontig_bg_test/spawn_inodes.c b/programs/discontig_bg_test/spawn_inodes.c
index 6bb7a93..633f0a9 100755
--- a/programs/discontig_bg_test/spawn_inodes.c
+++ b/programs/discontig_bg_test/spawn_inodes.c
@@ -64,7 +64,7 @@ static int usage(void)
 static void sigchld_handler()
 {
 	pid_t   pid;
-	union wait status;
+	int status;
 
 	while (1) {
 		pid = wait3(&status, WNOHANG, NULL);
diff --git a/programs/dx_dirs_tests/index_dir.c b/programs/dx_dirs_tests/index_dir.c
index 75ea8bd..ffdfa0f 100755
--- a/programs/dx_dirs_tests/index_dir.c
+++ b/programs/dx_dirs_tests/index_dir.c
@@ -926,7 +926,7 @@ void random_test(void)
 static void sigchld_handler()
 {
         pid_t pid;
-        union wait status;
+        int status;
 
         while (1) {
                 pid = wait3(&status, WNOHANG, NULL);
diff --git a/programs/inline-data/inline-data.c b/programs/inline-data/inline-data.c
index 13124d7..daaee3c 100644
--- a/programs/inline-data/inline-data.c
+++ b/programs/inline-data/inline-data.c
@@ -256,7 +256,7 @@ static int teardown(void)
 static void sigchld_handler()
 {
 	pid_t pid;
-	union wait status;
+	int status;
 
 	while (1) {
 		pid = wait3(&status, WNOHANG, NULL);
diff --git a/programs/inline-data/inline-dirs.c b/programs/inline-data/inline-dirs.c
index ac7882f..0db24b9 100644
--- a/programs/inline-data/inline-dirs.c
+++ b/programs/inline-data/inline-dirs.c
@@ -357,7 +357,7 @@ static void run_large_dir_tests(void)
 static void sigchld_handler()
 {
 	pid_t pid;
-	union wait status;
+	int status;
 
 	while (1) {
 		pid = wait3(&status, WNOHANG, NULL);
diff --git a/programs/reflink_tests/reflink_test.c b/programs/reflink_tests/reflink_test.c
index 22386db..2801968 100755
--- a/programs/reflink_tests/reflink_test.c
+++ b/programs/reflink_tests/reflink_test.c
@@ -965,7 +965,7 @@ static int stress_test()
 static void sigchld_handler()
 {
 	pid_t pid;
-	union wait status;
+	int status;
 
 	while (1) {
 		pid = wait3(&status, WNOHANG, NULL);
diff --git a/programs/xattr_tests/xattr-test.c b/programs/xattr_tests/xattr-test.c
index d204aba..77be780 100755
--- a/programs/xattr_tests/xattr-test.c
+++ b/programs/xattr_tests/xattr-test.c
@@ -301,7 +301,7 @@ static void judge_sys_return(int ret, const char *sys_func)
 static void sigchld_handler()
 {
 	pid_t	pid;
-	union wait status;
+	int status;
 	while (1) {
 		pid = wait3(&status, WNOHANG, NULL);
 		if (pid <= 0)
-- 
2.6.6
