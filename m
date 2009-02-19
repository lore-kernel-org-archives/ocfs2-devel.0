From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 19 Feb 2009 21:10:26 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V3)
In-Reply-To: <20090218013700.GA26431@mail.oracle.com>
References: <200902171255.n1HCsxeo017544@acsinet13.oracle.com>
	<20090218013700.GA26431@mail.oracle.com>
Message-ID: <499D5A42.90702@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> It will need to be added to debugfs.ocfs2's lock displays.
what's this in detail?
the display for "debugfs.ocfs2 -d <lockres>"? such as the rename lock

[root at ocfs2-2 ~]# debugfs.ocfs2 -d R000000000000000000000000000000
Lockres:    R000000000000000000000000000000
Type:       Rename
Block:      0
Generation: 0x00000000

?
