From: Chang Limin <changlimin@h3c.com>
Date: Fri, 13 Apr 2012 15:58:28 +0800
Subject: [Ocfs2-devel] Maybe a null point bug in __ocfs2_change_file_space.
Message-ID: <6A84A23BB58148AEAFD0504349CC2A0D@c00148h>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
 Version linux-3.3
In function
static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
                        loff_t len)
{
?
return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,           // file is NULL
                                        change_size);
}

In function
static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
                                  loff_t f_pos, unsigned int cmd,
                                  struct ocfs2_space_resv *sr,
                                  int change_size)
{
if (file->f_flags & O_SYNC)                                                                                   // access file->f_flags result null pointer
           handle->h_sync = 1;
}

Changlimin
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120413/bda432dc/attachment.html 
