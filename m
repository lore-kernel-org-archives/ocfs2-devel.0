From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 4 Jun 2010 13:37:36 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: cancel the migration or redo
 deref to recovery master
In-Reply-To: <4C086255.4030300@oracle.com>
References: <4C0851AF.1030803@oracle.com>
	<20100604014340.GB2415@laptop.us.oracle.com>
	<4C086255.4030300@oracle.com>
Message-ID: <20100604053736.GC2415@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Srini,

On 10-06-03 19:17, Srinivas Eeda wrote:
>>> Can you please explain the idea of the new flag
>>> DLM_LOCK_RES_DE_DROP_REF :)
>>>
>>> If the idea of the fix is to address the race between purging and
>>> recovery, I am wondering DLM_LOCK_RES_DROPPING_REF and
>>> DLM_LOCK_RES_RECOVERING flags may be enough to fix this problem.
>>> dlm_move_lockres_to_recovery_list moves lockres to resources list
>>> (which tracks of resources that needs recovery) and sets the flag
>>> DLM_LOCK_RES_RECOVERING. If we do not call
>>> dlm_move_lockres_to_recovery_list for the resource which have
>>> DLM_LOCK_RES_DROPPING_REF set they will not get migrated. In that
>>> case DLM_LOCK_RES_RECOVERING will not get set and the recovery
>>> master wouldn't know about this and the lockres that is in the
>>> middle of purging will get purged.
>>>
>>> For the lockres that got moved to resource list they will get
>>> migrated. In that case lockres has DLM_LOCK_RES_RECOVERING.flag set.
>>> So dlm_purge_list should consider this as being used and should
>>> defer purging. the lockres will get recovered and the new owner will
>>> be set and the flag DLM_LOCK_RES_RECOVERING. will get removed.
>>> dlm_purge_list can now go ahead and purge this lockres.
>>>
>>
>> I am following your idea. Addtion to your idea is that we also notice
>> that we shouldn't send the DEREF request to the recovery master if we
>> don't migrate the lockres to the recovery master(otherwise, another
>> BUG() is triggered). DLM_LOCK_RES_DE_DROP_REF is for that purpose.
>> When
>> we ignore migrating a lockres, we set this state.
>>
>The case we don't migrate the lockres is only when it's dropping the
>reference right(when DLM_LOCK_RES_DROPPING_REF is set). In that case we
>just unhash and free the lockres.

How do you determine whether it's in "that case" in code? I determine that by
checking the DLM_LOCK_RES_DE_DROP_REF state.

regards,
wengang.
