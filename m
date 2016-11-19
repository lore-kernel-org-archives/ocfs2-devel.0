From: Gechangwei <ge.changwei@h3c.com>
Date: Sat, 19 Nov 2016 08:32:24 +0000
Subject: [Ocfs2-devel] A question on OCFS2 mount
References: <63ADC13FD55D6546B7DECE290D39E373220B61D0@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E37342E5BA9A@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016?08?31? 18:59, Gechangwei wrote:
Hi,

I am asking for your help on OCFS2 again.

I can?t figure out a segment of code.

In the function dlm_register_domain which is called during mount procedure, below code stays:

         dlm = __dlm_lookup_domain(domain);
         if (dlm) {
                   if (dlm->dlm_state != DLM_CTXT_JOINED) {
                            spin_unlock(&dlm_domain_lock);

                            mlog(ML_ERROR, "fence: dlm(%s) is not joined yet.\n", dlm->name);

                            mlog(0, "This ctxt is not joined yet!\n");
                            wait_event_interruptible(dlm_domain_events,
                                                        dlm_wait_on_domain_helper(
                                                                 domain));
                            goto retry;
                   }

I can see that it wants to look up an existed DLM context object which matches file system?s UUID.

According to my comprehension, DLM context object must be detached from the DLM domain?s list and released when dismount.

So it?s weird that such a DLM context object can be found at the procedure of MOUNT.

Could you please provide a clue for me, if convenient?
 how are u
Many thanks!

BR.

Changwei.

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161119/8c86b03a/attachment-0001.html 
