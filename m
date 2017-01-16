From: Eric Ren <zren@suse.com>
Date: Mon, 16 Jan 2017 11:31:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/dlmglue: prepare tracking logic
 to avoid recursive cluster lock
In-Reply-To: <18438355-5e33-3efc-cc88-05f877652b4b@oracle.com>
References: <1483630262-22227-1-git-send-email-zren@suse.com>
	<1483630262-22227-2-git-send-email-zren@suse.com>
	<7605c419-b724-1277-acac-7439fcb6670b@oracle.com>
	<5ea23e68-1fb7-391d-4171-3efc877003bc@suse.com>
	<18438355-5e33-3efc-cc88-05f877652b4b@oracle.com>
Message-ID: <f347aaf5-cd16-d2f1-477f-375aa8de9210@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, jiangqi903@gmail.com, linux-kernel@vger.kernel.org

Hi Junxiao,
>> OK, good suggestion. Hrm, but in order to align with "ocfs2_inc_holders", I
>> think it's good to keep those function names as it is;-)
> that name is also not very clear. Maybe you can make another patch to
> clear it.

Maybe, the name completeness needs to compromise with the name length at
some time.  One of basic rules is whether the name may confuse the reader.
In this case,  "ocfs2_inc_holders"  in dlmglue.c sounds good to me, not ambiguous.

I want to go with it. Anyone who don't like the name can propose their patch for it;-)

Thanks,
Eric

>
> Thanks,
> Junxiao.
>
>
>> Thanks for your review!
>> Eric
>>
>>> Thanks,
>>> Junxiao.
>>>
>>>> +    struct list_head oh_list;
>>>> +    struct pid *oh_owner_pid;
>>>> +};
>>>> +
>>>>    /* ocfs2_inode_lock_full() 'arg_flags' flags */
>>>>    /* don't wait on recovery. */
>>>>    #define OCFS2_META_LOCK_RECOVERY    (0x01)
>>>> @@ -77,6 +82,8 @@ struct ocfs2_orphan_scan_lvb {
>>>>    #define OCFS2_META_LOCK_NOQUEUE        (0x02)
>>>>    /* don't block waiting for the downconvert thread, instead return
>>>> -EAGAIN */
>>>>    #define OCFS2_LOCK_NONBLOCK        (0x04)
>>>> +/* just get back disk inode bh if we've got cluster lock. */
>>>> +#define OCFS2_META_LOCK_GETBH        (0x08)
>>>>      /* Locking subclasses of inode cluster lock */
>>>>    enum {
>>>> @@ -170,4 +177,15 @@ void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug
>>>> *dlm_debug);
>>>>      /* To set the locking protocol on module initialization */
>>>>    void ocfs2_set_locking_protocol(void);
>>>> +
>>>> +/*
>>>> + * Keep a list of processes who have interest in a lockres.
>>>> + * Note: this is now only uesed for check recursive cluster lock.
>>>> + */
>>>> +inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
>>>> +                 struct ocfs2_holder *oh);
>>>> +inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
>>>> +                 struct ocfs2_holder *oh);
>>>> +inline struct ocfs2_holder *ocfs2_is_locked_by_me(struct
>>>> ocfs2_lock_res *lockres);
>>>> +
>>>>    #endif    /* DLMGLUE_H */
>>>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>>>> index 7e5958b..0c39d71 100644
>>>> --- a/fs/ocfs2/ocfs2.h
>>>> +++ b/fs/ocfs2/ocfs2.h
>>>> @@ -172,6 +172,7 @@ struct ocfs2_lock_res {
>>>>          struct list_head         l_blocked_list;
>>>>        struct list_head         l_mask_waiters;
>>>> +    struct list_head     l_holders;
>>>>          unsigned long         l_flags;
>>>>        char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
>>>>
>
