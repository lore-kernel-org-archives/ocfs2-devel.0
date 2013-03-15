From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 15 Mar 2013 07:22:04 +0000
Subject: [Ocfs2-devel] It may be an ocfs2 bug.
Message-ID: <71604351584F6A4EBAE558C676F37CA417BC8F22@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, every one:

In the function:
static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
                            loff_t len)
{
...
        return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,
                                        change_size);
}


The NULL should be file, such as below, one of our coworker found it.
static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
                            loff_t len)
{
...
        return __ocfs2_change_file_space(file, inode, offset, cmd, &sr,
                                        change_size);
}

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130315/e5714e6f/attachment-0001.html 
