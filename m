From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 14 Oct 2011 16:57:13 +0800
Subject: [Ocfs2-devel] avoid being purged when queued for assert_master
In-Reply-To: <4E97818A.5070902@oracle.com>
References: <4E964332.1020201@oracle.com>
	<20111013015137.GA5565@laptop.jp.oracle.com>
	<20111013020712.GB5565@laptop.jp.oracle.com>
	<4E9648E1.3070508@oracle.com>
	<20111013021356.GD5565@laptop.jp.oracle.com>
	<4E970D2E.2080206@oracle.com>
	<20111013233549.GA2982@laptop.jp.oracle.com>
	<4E977644.2020902@oracle.com>
	<20111014001913.GA5162@laptop.jp.oracle.com>
	<4E97818A.5070902@oracle.com>
Message-ID: <20111014085713.GB13004@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-10-13 17:25, Sunil Mushran wrote:
> http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=commitdiff;h=ff0a522e7db79625aa27a433467eb94c5e255718

Problem reproduced(against mainline) with the above patch applied. Also with the hacking
patch(attached).

testcase is attached.

(kworker/u:2,14465,1):dlm_assert_master_handler:1828 ERROR: DIE! Mastery
assert from 0, but current owner is 1! (master)
lockres: master, owner=1, state=0
  last used: 0, refcnt: 3, on purge list: no
  on dirty list: no, on reco list: no, migrating pending: no
  inflight locks: 0, asts reserved: 0
  refmap nodes: [ ], inflight=0
  granted queue:
    type=5, conv=-1, node=1, cookie=1:28, ref=2, ast=(empty=y,pend=n),
bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
  converting queue:
  blocked queue:
------------[ cut here ]------------
kernel BUG at fs/ocfs2/dlm/dlmmaster.c:1830!
invalid opcode: 0000 [#1] SMP 
Modules linked in: netconsole ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
ocfs2_nodemanager ocfs2_stackglue configfs ip6table_filter ip6_tables
ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp llc
nfs lockd fscache auth_rpcgss nfs_acl sunrpc cpufreq_ondemand
acpi_cpufreq mperf ipv6 iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi dm_multipath kvm_intel kvm uinput
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer snd soundcore ppdev parport_pc parport
i2c_i801 snd_page_alloc pcspkr serio_raw tg3 libphy dcdbas ext4 jbd2
i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded:
microcode]

Pid: 14465, comm: kworker/u:2 Not tainted 3.0.0-rc5+ #159 Dell Inc.
OptiPlex 745                 /0MM599
EIP: 0060:[<fc4f1d59>] EFLAGS: 00010246 CPU: 1
EIP is at dlm_assert_master_handler+0x260/0x804 [ocfs2_dlm]
EAX: 00000014 EBX: f2db1700 ECX: c0a74ec0 EDX: 00000046
ESI: 00000001 EDI: f3195800 EBP: f326bf28 ESP: f326bef8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/u:2 (pid: 14465, ti=f326a000 task=f2d8cc80
task.ti=f326a000)
Stack:
 f326bf10 f3195928 f3195928 0009b6c2 f2fae020 c9843e97 00000006 f3195838
 00000000 f2eb0600 f5667a40 f2fae000 f326bf70 fc2a0477 f326bf60 c497ecb5
 00000561 f2d8cf60 f2d8cc80 f2eb060c 000003a0 fc2a5c04 f2eb0708 f5667a40
Call Trace:
 [<fc2a0477>] o2net_rx_until_empty+0x5f9/0x708 [ocfs2_nodemanager]
 [<c044f7a9>] process_one_work+0x12b/0x210
 [<fc29fe7e>] ? o2net_sc_reset_idle_timer+0x8b/0x8b [ocfs2_nodemanager]
 [<c0450000>] worker_thread+0xb9/0x133
 [<c044ff47>] ? manage_workers+0x150/0x150
 [<c0452d7b>] kthread+0x67/0x6c
 [<c0452d14>] ? kthread_worker_fn+0x119/0x119
 [<c077dfba>] kernel_thread_helper+0x6/0x10

