From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 14 Oct 2011 08:19:13 +0800
Subject: [Ocfs2-devel] avoid being purged when queued for assert_master
In-Reply-To: <4E977644.2020902@oracle.com>
References: <4E963190.1080803@oracle.com>
	<20111013010229.GA3680@laptop.jp.oracle.com>
	<4E964332.1020201@oracle.com>
	<20111013015137.GA5565@laptop.jp.oracle.com>
	<20111013020712.GB5565@laptop.jp.oracle.com>
	<4E9648E1.3070508@oracle.com>
	<20111013021356.GD5565@laptop.jp.oracle.com>
	<4E970D2E.2080206@oracle.com>
	<20111013233549.GA2982@laptop.jp.oracle.com>
	<4E977644.2020902@oracle.com>
Message-ID: <20111014001913.GA5162@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

2.6.18-128.xxxx

thanks,
wengang.
On 11-10-13 16:37, Sunil Mushran wrote:
> which kernel?
> 
> On 10/13/2011 04:35 PM, Wengang Wang wrote:
> >On 11-10-13 09:09, Sunil Mushran wrote:
> >>The last email you said it reproduced. Now you say it did not.
> >>I'm confused.
> >Oh? Did I. If I did, I meant it had reproductions in different customers's ENV,
> >I had no reproduction in house.
> >
> >Sorry for confusion :P
> >
> >thanks,
> >wengang.
> >>On 10/12/2011 07:13 PM, Wengang Wang wrote:
> >>>On 11-10-12 19:11, Sunil Mushran wrote:
> >>>>That's what ovm does. Have you reproduced it with ovm3 kernel?
> >>>>
> >>>No, I have no reproductions.
> >>>
> >>>thanks,
> >>>wengang.
> >>>>On 10/12/2011 07:07 PM, Wengang Wang wrote:
> >>>>>On 11-10-13 09:51, Wengang Wang wrote:
> >>>>>>On 11-10-12 18:47, Sunil Mushran wrote:
> >>>>>>>I meant master_request (not query). We set refmap _before_
> >>>>>>>asserting. So that should not happen.
> >>>>>>Why can't the remote node requested deref (DLM_DEREF_LOCKRES_MSG)?
> >>>>>The problem can easily happen on this dlmfs useage:
> >>>>>
> >>>>>reopen:
> >>>>>	open(create) /dlm/dirxx/filexx
> >>>>>	close	     /dlm/dirxx/filexx
> >>>>>	sleep 60
> >>>>>	goto reopen
> >>>>>
> >>>>>>thanks,
> >>>>>>wengang.
> >>>>>>>On 10/12/2011 06:02 PM, Wengang Wang wrote:
> >>>>>>>>Hi Sunil,
> >>>>>>>>
> >>>>>>>>On 11-10-12 17:32, Sunil Mushran wrote:
> >>>>>>>>>So you are saying a lockres can get purged before the node is asserting
> >>>>>>>>>master to other nodes?
> >>>>>>>>>
> >>>>>>>>>The main place where we dispatch assert is during master_query.
> >>>>>>>>>There we set refmap before dispatching. Meaning refmap will protect
> >>>>>>>>>us from purging.
> >>>>>>>>>
> >>>>>>>>>But I think it could happen in master_requery, which only comes into
> >>>>>>>>>play if a node dies during migration.
> >>>>>>>>>
> >>>>>>>>>Is that the case here?
> >>>>>>>>I think this can mainly include the response for a master_request.
> >>>>>>>>in dlm_master_request_handler(), the master node quques assert_master.
> >>>>>>>>The node which requested a master_request knows the master by receving
> >>>>>>>>response values. It doesn't need to wait until the assert_master come.
> >>>>>>>>As you know, the asserting master work is done in a workqueue. And the
> >>>>>>>>work item in it can be heavily delayed. So in the duriation from the
> >>>>>>>>(old) master responding with "Yes, I am master" to it sending assert_master,
> >>>>>>>>Anything can heppan, the worse case is the lockres on the (old) master
> >>>>>>>>get purged and is remasted by another node. So in this case,
> >>>>>>>>apparently, the old master shouldn't send the assert_master any longer.
> >>>>>>>>To prevent that from happening, we should keep the lockres un-purged as
> >>>>>>>>long as it's queued for master_request.
> >>>>>>>>
> >>>>>>>>#the problem is what my flush_workqueue patch tries to fix.
> >>>>>>>>
> >>>>>>>>thanks,
> >>>>>>>>wengang.
> >>>>>>>>
> >>>>>>>>>On 10/12/2011 12:04 AM, Wengang Wang wrote:
> >>>>>>>>>>Hi Sunil/Joel/Mark and anyone who has interest,
> >>>>>>>>>>
> >>>>>>>>>>This is not a patch but a discuss.
> >>>>>>>>>>
> >>>>>>>>>>Currently we have a problem:
> >>>>>>>>>>When a lockres is still queued(in dlm->work_list) for sending an
> >>>>>>>>>>assert_master(or in processing of sending), the lockres can't be
> >>>>>>>>>>purged(removed from hash). there is no flag/state,on lockres its self,dinotes
> >>>>>>>>>>this situation.
> >>>>>>>>>>
> >>>>>>>>>>The badness is that if the lockres is purged(surely not the owner at the
> >>>>>>>>>>moment), and the assert_master is after the purge. it can confuse other
> >>>>>>>>>>nodes. On another node, the owner now can be any other nodes, thus on
> >>>>>>>>>>receiving the assert_master, it can trigger a BUG() because 'owner'
> >>>>>>>>>>doesn't match.
> >>>>>>>>>>
> >>>>>>>>>>So we'd better to prevent the lockres from be purged when it's queued
> >>>>>>>>>>for something(assert_master).
> >>>>>>>>>>
> >>>>>>>>>>Srini and I discussed some possible fixes:
> >>>>>>>>>>1) adding a flag to lockres->state.
> >>>>>>>>>>    this does not work. A lockres can have multiple instances in the queue list.
> >>>>>>>>>>    A simple flag is not safe. And the instances are not nested, so even
> >>>>>>>>>>    saving a previous flags doesn't work. Neither can we merge the instances
> >>>>>>>>>>    because they can be for different purposes.
> >>>>>>>>>>
> >>>>>>>>>>2) checking if the lockres if queued before purging it.
> >>>>>>>>>>   this works, but doesn't sounds good. it needs changes of current behaviour
> >>>>>>>>>>   on the queue list.   Also, we have no idea on the performance of the checking
> >>>>>>>>>>   (searching list).
> >>>>>>>>>>
> >>>>>>>>>>3) making use of lockres->inflight_locks.
> >>>>>>>>>>   this works, but seems to be a mis-use of inflight_locks.
> >>>>>>>>>>
> >>>>>>>>>>4) adding a new member to lockres counting the queued time.
> >>>>>>>>>>    this works and simple. but needs extra memory.
> >>>>>>>>>>
> >>>>>>>>>>I prefer to the 4).
> >>>>>>>>>>
> >>>>>>>>>>What's your idea?
> >>>>>>>>>>
> >>>>>>>>>>thanks,
> >>>>>>>>>>wengang.
> >>>>>>>>>>
> >>>>>>>>>>_______________________________________________
> >>>>>>>>>>Ocfs2-devel mailing list
> >>>>>>>>>>Ocfs2-devel at oss.oracle.com
> >>>>>>>>>>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
