From: Joe Perches <joe@perches.com>
Date: Tue, 22 Oct 2013 22:31:14 -0000
Subject: [Ocfs2-devel] [PATCH 17/24] ocfs2: Convert use of typedef ctl_table
	to struct ctl_table
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Message-ID: <f5f72664f6f5b3b433149e515cacbd0d90bf99f9.1382480758.git.joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/stackglue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 39abf89..cb7ec0b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -643,7 +643,7 @@ error:
 
 #define FS_OCFS2_NM		1
 
-static ctl_table ocfs2_nm_table[] = {
+static struct ctl_table ocfs2_nm_table[] = {
 	{
 		.procname	= "hb_ctl_path",
 		.data		= ocfs2_hb_ctl_path,
@@ -654,7 +654,7 @@ static ctl_table ocfs2_nm_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_mod_table[] = {
+static struct ctl_table ocfs2_mod_table[] = {
 	{
 		.procname	= "nm",
 		.data		= NULL,
@@ -665,7 +665,7 @@ static ctl_table ocfs2_mod_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_kern_table[] = {
+static struct ctl_table ocfs2_kern_table[] = {
 	{
 		.procname	= "ocfs2",
 		.data		= NULL,
@@ -676,7 +676,7 @@ static ctl_table ocfs2_kern_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_root_table[] = {
+static struct ctl_table ocfs2_root_table[] = {
 	{
 		.procname	= "fs",
 		.data		= NULL,
-- 
1.8.1.2.459.gbcd45b4.dirty
