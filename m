From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 05 Dec 2008 14:16:23 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] 3 xattr fixes in merge_window.
Message-ID: <4938C737.9060504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
	These 3 fixes are based on xattr transaction merge. So they should be 
merged into your merge_window. Thanks.

patch 1 isn't a bug fix actually. This patch can relieve acl from 
handling the pain of journal_extend.

patch 2 is the fix for ctime. Joel should have reviewed it already.
http://oss.oracle.com/pipermail/ocfs2-devel/2008-December/003475.html. 
and the place of journal_access should be there as we may call 
journal_extend(which may cause journal restart) during xattr set.

patch 3 is a bug fix for xattr journal calculation.

Regards,
Tao
