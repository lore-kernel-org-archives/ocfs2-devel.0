From: TaoMa <tao.ma@oracle.com>
Date: Mon, 18 Aug 2008 15:49:56 +0800
Subject: [Ocfs2-devel] [PATCH 0/16] OCFS2: Add extended attributes support.
	V4
Message-ID: <48A929A4.90103@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	Extended attributes are used for storing POSIX ACLs, SELinux labels, 
and user accessible metadata. They are essential for deploying file 
systems exported for workgroup use via samba. The following patches
implement extended attributes on the OCFS2 file system.

Wish you enjoy it.

Regards,
Tiger and Tao
