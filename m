From: Gang He <ghe@suse.com>
Date: Fri, 20 May 2016 16:12:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: adjust arguments in dlm_new_lockspace
	called by kernel
Message-ID: <1463731940-13044-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, rgoldwyn@suse.de, ghe@suse.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

We encountered a bug from the customer, the user did a fsck.ocfs2 on the file
system and exited unusually, the lockspace (with LVB size = 32) was left in
the kernel space, next, the user mounted this file system, the kernel module
did not create a new lockspace (LVB size = 64) via calling dlm_new_lockspace() 
function in mounting stage, just used the existing lockspace, created by the 
user space tool, this would lead the user was not able to mount this file 
system from the other nodes, with the error message likes,
dlm: 032F5......: config mismatch: 64,0 nodeid 177127961: 32,0
(mount.ocfs2,26981,46):ocfs2_dlm_init:2995 ERROR: status = -71
ocfs2_mount_volume:1881 ERROR: status = -71
ocfs2_fill_super:1236 ERROR: status = -71
The user was very difficult to find the root cause, then, we brought out this
patch to relieve such problem. 
First, we add one more flag in calling dlm_new_lockspace() function, to make 
sure the lockspace is created by kernel module itself, and this change will 
not affect the backward compatibility.
Second, the obvious error message is reported in the kernel log, let the user 
be more easy to find the root cause.

Gang He (1):
  ocfs2: insure dlm lockspace is created by kernel module

 fs/ocfs2/stack_user.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
1.8.5.6
