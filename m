From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Fri, 7 Nov 2014 10:37:41 +0000
Subject: [Ocfs2-devel] how can the [o2hb-x] kernel thread begin running in
	the ocfs2
References: <mailman.16278.1415343839.23890.ocfs2-devel@oss.oracle.com>
Message-ID: <20141107183741199576112@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi


        While mounting -t ocfs2 , the function ocfs2_fill_super is triggered.

In the process, which specific function will trigger the callback of o2hb_region_dev_write,

how can the [o2hb-x] kernel thread begin running?

 thanks


-------------------------------------------------------------------------------------------------------------------------------------
??????????????????????????,?????????????
?????????????????????(??????????????????
???)?????????????????,??????????????????
??!
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20141107/e64e0892/attachment.html 
