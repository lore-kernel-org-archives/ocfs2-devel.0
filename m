From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 16 Jun 2020 11:38:25 -0700
Subject: [Ocfs2-devel] [v2] ocfs2: fix nfsd over ocfs2 issues
Message-ID: <20200616183829.87211-1-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


This is serial of patches to fix issues on nfsd over ocfs2.
patch 1 is to avoid inode removed while nfsd access it
patch 2 & 3 is to fix a panic issue

v2 <- v1:
- coding style fixing in patch 1
- add patch 4 to fix ignored invalid slot checking

Thanks,
Junxiao.
