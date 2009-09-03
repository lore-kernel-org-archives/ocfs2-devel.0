From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 03 Sep 2009 11:21:11 +0800
Subject: [Ocfs2-devel] [PATCH] add assertions to stuffs with
 purge/unused lockres
In-Reply-To: <4A9F2677.4030406@oracle.com>
References: <200908280821.n7S8L8ut026709@rgminet15.oracle.com>
	<4A9F2677.4030406@oracle.com>
Message-ID: <4A9F3627.7050407@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

Sunil Mushran wrote:
> How about we narrow down the issue by dumping the lockres?
> 
> Look in 1.4. We dump the lockres in dlm_purge_lockres().
> __dlm_print_one_lock_resource(res);
> 
> In this case, it appears the user has encountered it more than
> once. Work with Srini to give them a package with the above.
> 
> The idea here is to figure out as to "how" the lockres is in use.
> Is t because of a refmap. Or a new lock. etc.

Yes, by dumping the lockres, we can know how the lockres is in use.
however, we don't know how it becomes in use.
I think with my patch, we can know how.

so, what are the bad points with my patch?

regards,
wengang.

> Wengang Wang wrote:
>> this is more a discusion than a patch.
>>
>> I had an ocfs2 bug(8801298). the problem is that with dlm->spinlock hold,
>> dlm_run_purge_list() think the status of "unuse" of a lockres 
>> shouldn't change
>> from unused to in-use. it checks the status twice(by calling 
>> __dlm_lockres_unused())
>> and found the status changed from unused to in-use then calls a BUG() 
>> to panic.
>> the only avaible info is just the BUG() info. however there are 
>> serveral possibility
>> casing the status change. so I stuck there -- I am not able to go any 
>> further..
>>
>> If we can detect the problem in each possibility, it will be better. 
>> so I wrote
>> the patch. the patch does:
>> 1) removes the lockres from purge list(if it's in the list) in 
>> __dlm_lookup_lockres_full().
>>    --if found in __dlm_lookup_lockres_full(), the lockres is going to 
>> be in-use
>>      very soon, so remove it from purge list.
>>
>> 2) encapsulates operations that adds/removes/moves dlm_lock to/from 
>> granted/
>>    converting/blocked lists of a lockres into functions. in the 
>> functions, there
>>    are assertions that check mainly if the lockres is not in purge list.
>>    --it can detect the 8801298 BUG ealier.
>>
>> 3) encapsulates operations that clear/set refmap_bit into functions 
>> which does
>>    same assertion as in 2).
>>    --it can detect the 8801298 BUG ealier.
>>
>> 4) encapsulates operations that adds/removes/re-adds lockres to/from 
>> dlm->purge_list
>>    into functions that does assertions as in 2)
>>    --it can detect the 8801298 BUG ealier.
>>
>> 5) encapsulates operations that adds/removes lockres to/from 
>> dlm->dirty_list.
>>    into functions that does assertions as in 2)
>>    --it can detect the 8801298 BUG ealier.
>>
>> 6) what I think they could be bugs
>>    6.1) adds spinlock protection on the operation that remove lockres 
>> from purgelist.
>>    6.2) moves the two operation
>>                a) removes lockres from dirty list;
>>                b) remove DLM_LOCK_RES_DIRTY flag from the lockres
>>         into one atomic operation(in protection of res->spinlock).
>>         --I think both checking list_emtry(&res->dirty) and 
>> DLM_LOCK_RES_DIRTY
>>           is ugly. if the above is reasonable, maybe we can remove the 
>> DLM_LOCK_RES_DIRTY
>>           flag later..
>>
>> for 2), 4) and 5), I don't know if it's a good idea --developers maybe 
>> still
>> using the original list_add_tail()/list_del_init ..
>> for 6), maybe I should make separate patches..
>>
>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
