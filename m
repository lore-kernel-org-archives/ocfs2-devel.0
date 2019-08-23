From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 23 Aug 2019 09:09:45 +0800
Subject: [Ocfs2-devel] [PATCH 0/3 RESEND] fs/ocfs2: remove set but not used
	variables
Message-ID: <1566522588-63786-1-git-send-email-joseph.qi@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

zhengbin (3):
  fs/ocfs2/namei.c: remove set but not used variables
  fs/ocfs2/file.c: remove set but not used variables
  fs/ocfs2/dir.c: remove set but not used variables

 fs/ocfs2/dir.c   | 3 +--
 fs/ocfs2/file.c  | 3 ---
 fs/ocfs2/namei.c | 2 --
 3 files changed, 1 insertion(+), 7 deletions(-)

-- 
1.8.3.1
