From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 06 Nov 2008 15:32:23 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] Two minor fixes for Joel's xattr-buckets
	branch.
Message-ID: <49129D87.5040600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	These 2 patches are minor fixes and improvement for your xattr -buckets 
branch. Could you please review them? And if they are OK, please push 
them to your branch so that I can rebase my transaction merge patch set 
on it. One is for ocfs2_defrag_xattr_bucket improvement and another is 
for the ocfs2_buffer_uptodate check in ocfs2_init_xattr_bucket. I saw 
your branch haven't been updated for some days, so create these 2 
patches for you. ;)

Mark,
	these 2 patches can be pushed into Joel's branch so that you can 
finally pull them together with acls after we rebase on it.

Regards,
Tao
