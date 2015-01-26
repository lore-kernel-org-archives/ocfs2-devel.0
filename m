From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 26 Jan 2015 12:26:15 -0800
Subject: [Ocfs2-devel] [mmotm:master 396/417] fs/ocfs2/namei.c:2365:1:
 warning: 'ocfs2_orphan_del' uses dynamic stack allocation
In-Reply-To: <201501241157.BPohNdQe%fengguang.wu@intel.com>
References: <201501241157.BPohNdQe%fengguang.wu@intel.com>
Message-ID: <20150126122615.bfb3e099db6c2e00519f57be@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Joseph Qi <joseph.qi@huawei.com>, kbuild-all@01.org, Johannes Weiner <hannes@cmpxchg.org>, Linux Memory Management List <linux-mm@kvack.org>, ocfs2-devel@oss.oracle.com

On Sat, 24 Jan 2015 11:49:02 +0800 kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   git://git.cmpxchg.org/linux-mmotm.git master
> head:   c64429bcc60a702f19f5cfdb5c39277863278a8c
> commit: 98bc024d7e86a52b7c6266f7bf3bac93626f002b [396/417] ocfs2: add functions to add and remove inode in orphan dir
> config: s390-allmodconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout 98bc024d7e86a52b7c6266f7bf3bac93626f002b
>   # save the attached .config to linux build tree
>   make.cross ARCH=s390 
> 
> All warnings:
> 
>    fs/ocfs2/namei.c: In function 'ocfs2_orphan_del':
> >> fs/ocfs2/namei.c:2365:1: warning: 'ocfs2_orphan_del' uses dynamic stack allocation
>     }
>     ^
> 

OK, thanks.  I suppose we can just use the larger size - it's only 4 bytes.

--- a/fs/ocfs2/namei.c~ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix
+++ a/fs/ocfs2/namei.c
@@ -2296,8 +2296,7 @@ int ocfs2_orphan_del(struct ocfs2_super
 		     struct buffer_head *orphan_dir_bh,
 		     bool dio)
 {
-	int namelen = dio ? OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN :
-			OCFS2_ORPHAN_NAMELEN;
+	const int namelen = OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN;
 	char name[namelen + 1];
 	struct ocfs2_dinode *orphan_fe;
 	int status = 0;
