From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 16 Jun 2008 19:00:59 +0200
Subject: [Ocfs2-devel] [PATCH 2/5][BUGFIX] configfs: Protect configfs_dirent
	s_links list mutations
References: <20080616170057.399713501@kerlabs.com>
Message-ID: <20080616171058.722251454@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

An embedded and charset-unspecified text was scrubbed...
Name: configfs-fix-symlink-dirent-linkage-locking.patch
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080616/addf504e/attachment.pl 
