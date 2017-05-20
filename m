From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 20 May 2017 12:48:39 +0300
Subject: [Ocfs2-devel] [bug report] ocfs2: check/fix inode block for online
	file check
Message-ID: <20170520094839.f6jtjcao3q3p7ztw@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Gang He,

The patch d56a8f32e4c6: "ocfs2: check/fix inode block for online file
check" from Mar 22, 2016, leads to the following static checker
warning:

	fs/ocfs2/inode.c:179 ocfs2_iget()
	warn: passing zero to 'ERR_PTR'

fs/ocfs2/inode.c
   137                           int sysfile_type)
   138  {
   139          int rc = 0;
                    ^^^^^^
rc is zero.

   140          struct inode *inode = NULL;
   141          struct super_block *sb = osb->sb;
   142          struct ocfs2_find_inode_args args;
   143          journal_t *journal = OCFS2_SB(sb)->journal->j_journal;
   144  
   145          trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
   146                                 sysfile_type);
   147  
   148          /* Ok. By now we've either got the offsets passed to us by the
   149           * caller, or we just pulled them off the bh. Lets do some
   150           * sanity checks to make sure they're OK. */
   151          if (blkno == 0) {
   152                  inode = ERR_PTR(-EINVAL);
   153                  mlog_errno(PTR_ERR(inode));
   154                  goto bail;
   155          }
   156  
   157          args.fi_blkno = blkno;
   158          args.fi_flags = flags;
   159          args.fi_ino = ino_from_blkno(sb, blkno);
   160          args.fi_sysfile_type = sysfile_type;
   161  
   162          inode = iget5_locked(sb, args.fi_ino, ocfs2_find_actor,
   163                               ocfs2_init_locked_inode, &args);
   164          /* inode was *not* in the inode cache. 2.6.x requires
   165           * us to do our own read_inode call and unlock it
   166           * afterwards. */
   167          if (inode == NULL) {
   168                  inode = ERR_PTR(-ENOMEM);
   169                  mlog_errno(PTR_ERR(inode));
   170                  goto bail;
   171          }
   172          trace_ocfs2_iget5_locked(inode->i_state);
   173          if (inode->i_state & I_NEW) {
   174                  rc = ocfs2_read_locked_inode(inode, &args);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
or it's set here

   175                  unlock_new_inode(inode);
   176          }
   177          if (is_bad_inode(inode)) {
   178                  iput(inode);
   179                  inode = ERR_PTR(rc);
                        ^^^^^^^^^^^^^^^^^^^
then we possibly set inode to NULL.  The callers I looked at are not
expecting so it will result in a NULL deref.

   180                  goto bail;
   181          }

regards,
dan carpenter
