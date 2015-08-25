From: Guozhonghua <guozhonghua@h3c.com>
Date: Tue, 25 Aug 2015 09:41:35 +0000
Subject: [Ocfs2-devel] Hi, code reviews, some quetions
Message-ID: <71604351584F6A4EBAE558C676F37CA48282609B@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, All

As one node died, another node is to recovery it.
In the function dlm_send_begin_reco_message, if the DLM_BEGIN_RECO_MSG message is sent to one active node failed, the recovery node will retry to send the message until it success.

I think in the function dlm_send_finalize_reco_message, we should send the DLM_FINALIZE_RECO_MSG again to the node when failed.
It should not break out the loop as sending FINALIZE_RECO_MSG to one active node failed.
It would be good to retry send message to active node until all active nodes processed the message successfully.

static int dlm_send_finalize_reco_message(struct dlm_ctxt *dlm)
{

stage2:
        memset(&fr, 0, sizeof(fr));
        fr.node_idx = dlm->node_num;
        fr.dead_node = dlm->reco.dead_node;
        if (stage == 2)
                fr.flags |= DLM_FINALIZE_STAGE2;

        while ((nodenum = dlm_node_iter_next(&iter)) >= 0) {
                if (nodenum == dlm->node_num)
                        continue;

+ retry:
                ret = o2net_send_message(DLM_FINALIZE_RECO_MSG, dlm->key,
                                        &fr, sizeof(fr), nodenum, &status);
                if (ret >= 0)
                        ret = status;
                if (ret < 0) {
                        mlog(ML_ERROR, "Error %d when sending message %u (key "
                             "0x%x) to node %u\n", ret, DLM_FINALIZE_RECO_MSG,
                             dlm->key, nodenum);
                        if (dlm_is_host_down(ret)) {
                                /* this has no effect on this recovery
                                * session, so set the status to zero to
                                * finish out the last recovery */
                                mlog(ML_ERROR, "node %u went down after this "
                                     "node finished recovery.\n", nodenum);
                                ret = 0;
                                continue;
                        }

+                      msleep(100);
+                      goto retry;

-                    break;
                }
        }

As break out in the loop, some nodes process the message OK, others may be failed.
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150825/348601bd/attachment-0001.html 
