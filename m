From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 16 Jun 2008 20:09:11 +0200
Subject: [Ocfs2-devel] [PATCH][BUGFIX] configfs: Fix symlink() to a removing
	item
Message-ID: <20080616180911.GV30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi, the following patch fixes the symlink bug I mentioned a few days ago.
Thanks for your comments.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: configfs-do-not-symlink-to-removing-item.patch
Type: text/x-diff
Size: 3385 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080616/468a2f8f/attachment.bin 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080616/468a2f8f/attachment-0001.bin 
