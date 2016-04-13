From: Gechangwei <ge.changwei@h3c.com>
Date: Wed, 13 Apr 2016 11:17:49 +0000
Subject: [Ocfs2-devel] OCFS2 cache coherent quesiton
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CADEF6@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi OCFS2 experts,

According to OCFS2 user guide, OCFS2 supports cache consistency, which means one node writes to shared disk while another node can get the newest data just written.

I am working hard on OCFS2 kernel code. I am confused that OCFS2 also adopts page cache provided by Linux Kernel, however, page cache does not know anything about other nodes in cluster.

Well, my question is that if data is cached by page cache in one node, how could another node read the newest data from it? At this scenario, the page cache is dirty and the disk data is old. How OCFS2 can support cache consistency?

Thanks,

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160413/f731e386/attachment.html 
