From: Wengang Wang <wen.gang.wang@Oracle.COM>
Date: Thu, 26 Aug 2010 21:06:33 +0800
Subject: [Ocfs2-devel] [PATCH 0/5] ocfs2/dlm: dynamically allocate lvb
Message-ID: <201008261308.o7QBDRc0003827@rcsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Not all dlm_lock_resource/dlm_lock use lvb. It's a waste of memory for those
since lvb is a "char lvb[64];".

The following patches try to D-alloc(dynamically allocate) lvb for those which
need lvb.

1/5  --D-alloc for dlm_lock_resources.
2/5 ~ 5/5
     --D-alloc for dlm_lock.
2/5  --add "struct dlm_lock_resource *res" parameter to dlm_new_lock() so that
       we can know if we need to allocates lvb for the dlm_lock.
3/5  --add some assertions on lksb->lvb
4/5  --Copies lvb from lksb only when it's meaningful(not NULL).
5/5  --This is a fat patch. I failed to separate it into parts. I does the main
       work for D-alloc for dlm_lock.
