From: Tao Ma <tao.ma@oracle.com>
Date: Thu Dec 13 23:40:19 2007
Subject: [Ocfs2-devel] [PATCH 0/4] Add online resize support for ocfs2,
	take 3
Message-ID: <20071214073744.GA26638@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Change from V2 to V3 can be found in the patches themselves.

User can do offline resize using tunefs.ocfs2 when a volume isn't
mounted. Now the support for online resize is added into ocfs2.

Please note that the node where online resize goes must already
has the volume mounted. We don't mount it behind the user and the
operation would fail if we find it isn't mounted. As for other
nodes, we don't care whether the volume is mounted or not.

global_bitmap, super block and all the backups will be updated
in the kernel. And if super block or backup's update fails, we
just output some error message in dmesg and continue the work.
