From: Vincent ETIENNE <ve@vetienne.net>
Date: Sat, 02 Mar 2013 11:15:42 +0100
Subject: [Ocfs2-devel] OCFS2 mainline state?
In-Reply-To: <512BCA9E.4090702@nod.at>
References: <512BCA9E.4090702@nod.at>
Message-ID: <5131D14E.8020802@vetienne.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard@nod.at>
Cc: ocfs2-devel@oss.oracle.com, ocfs2-user@oss.oracle.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, mfasheh@suse.com, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, david@sigma-star.at

Hi

I was testing this path in august and  i have two patch applied for ocfs2
The one your referring and also  a changed in file.c

At the time of the test, the two patch were necessary ( and both
suppress a BUG although
not the same one)

Sorry i have no idea if it's still necessary or not, but i prefer to
send you a notice


Vincent ETIENNE


--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1998,7 +1998,7 @@ static long ocfs2_fallocate(struct file *file, int
mode, loff_t offset,
        sr.l_start = (s64)offset;
        sr.l_len = (s64)len;
 
-       return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,
+       return __ocfs2_change_file_space(file, inode, offset, cmd, &sr,
                                         change_size);
 }
 
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index f1fbb4b..66edce7 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -57,7 +57,7 @@
 static int ocfs2_fast_symlink_readpage(struct file *unused, struct page
*page)
 {
        struct inode *inode = page->mapping->host;
-       struct buffer_head *bh;
+       struct buffer_head *bh = NULL;
        int status = ocfs2_read_inode_block(inode, &bh);
        struct ocfs2_dinode *fe;
        const char *link;





Le 25/02/2013 21:33, Richard Weinberger a ?crit :
> Hi!
>
> Today I encountered the following problem on v3.8:
> [   28.940032] general protection fault: 0000 [#1] PREEMPT SMP
> ...
> [   28.984953] Call Trace:
> [   28.986628   [<ffffffffa04cb200>]
> ocfs2_fast_symlink_readpage+0x70/0x1b0 [ocfs2]
> [   28.988302]  [<ffffffff8110dc49>] ? add_to_page_cache_lru+0x29/0x40
> [   28.989942]  [<ffffffff8110ddca>] do_read_cache_page+0x7a/0x170
> [   28.991573]  [<ffffffff8110def4>] read_cache_page_async+0x14/0x20
> [   28.993212]  [<ffffffff8110df09>] read_cache_page+0x9/0x20
> [   28.994827]  [<ffffffff81170ae5>] page_getlink.isra.9+0x25/0x80
> [   28.996442]  [<ffffffff81170b61>] page_follow_link_light+0x21/0x40
> [   28.998049]  [<ffffffff8117090d>] generic_readlink+0x3d/0xa0
> [   28.999653]  [<ffffffff8116c0db>] sys_readlinkat+0xfb/0x130
> [   29.001246]  [<ffffffff8116c126>] sys_readlink+0x16/0x20
> [   29.002839]  [<ffffffff815d8dad>] system_call_fastpath+0x1a/0x1f
>
> To my utter astonishment I found out that the issue is known since
> August 2012.
> And there is also a trivial fix for it.[0]
> The said fix found it's way into Oracle Unbreakable Linux very quickly,
> but not into mainline.[1]
>
> Now I'm wondering how much Oracle really cares about OCFS2 in mainline?
> Maybe there are some more unfixed vulnerabilities?
>
> Not amused,
> //richard
>
> [0] http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg07774.html
> [1] https://oss.oracle.com/pipermail/el-errata/2012-October/003103.html
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
