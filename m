From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 25 Sep 2018 15:53:47 +0300
Subject: [Ocfs2-devel] [bug report] ocfs2: fix a static checker warning
Message-ID: <20180925125347.GA1300@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sorry, Gang He,

The error message is still there.

The patch 8c4d5a438716: "ocfs2: fix a static checker warning" from
Jul 6, 2017, leads to the following static checker warning:

	fs/ocfs2/export.c:127 ocfs2_get_dentry()
	warn: 'inode' can also be NULL

fs/ocfs2/inode.c
   161          args.fi_sysfile_type = sysfile_type;
   162  
   163          inode = iget5_locked(sb, args.fi_ino, ocfs2_find_actor,
   164                               ocfs2_init_locked_inode, &args);
   165          /* inode was *not* in the inode cache. 2.6.x requires
   166           * us to do our own read_inode call and unlock it
   167           * afterwards. */
   168          if (inode == NULL) {
   169                  inode = ERR_PTR(-ENOMEM);
   170                  mlog_errno(PTR_ERR(inode));
   171                  goto bail;
   172          }
   173          trace_ocfs2_iget5_locked(inode->i_state);
   174          if (inode->i_state & I_NEW) {
   175                  rc = ocfs2_read_locked_inode(inode, &args);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Imagine this succeeds.

   176                  unlock_new_inode(inode);
   177          }
   178          if (is_bad_inode(inode)) {
   179                  iput(inode);
   180                  inode = ERR_PTR(rc);
                        ^^^^^^^^^^^^^^^^^^^
We're returning ERR_PTR(0) which is NULL which leads to a NULL
dereference in the caller.

   181                  goto bail;
   182          }
   183  

regards,
dan carpenter