thanks,
wengang.
> 
> Are you sure you have this patch?
> 
> On 10/13/2011 05:19 PM, Wengang Wang wrote:
> >2.6.18-128.xxxx
> >
> >thanks,
> >wengang.
> >On 11-10-13 16:37, Sunil Mushran wrote:
> >>which kernel?
> >>
> >>On 10/13/2011 04:35 PM, Wengang Wang wrote:
> >>>On 11-10-13 09:09, Sunil Mushran wrote:
> >>>>The last email you said it reproduced. Now you say it did not.
> >>>>I'm confused.
> >>>Oh? Did I. If I did, I meant it had reproductions in different customers's ENV,
> >>>I had no reproduction in house.
> >>>
> >>>Sorry for confusion :P
> >>>
> >>>thanks,
> >>>wengang.
> >>>>On 10/12/2011 07:13 PM, Wengang Wang wrote:
> >>>>>On 11-10-12 19:11, Sunil Mushran wrote:
> >>>>>>That's what ovm does. Have you reproduced it with ovm3 kernel?
> >>>>>>
> >>>>>No, I have no reproductions.
> >>>>>
> >>>>>thanks,
> >>>>>wengang.
> >>>>>>On 10/12/2011 07:07 PM, Wengang Wang wrote:
> >>>>>>>On 11-10-13 09:51, Wengang Wang wrote:
> >>>>>>>>On 11-10-12 18:47, Sunil Mushran wrote:
> >>>>>>>>>I meant master_request (not query). We set refmap _before_
> >>>>>>>>>asserting. So that should not happen.
> >>>>>>>>Why can't the remote node requested deref (DLM_DEREF_LOCKRES_MSG)?
> >>>>>>>The problem can easily happen on this dlmfs useage:
> >>>>>>>
> >>>>>>>reopen:
> >>>>>>>	open(create) /dlm/dirxx/filexx
> >>>>>>>	close	     /dlm/dirxx/filexx
> >>>>>>>	sleep 60
> >>>>>>>	goto reopen
> >>>>>>>
> >>>>>>>>thanks,
> >>>>>>>>wengang.
> >>>>>>>>>On 10/12/2011 06:02 PM, Wengang Wang wrote:
> >>>>>>>>>>Hi Sunil,
> >>>>>>>>>>
> >>>>>>>>>>On 11-10-12 17:32, Sunil Mushran wrote:
> >>>>>>>>>>>So you are saying a lockres can get purged before the node is asserting
> >>>>>>>>>>>master to other nodes?
> >>>>>>>>>>>
> >>>>>>>>>>>The main place where we dispatch assert is during master_query.
> >>>>>>>>>>>There we set refmap before dispatching. Meaning refmap will protect
> >>>>>>>>>>>us from purging.
> >>>>>>>>>>>
> >>>>>>>>>>>But I think it could happen in master_requery, which only comes into
> >>>>>>>>>>>play if a node dies during migration.
> >>>>>>>>>>>
> >>>>>>>>>>>Is that the case here?
> >>>>>>>>>>I think this can mainly include the response for a master_request.
> >>>>>>>>>>in dlm_master_request_handler(), the master node quques assert_master.
> >>>>>>>>>>The node which requested a master_request knows the master by receving
> >>>>>>>>>>response values. It doesn't need to wait until the assert_master come.
> >>>>>>>>>>As you know, the asserting master work is done in a workqueue. And the
> >>>>>>>>>>work item in it can be heavily delayed. So in the duriation from the
> >>>>>>>>>>(old) master responding with "Yes, I am master" to it sending assert_master,
> >>>>>>>>>>Anything can heppan, the worse case is the lockres on the (old) master
> >>>>>>>>>>get purged and is remasted by another node. So in this case,
> >>>>>>>>>>apparently, the old master shouldn't send the assert_master any longer.
> >>>>>>>>>>To prevent that from happening, we should keep the lockres un-purged as
> >>>>>>>>>>long as it's queued for master_request.
> >>>>>>>>>>
> >>>>>>>>>>#the problem is what my flush_workqueue patch tries to fix.
> >>>>>>>>>>
> >>>>>>>>>>thanks,
> >>>>>>>>>>wengang.
> >>>>>>>>>>
> >>>>>>>>>>>On 10/12/2011 12:04 AM, Wengang Wang wrote:
> >>>>>>>>>>>>Hi Sunil/Joel/Mark and anyone who has interest,
> >>>>>>>>>>>>
> >>>>>>>>>>>>This is not a patch but a discuss.
> >>>>>>>>>>>>
> >>>>>>>>>>>>Currently we have a problem:
> >>>>>>>>>>>>When a lockres is still queued(in dlm->work_list) for sending an
> >>>>>>>>>>>>assert_master(or in processing of sending), the lockres can't be
> >>>>>>>>>>>>purged(removed from hash). there is no flag/state,on lockres its self,dinotes
> >>>>>>>>>>>>this situation.
> >>>>>>>>>>>>
> >>>>>>>>>>>>The badness is that if the lockres is purged(surely not the owner at the
> >>>>>>>>>>>>moment), and the assert_master is after the purge. it can confuse other
> >>>>>>>>>>>>nodes. On another node, the owner now can be any other nodes, thus on
> >>>>>>>>>>>>receiving the assert_master, it can trigger a BUG() because 'owner'
> >>>>>>>>>>>>doesn't match.
> >>>>>>>>>>>>
> >>>>>>>>>>>>So we'd better to prevent the lockres from be purged when it's queued
> >>>>>>>>>>>>for something(assert_master).
> >>>>>>>>>>>>
> >>>>>>>>>>>>Srini and I discussed some possible fixes:
> >>>>>>>>>>>>1) adding a flag to lockres->state.
> >>>>>>>>>>>>    this does not work. A lockres can have multiple instances in the queue list.
> >>>>>>>>>>>>    A simple flag is not safe. And the instances are not nested, so even
> >>>>>>>>>>>>    saving a previous flags doesn't work. Neither can we merge the instances
> >>>>>>>>>>>>    because they can be for different purposes.
> >>>>>>>>>>>>
> >>>>>>>>>>>>2) checking if the lockres if queued before purging it.
> >>>>>>>>>>>>   this works, but doesn't sounds good. it needs changes of current behaviour
> >>>>>>>>>>>>   on the queue list.   Also, we have no idea on the performance of the checking
> >>>>>>>>>>>>   (searching list).
> >>>>>>>>>>>>
> >>>>>>>>>>>>3) making use of lockres->inflight_locks.
> >>>>>>>>>>>>   this works, but seems to be a mis-use of inflight_locks.
> >>>>>>>>>>>>
> >>>>>>>>>>>>4) adding a new member to lockres counting the queued time.
> >>>>>>>>>>>>    this works and simple. but needs extra memory.
> >>>>>>>>>>>>
> >>>>>>>>>>>>I prefer to the 4).
> >>>>>>>>>>>>
> >>>>>>>>>>>>What's your idea?
> >>>>>>>>>>>>
> >>>>>>>>>>>>thanks,
> >>>>>>>>>>>>wengang.
> >>>>>>>>>>>>
> >>>>>>>>>>>>_______________________________________________
> >>>>>>>>>>>>Ocfs2-devel mailing list
> >>>>>>>>>>>>Ocfs2-devel at oss.oracle.com
> >>>>>>>>>>>>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
-------------- next part --------------
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 03f2236..d80dd95 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2086,6 +2085,7 @@ static void dlm_assert_master_worker(struct dlm_work_item *item, void *data)
 	 * even if one or more nodes die */
 	mlog(0, "worker about to master %.*s here, this=%u\n",
 		     res->lockname.len, res->lockname.name, dlm->node_num);
+	msleep(30000);
 	ret = dlm_do_assert_master(dlm, res, nodemap, flags);
 	if (ret < 0) {
 		/* no need to restart, we are done */
-------------- next part --------------
A non-text attachment was scrubbed...
Name: test_purge.sh
Type: application/x-sh
Size: 372 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20111014/0a8641a4/attachment.sh 
