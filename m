From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Thu, 12 Jun 2008 15:31:29 +0200
Subject: [Ocfs2-devel] [PATCH 3/3][BUGFIX] configfs: Fix deadlock with
	racing rmdir() and rename()
References: <20080612133126.335618468@kerlabs.com>
Message-ID: <20080612134204.097928479@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

An embedded and charset-unspecified text was scrubbed...
Name: configfs-fix-rmdir-vs-rename-deadlock.patch
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080612/4c8f4ea8/attachment.pl 
