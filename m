From: Gechangwei <ge.changwei@h3c.com>
Date: Tue, 12 Apr 2016 02:51:29 +0000
Subject: [Ocfs2-devel] An issue on OCFS2 fsck tool
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CADD1B@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi OCFS2 experts,

I encountered an issue during checking an OCFS2 volume via OCFS2 fsck tool aka fsck.ocfs2. I am not sure if I can get some help from you.

I found that as long as there was some dirty data held by journal, fsck.ocfs2 tool would start an O2HB thread and tried to replay the journal.

What bothers me is that even the file system checking and recovering procedure is done; the O2HB thread is still active.

I think this is not reasonable. I doubt this was a BUG in fsck.ocfs2. Do you have any comments on this issue?

I am looking forward to getting a little help from you.

Many thanks.

Best regards.


Gechangwei
H3C Technologies Co., Limited


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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160412/a98f446e/attachment.html 
