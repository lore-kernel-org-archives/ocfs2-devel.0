From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Aug  3 18:47:21 2004
Subject: [Ocfs2-devel] Error show when mv a dir to an exist one
Message-ID: <3ACA40606221794F80A5670F0AF15F84050D80C8@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Try this on ocfs
mkdir a
mkdir b
mv a b
It shows
(26988) ERROR at /home/xling/ocfs/ocfs2/src/namei.c, 1276: need to
change nlink for old dir 3 from 4 to 3

I do not unstandand the follow sentence in ocfs_rename

        if (old_dir != new_dir) {
                if (new_dir_nlink != new_dir->i_nlink)
                        LOG_ERROR_ARGS("need to change nlink for new dir
%llu from %d to %d\n",
                                       OCFS_I(new_dir)->ip_blkno,
(int)new_dir_nlink, new_dir->i_nlink);
        }
        if (old_dir_nlink != old_dir->i_nlink)
                LOG_ERROR_ARGS("need to change nlink for old dir %llu
from %d to %d\n",
                               OCFS_I(old_dir)->ip_blkno,
(int)old_dir_nlink, old_dir->i_nlink);

Are these needed? 
The new_dir_nlink and old_dir_nlink is copied from new_dir and old_dir
when entering ocfs_rename and never assigned
again so it's sure they will not equal to new_dir->i_nlink and
old_dir->i_nlink after rename.
