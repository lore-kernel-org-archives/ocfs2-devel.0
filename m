From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 29 Jul 2009 17:04:14 +0800
Subject: [Ocfs2-devel] ocfs2 quota qs.
Message-ID: <4A70108E.5000108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,
	I am now reading quota support in ocfs2 and have some qs. Wish you can 
help me clarify it. Thanks.

ocfs2_quota_write:
	In the comment, you said that "we know the transaction is already 
started", so it should be called within a transaction. But in this 
function, we call ocfs2_extend_no_holes and ocfs2_simple_size_update 
which will start another transaction. So we can survive with nested 
transaction or this scenario will never happen?

Regards,
Tao
