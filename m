From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  4 May 2009 16:10:31 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Hold mmap_sem while calling
	get_user_pages()
In-Reply-To: <1241478632-16369-1-git-send-email-sunil.mushran@oracle.com>
References: <1241478632-16369-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1241478632-16369-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Kurt Garloff <garloff@novell.com>

This patch adds locking around get_user_pages() in ocfs2_get_write_source()
so as to prevent the vmas from changing underneath.

Fixes Novell bugzilla# 485827

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 0c8e03a..267389c 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1967,9 +1967,11 @@ static struct page * ocfs2_get_write_source(char **ret_src_buf,
 		 * of the meta data locks in order to preserve locking
 		 * order in case of page fault.
 		 */
+		down_read(&current->mm->mmap_sem);
 		ret = get_user_pages(current, current->mm,
 				     (unsigned long)buf & PAGE_CACHE_MASK, 1,
 				     0, 0, &src_page, NULL);
+		up_read(&current->mm->mmap_sem);
 		if (ret == 1)
 			*ret_src_buf = kmap(src_page) + off;
 		else
-- 
1.5.6.3
