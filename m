From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Fri, 27 Feb 2015 18:38:28 +0900
Subject: [Ocfs2-devel] + ocfs2-remove-unneeded-rc-for-kfree.patch added
	to -mm tree
In-Reply-To: <54F0177D.1090902@huawei.com>
References: <54e3cf77.u8mie52zQedDwSSV%akpm@linux-foundation.org>
	<54F0177D.1090902@huawei.com>
Message-ID: <CAHb8M2DgnxoTVqQvqHJQbQGvxxB3tDg7FBrbv5kX89025bBuJg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, mfasheh@suse.com, mm-commits@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

2015-02-27 16:06 GMT+09:00 Joseph Qi <joseph.qi@huawei.com>:
> We can only free conn->cc_private if error occurs. Otherwise it will
> trigger a bug in o2cb_cluster_disconnect since conn->cc_private has
> already been freed.
> So please drop this patch, thanks.
Yes. right..

Sorry for noise.

Thanks.
Daeseok Youn.
>
> On 2015/2/18 7:32, akpm at linux-foundation.org wrote:
>>
>> The patch titled
>>      Subject: ocfs2: remove unneeded 'rc' for kfree()
>> has been added to the -mm tree.  Its filename is
>>      ocfs2-remove-unneeded-rc-for-kfree.patch
>>
>> This patch should soon appear at
>>     http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unneeded-rc-for-kfree.patch
>> and later at
>>     http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unneeded-rc-for-kfree.patch
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>
>> The -mm tree is included into linux-next and is updated
>> there every 3-4 working days
>>
>> ------------------------------------------------------
>> From: Daeseok Youn <daeseok.youn@gmail.com>
>> Subject: ocfs2: remove unneeded 'rc' for kfree()
>>
>> If kzalloc() failed, just goto 'out' label and 'out_free' label doesn't
>> need to check 'rc' variable.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> Cc: Mark Fasheh <mfasheh@suse.com>
>> Cc: Joel Becker <jlbec@evilplan.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  fs/ocfs2/stack_o2cb.c |    5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff -puN fs/ocfs2/stack_o2cb.c~ocfs2-remove-unneeded-rc-for-kfree fs/ocfs2/stack_o2cb.c
>> --- a/fs/ocfs2/stack_o2cb.c~ocfs2-remove-unneeded-rc-for-kfree
>> +++ a/fs/ocfs2/stack_o2cb.c
>> @@ -347,7 +347,7 @@ static int o2cb_cluster_connect(struct o
>>       priv = kzalloc(sizeof(struct o2dlm_private), GFP_KERNEL);
>>       if (!priv) {
>>               rc = -ENOMEM;
>> -             goto out_free;
>> +             goto out;
>>       }
>>
>>       /* This just fills the structure in.  It is safe to pass conn. */
>> @@ -376,8 +376,7 @@ static int o2cb_cluster_connect(struct o
>>       dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
>>
>>  out_free:
>> -     if (rc)
>> -             kfree(conn->cc_private);
>> +     kfree(conn->cc_private);
>>
>>  out:
>>       return rc;
>> _
>>
>> Patches currently in -mm which might be from daeseok.youn at gmail.com are
>>
>> origin.patch
>> ocfs2-remove-unneeded-rc-for-kfree.patch
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
>> the body of a message to majordomo at vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> .
>>
>
>
