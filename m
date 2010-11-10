From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Nov 2010 10:51:34 +0800
Subject: [Ocfs2-devel] [PATCH 0/5] The first try of adding trace event to
	ocfs2.
Message-ID: <4CDA08B6.2070002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
This patch set is my first try to add trace event to ocfs2.

Wengang Wang has did some work in this field about one year ago.
http://oss.oracle.com/pipermail/ocfs2-devel/2009-September/005230.html
But at that time we don't have ocfs2 1.6 introduced, so we delay this 
work until now after ocfs2 1.6 and UEK(Unbreakable Enterprise Kernel) 
are released.

Patch 1 is actually a clean up and unrelated to trace event, but if we 
don't have this one, patch 2/3/4/5 won't be applied cleanly, so I'd like 
to include it here.

Patch 2 and 3 are my attempt to remove ML_ENTRY and ML_EXIT. These 2 
flags are overused and actually enabling them means disasters in our 
debugging.

Patch 4/5 are the real patches for trace event. Please review these 2 
patches. And if it is ok, I will go ahead with other files under fs/ocfs2/.

Regards,
Tao
