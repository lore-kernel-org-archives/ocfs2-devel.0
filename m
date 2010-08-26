From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 26 Aug 2010 21:34:02 +0800
Subject: [Ocfs2-devel] [PATCH 0/5] ocfs2/dlm: dynamically allocate lvb
In-Reply-To: <201008261308.o7QBDRc0003827@rcsinet13.oracle.com>
References: <201008261308.o7QBDRc0003827@rcsinet13.oracle.com>
Message-ID: <20100826133402.GA5730@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For effect of D-alloc lvb for dlm_lock,

without the patch,
[wwg at desk ~]$ egrep "ocfs2_inode" /proc/slabinfo
ocfs2_inode_cache     26     26   1216   26    8 : tunables    0    0    0 : slabdata      1      1      0

with the patch,
[wwg at cool linux-2.6]$ egrep "ocfs2_inode" /proc/slabinfo
ocfs2_inode_cache     32     32   1024   16    4 : tunables    0    0    0 : slabdata      2      2      0

#that result is for i686.

For allocated dlm_lock, there is a memory save too.

regards,
wengang.

On 10-08-26 21:06, Wengang Wang wrote:
> Not all dlm_lock_resource/dlm_lock use lvb. It's a waste of memory for those
> since lvb is a "char lvb[64];".
> 
> The following patches try to D-alloc(dynamically allocate) lvb for those which
> need lvb.
> 
> 1/5  --D-alloc for dlm_lock_resources.
> 2/5 ~ 5/5
>      --D-alloc for dlm_lock.
> 2/5  --add "struct dlm_lock_resource *res" parameter to dlm_new_lock() so that
>        we can know if we need to allocates lvb for the dlm_lock.
> 3/5  --add some assertions on lksb->lvb
> 4/5  --Copies lvb from lksb only when it's meaningful(not NULL).
> 5/5  --This is a fat patch. I failed to separate it into parts. I does the main
>        work for D-alloc for dlm_lock.
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
