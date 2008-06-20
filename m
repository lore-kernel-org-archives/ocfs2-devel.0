From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 20 Jun 2008 14:09:22 +0200
Subject: [Ocfs2-devel] [PATCH] configfs: Fix failing symlink() making
	rmdir() fail
In-Reply-To: <20080619221605.GE10888@mail.oracle.com>
References: <20080619221605.GE10888@mail.oracle.com>
Message-ID: <1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

Joel,

What about this other solution? By the way, it does not even need to
rename CONFIGFS_USET_IN_MKDIR.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 5d7bd4c6d4b797e1eb9a3f8186338274af50ae4e.diff
Type: text/x-patch
Size: 4547 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080620/75a6d6f0/attachment.bin 
