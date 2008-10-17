From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 17 Oct 2008 12:40:16 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2/xattr: xattr improvement
Message-ID: <48F81730.9020809@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	these 3 patches are already sent out yesterday, but some minor 
modifications are added. And the 3rd patch are rebased on the first 2 
ones. So resend them out.

modifications:
patch 2: Rename ocfs2_xattr_set_handle to __ocfs2_xattr_set_handle since 
tiger need this in acl.
patch 3: rebase it atop of the first 2.

Regards,
Tao
