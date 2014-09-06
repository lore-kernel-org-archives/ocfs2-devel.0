From: Guozhonghua <guozhonghua@h3c.com>
Date: Sat, 6 Sep 2014 08:13:55 +0000
Subject: [Ocfs2-devel] One question about the usage of dlm_domain_lock of
	OCFS2
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC6A50A@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


As I reviewing the code, there are some of usages I does not understand.
extern spinlock_t dlm_domain_lock;
extern struct list_head dlm_domains;

I think dlm_domain_lock is used to control the access of dlm_domains.

Why not prefer dlm->spinlock to dlm_domain_lock in the function dlm_try_to_join_domain?

The code is as below:
        spin_lock(&dlm_domain_lock);
        dlm->dlm_state = DLM_CTXT_JOINED;
        dlm->num_joins++;
        spin_unlock(&dlm_domain_lock);

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140906/8996e111/attachment.html 
