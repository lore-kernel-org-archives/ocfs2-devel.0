From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Thu, 12 Jun 2008 17:26:47 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 2/3] configfs: call drop_link() to
	cleanup after create_link() failure
References: <20080612152645.445504681@kerlabs.com>
Message-ID: <20080612152953.667564205@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

An embedded and charset-unspecified text was scrubbed...
Name: configfs-drop_link-if-create_link-fails.patch
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080612/0a2f6195/attachment.pl 
