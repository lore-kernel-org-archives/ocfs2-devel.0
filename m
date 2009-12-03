From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 03 Dec 2009 19:05:53 +0800
Subject: [Ocfs2-devel] OCFS2: anti stale inode for nfs (for 1.4git)
Message-ID: <4B179B91.9020405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

I am talking about 
http://oss.oracle.com/pipermail/ocfs2-devel/2009-March/004121.html

One customer hits the problem(ocfs2+nfs) --bug 9177818.
and I noticed that patch is not in 1.4 src yet.

I suggested ct to test the patch.
while, no reproduction doesn't mean the patch is good(condition not hit).

so if no reproduction, do we commit the patch to 1.4 src repos?

regards,
wengang.
-- 
--just begin to learn, you are never too late...
