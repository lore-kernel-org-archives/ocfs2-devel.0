From: Tao Ma <tao.ma@oracle.com>
Date: Fri Mar 28 01:37:52 2008
Subject: [Ocfs2-devel] [PATCH 0/3] Extent tree refactoring. take 1
Message-ID: <20080328083601.GA6284@dhcp-beijing-cdc-10-182-120-173.cn.oracle
	.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the old extent tree operation, we take the hypothesis that we
are using the ocfs2_extent_list in ocfs2_dinode as the tree root.
As xattr will also use ocfs2_extent_list to store large values
xattr enty, we refactor the tree operation so that xattr can use
it directly.

Although xattr is still under development, I'd like to send this
patch set first for review since it is the base of storing large
EA.
