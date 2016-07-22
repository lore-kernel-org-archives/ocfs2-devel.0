From: Gechangwei <ge.changwei@h3c.com>
Date: Fri, 22 Jul 2016 03:11:37 +0000
Subject: [Ocfs2-devel] =?gb2312?b?tPC4tDogIHJldmlldyBwYXRjaDogcmV0dXJuIGlu?=
 =?gb2312?b?IHByb2dyZXNzIGlmIG1hc3RlciBjYW4gbm90IGNsZWFyIHRoZSByZWZtYXAg?=
 =?gb2312?b?Yml0IHJpZ2h0IG5vdw==?=
In-Reply-To: <E3535A62B291B54FBD1D003696CCB53771F30830@H3CMLB14-EX.srv.huawei-3com.com>
References: <E3535A62B291B54FBD1D003696CCB53771F30830@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373220A472E@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,



According to current DLM recovery implementation after another node?s death in cluster, all resources belonging to that dead node will be recovered by the recovery master.



MLE related mastery procedure is not exclusive against DLM recovery. That means when allocating a new lock resource whose owner is unknown before mastery procedure accomplishment, it will not be attached the list on which will be recovered subsequently.



However since its mastery is not done yet, it will be notified that some nodes in vote map pass away. So finally, it will select a proper lock resource master.



BR.





Chauncey Ge.


???: ocfs2-devel-bounces at oss.oracle.com [mailto:ocfs2-devel-bounces at oss.oracle.com] ?? Zhangguanghui
????: 2016?7?22? 10:12
???: ocfs2-devel at oss.oracle.com
??: [Ocfs2-devel] review patch: return in progress if master can not clear the refmap bit right now

hi

We found a BUG situation described below. To fix the bug, I think
dlm_drop_lockres_ref should be 0 in the case of dlm_is_host_down(master goes down).
or list_del_init(&res->purge) should be behind the !master && ret != 0  return,
the res will release int the recovery process while umounting the vol.
Thanks

detail:

 Node 1                                                                           Node 2(master)
    dlm_purge_lockres
       dlm_drop_lockres_ref                                               master goes down
        list_del_init(&res->purge)
       !master && ret != 0  return
       get a failure while umounting.

ocfs2/dlm: return in progress if master can not clear the refmap bit right now

Master returns in-progress to non-master node when it can not clear the refmap bit right now. And non-master node will not purge the lock resource until receiving deref done message.



________________________________
zhangguanghui
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160722/517a0229/attachment-0001.html 
