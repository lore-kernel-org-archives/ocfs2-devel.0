From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 07 Dec 2009 17:57:19 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: don't leave free'd mle
 attached to hb events
In-Reply-To: <4B1DAF57.5020404@oracle.com>
References: <200912071453.nB6Mhdbo021627@rgminet13.oracle.com>
	<4B1D76B1.1020404@oracle.com> <4B1DAF57.5020404@oracle.com>
Message-ID: <4B1DB27F.1020008@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

oops... I read it incorrectly. But that does not sound right.
Let me think about it.

Wengang Wang wrote:
> Hi Sunil,
>
> Sunil Mushran wrote:
>> NAK
>>
>> wengang wang wrote:
>>> don't leave free'd mle attached to hb events.
>>>     in dlm_add_migration_mle() the mle is attched to "heartbeat 
>>> events" anyway no
>>> matter there is an existing mle with same name(returns -EEXIST).
>>> dlm_migrate_lockres() calls dlm_add_migration_mle(). in case the 
>>> later function
>>> returning -EEXIST, dlm_migrate_lockres() frees the (new) mle without 
>>> detaching
>>> it from "hb events". so that later "hb events" related operations 
>>> could improperly
>>> operate against wrong mle objects or against an invalid memory address.
>>
>> The mle is attached to hb events in dlm_init_mle() which is not called
>> if it returns -EEXIST. When it returns -EEXIST, oldmle is set to the
>> existing mle and its refcounting is handled correctly. mle is not 
>> touched
>> and thus only needs to be freed.
>>
>
> Maybe I am wrong. but are you sure dlm_init_mle() is not called when 
> it returns -EEXIST?
> in code, it doesn't return immediately after setting ret with -EEXIST, 
> but continue to call
> dlm_init_mle();
> and then
> mle->new_master = new_master;
>
> Maybe I am wrong somewhere?
> simplified code pasted here:
>
>
> 3098 static int dlm_add_migration_mle(struct dlm_ctxt *dlm,
> 3099                                  struct dlm_lock_resource *res,
> 3100                                  struct dlm_master_list_entry *mle,
> 3101                                  struct dlm_master_list_entry 
> **oldmle,
> 3102                                  const char *name, unsigned int 
> namelen,
> 3103                                  u8 new_master, u8 master)
> 3104 {
> 3116         found = dlm_find_mle(dlm, oldmle, (char *)name, namelen);
> 3117         if (found) {
> 3118                 struct dlm_master_list_entry *tmp = *oldmle;
> 3120                 if (tmp->type == DLM_MLE_MIGRATION) {
> 3121                         if (master == dlm->node_num) {
> 3126                                 ret = -EEXIST;
> 3127                         } else {
> 3136                                 BUG();
> 3137                         }
> 3138                 } else {
>                  ....
> 3151                 }
> 3153         }
> 3154
> 3156         dlm_init_mle(mle, DLM_MLE_MIGRATION, dlm, res, name, 
> namelen);
> 3157         mle->new_master = new_master;
>          ......
> 3163         __dlm_insert_mle(dlm, mle);
> 3164
> 3165         return ret;
> 3166 }
>
>
> regards,
> wengang.
