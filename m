From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 9 Apr 2015 22:39:54 +0300
Subject: [Ocfs2-devel] vfs: Add general support to enforce project quota
	limits
Message-ID: <20150409193954.GA19913@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Li Xi,

The patch 847aac644e92: "vfs: Add general support to enforce project
quota limits" from Mar 19, 2015, leads to the following static
checker warning:

	fs/ocfs2/quota_local.c:183 ocfs2_local_check_quota_file()
	error: buffer overflow 'lmagics' 2 <= 2

fs/ocfs2/quota_local.c
   159  /* Check whether we understand format of quota files */
   160  static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
   161  {
   162          unsigned int lmagics[OCFS2_MAXQUOTAS] = OCFS2_LOCAL_QMAGICS;
                                     ^^^^^^^^^^^^^^^
This is 2.  Maybe the fix is to change this to MAXQUOTAS.

   163          unsigned int lversions[OCFS2_MAXQUOTAS] = OCFS2_LOCAL_QVERSIONS;
   164          unsigned int gmagics[OCFS2_MAXQUOTAS] = OCFS2_GLOBAL_QMAGICS;
   165          unsigned int gversions[OCFS2_MAXQUOTAS] = OCFS2_GLOBAL_QVERSIONS;
   166          unsigned int ino[OCFS2_MAXQUOTAS] = { USER_QUOTA_SYSTEM_INODE,
   167                                                GROUP_QUOTA_SYSTEM_INODE };
   168          struct buffer_head *bh = NULL;
   169          struct inode *linode = sb_dqopt(sb)->files[type];
   170          struct inode *ginode = NULL;
   171          struct ocfs2_disk_dqheader *dqhead;
   172          int status, ret = 0;
   173  
   174          /* First check whether we understand local quota file */
   175          status = ocfs2_read_quota_block(linode, 0, &bh);
   176          if (status) {
   177                  mlog_errno(status);
   178                  mlog(ML_ERROR, "failed to read quota file header (type=%d)\n",
   179                          type);
   180                  goto out_err;
   181          }
   182          dqhead = (struct ocfs2_disk_dqheader *)(bh->b_data);
   183          if (le32_to_cpu(dqhead->dqh_magic) != lmagics[type]) {
                                                      ^^^^^^^^^^^^^
This is one past the end of the array.  It used to be limitied in
do_quotactl().

	if (type >= (XQM_COMMAND(cmd) ? XQM_MAXQUOTAS : MAXQUOTAS))

The old logic was the XFS had 3 quotas and everyone else had 2 but now
we raised MAXQUOTAS to 3 as well.

   184                  mlog(ML_ERROR, "quota file magic does not match (%u != %u),"
   185                          " type=%d\n", le32_to_cpu(dqhead->dqh_magic),
   186                          lmagics[type], type);
   187                  goto out_err;
   188          }

regards,
dan carpenter
